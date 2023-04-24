//+------------------------------------------------------------------+
//|                                                         tik4.mq4 |
//|                        Copyright 2018, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2018, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
double old_price,output_i[99999],output_buf[99999],Sum;
int del_price,k_start;
uint old_time,del_time;
datetime time_old;
bool NewBar(datetime time1,datetime time0)
   {
   if(time0%(60*5)<time1%(60*5))
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
   old_price = Bid;
   old_time = GetTickCount();
   del_time = 10000;
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

}
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
{
//---
   if(NewBar(time_old,TimeCurrent()))
   {
      k_start = 0;
   }
   del_price = (int)MathRound((Bid-old_price)/Point())*10;
   old_price = Bid;
   if(GetTickCount()!=old_time)
   {
      del_time = (int)(GetTickCount()-old_time);  
      old_time = GetTickCount();
   }
   if(del_time!=0)
   {
      //if(k_start>0)
      //{
         k_start++;
         output_i[k_start] = (double)del_price/del_time;
         Sum = 0;
         for(int i=0;i<k_start;i++)
            Sum+=output_i[i];
      //}
      /*
      else
      {
         ArrayCopy(output_buf,output_i,0,0,WHOLE_ARRAY);
         ArrayCopy(output_i,output_buf,1,0,2);
         output_i[0] = (double)del_price/del_time;
         Sum = 0;
         for(int i=0;i<3;i++)
            Sum+=output_i[i];
      }*/
   }
  
   Print((string)Sum);
   time_old = TimeCurrent();
}
//+------------------------------------------------------------------+
