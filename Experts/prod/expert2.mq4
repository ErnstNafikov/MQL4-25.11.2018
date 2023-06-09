//+------------------------------------------------------------------+
//|                                                     OutTick1.mq4 |
//|                        Copyright 2017, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2017, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
input int Tick_k = 2;
//--- параметры для записи данных в файл 
input string             InpFileName="Session1.txt";       // Имя файла 
input string             InpDirectoryName="Data";     // Имя каталога 
double price[2];bool start_price=true; 
string save = "";int k=0,s_k=0,k_arr=0;
string arr[];
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//---
   int buf = (int)(Bid*MathPow(10,Digits))/Tick_k;
   buf *= Tick_k;
   if(MathAbs((Bid*MathPow(10,Digits))-buf)>Tick_k/2)
      buf += Tick_k;  
   price[0] = (double)(buf-Tick_k/2)/MathPow(10,Digits);
   price[1] = (double)(buf+Tick_k/2)/MathPow(10,Digits);
   ArrayResize(arr,1000,1000);
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---
   int file_handle=FileOpen(InpDirectoryName+"//"+InpFileName,FILE_READ|FILE_WRITE|FILE_TXT|FILE_ANSI);
   for(int i=0;i<k_arr;i++)
      FileWriteString(file_handle,arr[i]);
   if(save != "")   
      FileWriteString(file_handle,save+"\r\n");
   FileClose(file_handle); 
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
//--- 
   if(price[0]>=Bid)
      {save+="0";k++;
      price[0] -= (double)Tick_k/MathPow(10,Digits);
      if(!start_price)
      price[1] -= (double)Tick_k/MathPow(10,Digits);
      start_price=false;}
   else if(price[1]<=Bid)
      {save+="1";k++;
      if(!start_price)
      price[0] += (double)Tick_k/MathPow(10,Digits);
      price[1] += (double)Tick_k/MathPow(10,Digits);
      start_price=false;}
         
   if(k%10 == 0 && s_k != k)
   {
      save+="\r\n";
      s_k = k;
      if(k == 10000)
      {
         k = 0;s_k = 0;
         arr[k_arr] = save;
         k_arr++;
         save = "";
      }
   }
 
  }
//+------------------------------------------------------------------+
