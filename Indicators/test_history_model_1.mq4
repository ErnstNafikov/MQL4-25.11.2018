//+------------------------------------------------------------------+
//|                                                          NS1.mq4 |
//|                        Copyright 2018, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2018, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
#property indicator_chart_window
#property  indicator_buffers 1
#property  indicator_color1  Black
//--- indicator buffers
double     ExtACBuffer[];

input string InpDirectoryName = "Data";

int a = 100;
int a2; 

float Wh[10000],Wo[10000],Bh[100],Bo[100],I[120],H[100],O[100],Os[20];
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- indicator buffers mapping

   //Загрузка
   a2 = a * a;
   for(int i=0;i<a;i++)
   {
      int file_handle=FileOpen(InpDirectoryName+"//job//Wh"+(string)i+".txt",FILE_READ|FILE_WRITE|FILE_TXT); 
      if(file_handle!=INVALID_HANDLE) 
      {
         int j = 0;
         while(!FileIsEnding(file_handle)) 
         { 
            int ind = i*a +j;
            Wh[ind] = (float)StringToDouble(FileReadString(file_handle));
            j++;
         }
      }
      FileClose(file_handle);
      file_handle=FileOpen(InpDirectoryName+"//job//Wo"+(string)i+".txt",FILE_READ|FILE_WRITE|FILE_TXT); 
      if(file_handle!=INVALID_HANDLE) 
      {
         int j = 0;
         while(!FileIsEnding(file_handle)) 
         { 
            int ind = i*a +j;
            Wo[ind] = (float)StringToDouble(FileReadString(file_handle));
            j++;
         }
      }
      FileClose(file_handle);
   }
   int file_handle=FileOpen(InpDirectoryName+"//job//Bh.txt",FILE_READ|FILE_WRITE|FILE_TXT); 
   if(file_handle!=INVALID_HANDLE) 
   {
      int j = 0;
      while(!FileIsEnding(file_handle)) 
      { 
         Bh[j] = (float)StringToDouble(FileReadString(file_handle));
         j++;
      }
   }
   FileClose(file_handle);
   file_handle=FileOpen(InpDirectoryName+"//job//Bo.txt",FILE_READ|FILE_WRITE|FILE_TXT); 
   if(file_handle!=INVALID_HANDLE) 
   {
      int j = 0;
      while(!FileIsEnding(file_handle)) 
      { 
         Bo[j] = (float)StringToDouble(FileReadString(file_handle));
         j++;
      }
   }
   FileClose(file_handle);
   //Print((string)Bh[99]);
   
   //Tick
   
   for(int i=1;i<a+21;i++)
   {
      I[i-1] = (float)(0.01*MathRound((Close[i]-Open[i])/Point()));
   }
   for(int i=0;i<20;i++)
   {
      //Расчет H
      for(int i_s=0;i_s<a;i_s++)
      {
         float Sum = 0;
         for(int j_s=0;j_s<a;j_s++)
         {
            int ind_s = i_s + j_s*a;
            Sum += I[j_s+i]*Wh[ind_s];
         }
         Sum += Bh[i_s];
         H[i_s] = (float)(1/(1+pow(2.718,-Sum)));
      }
      //Расчет O
      for(int i_s=0;i_s<a;i_s++)
      {
         float Sum = 0;
         for(int j_s=0;j_s<a;j_s++)
         {
            int ind_s = i_s + j_s*a;
            Sum += H[j_s]*Wo[ind_s];
         }
         Sum += Bo[i_s];
         O[i_s] = (float)(1/(1+pow(2.718,-Sum)));
      }
      
      //Ответ Нейросети
      float max_o = -1000;
      int ind_max_o = 0;
      for(int i_o=0;i_o<a;i_o++)
      {
         if(max_o<O[i_o])
         {
            max_o = O[i_o];
            ind_max_o = i_o;
         }
      }
      Os[i] = (float)(ind_max_o-50)*10;
   }
   Print((string)Os[0]);
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int OnCalculate(const int rates_total,
                const int prev_calculated,
                const datetime &time[],
                const double &open[],
                const double &high[],
                const double &low[],
                const double &close[],
                const long &tick_volume[],
                const long &volume[],
                const int &spread[])
  {
//---
   
//--- return value of prev_calculated for next call
   return(rates_total);
  }
//+------------------------------------------------------------------+
