//+------------------------------------------------------------------+
//|                                                      robots1.mq4 |
//|                        Copyright 2018, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2018, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
input int Prz_bi = 55;  //%
input int Depo = 10000; //RUB
bool buy,sell,buy_ch,sell_ch,buy_op,sell_op; 
double price,sum,poz;
int bkp,bkm,skp,skm,fk,fkmax;
datetime time_old,date;
bool NewBar(datetime time1,datetime time0)
   {
   if(time0%(60*_Period)<time1%(60*_Period))
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
   buy = false;    sell = false;
   buy_ch = false; sell_ch = false;
   buy_op = false; sell_op = false;
   bkp=0;bkm=0;
   skp=0;skm=0;
   sum=0;
   time_old = TimeCurrent();
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---
   Print((string)bkp+"/"+(string)bkm+"/"+(string)skp+"/"+(string)skm);
   Print("Максимальная просадка"+(string)fkmax);
   Print("Депозит"+(string)(Depo+sum));
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
//---
   if(date>0 && NewBar(time_old-date,TimeCurrent()-date))
     {
      if(buy_op)
        {
         if(price<(Bid+Ask)/2){bkp++;fk=0;sum+=poz*Prz_bi/100;}
         else if(price>(Bid+Ask)/2){bkm++;fk++;sum-=poz;}
        }
      if(sell_op)
        {
         if(price>(Bid+Ask)/2){skp++;fk=0;sum+=poz*Prz_bi/100;}
         else if(price<(Bid+Ask)/2){skm++;fk++;sum-=poz;}
        }
      if(fk>fkmax)fkmax=fk;
      date = 0;price = 0;buy=false;sell=false;buy_op = false; sell_op = false;
      Print("Депозит"+(string)(Depo+sum));
     }
   if(price == 0 && iDeMarker(NULL,0,1,0)<0.3)buy_ch=true;
   if(buy_ch && iDeMarker(NULL,0,1,0)>0.3){buy=true;buy_ch=false;}
   if(price == 0 && iDeMarker(NULL,0,1,0)>0.7)sell_ch=true;
   if(sell_ch && iDeMarker(NULL,0,1,0)<0.7){sell=true;sell_ch=false;}
   
   if(buy && price == 0)
     {
      price=(Bid+Ask)/2;
      date = TimeCurrent();
      poz=(Prz_bi/100+fk*100+fk*100)*100/Prz_bi;//MARTUHA
      buy=false;buy_op = true; sell_op = false;
     }
   if(sell && price == 0)
     {
      price=(Bid+Ask)/2;
      date = TimeCurrent();
      poz=100+fk*10000/Prz_bi;//MARTUHA
      sell=false;buy_op = false; sell_op = true;
     }
   time_old = TimeCurrent();
  }
//+------------------------------------------------------------------+
