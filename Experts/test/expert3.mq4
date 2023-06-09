//+------------------------------------------------------------------+
//|                                                       robot3.mq4 |
//|                        Copyright 2017, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2017, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
//input int cmd = 0;//0-BUY 1-SELL
input bool up1 = true;
input bool down1 = true;
input double vol = 0.01; // Объем сделки
input double max_vol = 0.10; // Объем сделки
input int Period_CCI = 24; // Периор усреднения CCI
input double Profit = 0.5; // Прибль
bool up,down,up_CCI,down_CCI,check_OC,send,time;
double profit=0,damage=0;
int ticket,CII1;
string close;
datetime old_time;
int CCI_f()
  {
   double c0 =iCCI(NULL,0,Period_CCI,PRICE_TYPICAL,1);
   double c1 =iCCI(NULL,0,Period_CCI,PRICE_TYPICAL,2);
   if(c0>500)return(6);
   if(c0<=500 && c0>400)return(5);
   if(c0<=400 && c0>300)return(4);
   if(c0<=300 && c0>200)return(3);
   if(c0<=200 && c0>100)return(2);
   if(c0<=100 && c0>0)return(1);
   if(c0<0 && c0>-100)return(-1);
   if(c0<=-100 && c0>-200)return(-2);
   if(c0<=-200 && c0>-300)return(-3);
   if(c0<=-300 && c0>-400)return(-4);
   if(c0<=-400 && c0>=-500)return(-5);
   if(c0<-500)return(-6);
   return(0);
  };
void CCI_o()
  {
   int CII0 = CCI_f();
   if(CII1 != CII0)
     {
      
      if(CII1 < CII0)
        {
         close = "down";
        }else{
         close = "up";
        }
      if(CII1 < CII0 && 0 < CII0){up_CCI = true;}
      else up_CCI = false;
      if(CII1 > CII0 && 0 > CII0){down_CCI = true;}
      else down_CCI = false;
      CII1 = CII0;
     }
  };
void OC_1()
  {
   int total=OrdersTotal(); 
   for(int pos=0;pos<total;pos++) 
     {
      bool OS = OrderSelect(pos,SELECT_BY_POS);
      bool OC = false;
      if(OrderComment()=="up" && (close=="up" || close=="all"))
        {
            OC = OrderClose(OrderTicket(),OrderLots(),Bid,3); 
        }
      if(OrderComment()=="down" && (close=="down" || close=="all"))
        { 
            OC = OrderClose(OrderTicket(),OrderLots(),Ask,3);
        }      
      if(!OC){check_OC=false;pos=total;}
      else check_OC=true;
     }
  };
bool NewBar()
  {
   if(TimeCurrent()%(60*_Period)<old_time%(60*_Period))
     {
      old_time = TimeCurrent();
      return true;
     }
   else 
     {
      old_time = TimeCurrent();
      return false; 
     }
  };
double OV()
  {
   int total=OrdersTotal();
   double sum=0; 
   for(int pos=0;pos<total;pos++) 
     {
      bool OS = OrderSelect(pos,SELECT_BY_POS);
      sum+=OrderLots();
     }
   return sum;
  };
bool OP()
  {
   int total=OrdersTotal();
   double sum=0; 
   for(int pos=0;pos<total;pos++) 
     {
      bool OS = OrderSelect(pos,SELECT_BY_POS);
      if(OrderComment()==close)   
         sum+=OrderProfit();
     }
   if(Profit<=sum)
      return true;
   else
      return false;
  };
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//---
   up = up1;
   down = down1;
   send = false;
   up_CCI = false;
   down_CCI = false;
   old_time = TimeCurrent();
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---
   
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
//---
      if(NewBar()){time=true;CCI_o();}
      if(!check_OC || OP())OC_1();
      if(down && iCustom(NULL,0,"ZigZag",5,5,3,1,0)!=0){up = true;down=false;send = true;}
      if(up && iCustom(NULL,0,"ZigZag",5,5,3,2,0)!=0){up = false;down=true;send = true;}
       
      if(send && time && max_vol>OV()+vol)
        {
         if(up_CCI || up) ticket = OrderSend(Symbol(),0,vol,Ask,3,NULL,NULL,"up"); 
         if(down_CCI || down) ticket = OrderSend(Symbol(),1,vol,Bid,3,NULL,NULL,"down");
         send = false;
         time = false;
        }
  }
//+------------------------------------------------------------------+
