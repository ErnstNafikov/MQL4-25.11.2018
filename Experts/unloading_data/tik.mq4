//+------------------------------------------------------------------+
//|                                                          tik.mq4 |
//|                        Copyright 2018, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2018, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
long tiks = 0; 
int max = 0,save = 0,ind = 100, ind_f = 0;
input datetime Date_start = __DATE__;
input string InpDirectoryName = "Data";
datetime time_old;
float I[100],I_buf[100],O[100];
bool NewBar(datetime time1,datetime time0)
   {
   if(time0%(60*15)<time1%(60*15))
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
   printf("max="+(string)max);
}
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
{
//---
   tiks++;
   int CO = (int)MathRound((Close[1]-Open[1])/Point());
   //printf((string)CO);
   if(CO>max)max = CO;
   
   
   if(NewBar(time_old,TimeCurrent()))
   {
      ind--;
      
      if(ind<0)
      {
         ind++;
         // I0 -> вывод
         int file_handle=FileOpen(InpDirectoryName+"//input//I"+(string)ind_f+".bin",FILE_READ|FILE_WRITE|FILE_BIN); 
         if(file_handle!=INVALID_HANDLE) 
         {
            FileWriteArray(file_handle,I);
         }
         FileClose(file_handle);
         // O0 -> вывод
         file_handle=FileOpen(InpDirectoryName+"//output//O"+(string)ind_f+".bin",FILE_READ|FILE_WRITE|FILE_BIN); 
         if(file_handle!=INVALID_HANDLE) 
         {
            ArrayInitialize(O,0);
            O[50-CO]=1;
            FileWriteArray(file_handle,O);
         }
         FileClose(file_handle);
         // I0 -> I1
         ArrayInitialize(I_buf,0);
         ArrayCopy(I_buf,I,0,0,99);
         ArrayCopy(I,I_buf);
         I[0] = (float)CO;
         
         //Изменение индекса 
         ind_f++;
      }
      else
      {
         I[ind] = (float)CO;
      }
   } 
   time_old = TimeCurrent(); 
}
//+------------------------------------------------------------------+
