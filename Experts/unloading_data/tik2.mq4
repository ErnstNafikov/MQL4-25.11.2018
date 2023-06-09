//+------------------------------------------------------------------+
//|                                                          tik.mq4 |
//|                        Copyright 2018, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2018, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
long tiks = 0, sum = 0; 
int max = 0,save = 0,ind = 100, ind_f = 0;
input datetime Date_start = __DATE__;
input string InpDirectoryName = "Data";
datetime time_old;
float I[1],I_buf[100],O[100],Open_pr,Close_pr;
bool NewBar(datetime time1,datetime time0)
   {
   if(time0%(60*60*4)<time1%(60*60*4))
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
   time_old = TimeCurrent();
   ArrayInitialize(I,0);
   ArrayInitialize(I_buf,0);
   ArrayInitialize(O,0);
   Open_pr =(float) Bid;Close_pr =(float) Bid;
//---
   return(INIT_SUCCEEDED);
}
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
{
//---
   printf("tiks="+(string)tiks);
   printf("ind_f="+(string)ind_f);
   printf("sum="+(string)sum);
   printf("max="+(string)max);
}
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
{
//---
   tiks++;
   
   
   
   if(NewBar(time_old,TimeCurrent()))
   {
      Close_pr =(float) Bid;
      float CO = (float)MathRound((Close_pr-Open_pr)/Point());
      //printf((string)CO);
      if(CO>max)max =(int) CO;
      Open_pr =(float) Bid;
      I[0] = CO;
      int file_handle=FileOpen(InpDirectoryName+"//inputCO//I"+(string)ind_f+".txt",FILE_READ|FILE_WRITE|FILE_TXT); 
      if(file_handle!=INVALID_HANDLE) 
         {
            FileWrite(file_handle,CO);
         }
      FileClose(file_handle);
      ind_f++;
      sum += (long)MathAbs(CO);  
   } 
   time_old = TimeCurrent(); 
}
//+------------------------------------------------------------------+
