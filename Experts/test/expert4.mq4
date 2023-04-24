//+------------------------------------------------------------------+
//|                                                       robot3.mq4 |
//|                        Copyright 2017, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2017, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
input int cmd = 0;//0-BUY 1-SELL
bool up,down,check,start_check;
int profit=0,damage=0, ticket,max,min,max_k,min_k;
datetime time_old;

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
   up=true;
   down=true;
   start_check=false;
   max=0;
   min=0;
   max_k=0;
   min_k=0;
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
      if(NewBar(time_old,TimeCurrent())){
      if(check){
      if(down){if(iOpen(NULL,0,1)>iClose(NULL,0,1)){max_k++;profit++;if(min_k>min)min=min_k;min_k=0;}else {min_k++;damage++;if(max_k>max)max=max_k;max_k=0;}}
      if(up){if(iOpen(NULL,0,1)<iClose(NULL,0,1)){max_k++;profit++;if(min_k>min)min=min_k;min_k=0;}else {min_k++;damage++;if(max_k>max)max=max_k;max_k=0;}}}else if(start_check)check=true;}
      time_old=TimeCurrent();
      if(down && iCustom(NULL,0,"ZigZag",5,5,3,1,0)!=0){up = true;down=false;check=false;start_check=true;}
      if(up && iCustom(NULL,0,"ZigZag",5,5,3,2,0)!=0){up = false;down=true;check=false;start_check=true;}
      
      Print(profit,"/",damage);
      Print(max,"/",min);
      //if(cmd==0 && up) ticket=OrderSend(Symbol(),cmd,0.01,price_fix,3); 
      //if(cmd==1 && down) ticket=OrderSend(Symbol(),cmd,0.01,price_fix,3);
  }
//+------------------------------------------------------------------+
