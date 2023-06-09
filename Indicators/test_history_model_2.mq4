//+------------------------------------------------------------------+
//|                                                          NS2.mq4 |
//|                        Copyright 2018, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2018, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
#property indicator_chart_window
#property indicator_buffers 10
#property indicator_plots   10
//--- plot O0
#property indicator_label1  "O0"
#property indicator_type1   DRAW_LINE
#property indicator_color1  clrBlue
#property indicator_style1  STYLE_SOLID
#property indicator_width1  3
//--- plot O1
#property indicator_label2  "O1"
#property indicator_type2   DRAW_LINE
#property indicator_color2  clrViolet
#property indicator_style2  STYLE_SOLID
#property indicator_width2  2
//--- plot O2
#property indicator_label3  "O2"
#property indicator_type3   DRAW_LINE
#property indicator_color3  clrYellow
#property indicator_style3  STYLE_SOLID
#property indicator_width3  3
//--- plot O3
#property indicator_label4  "O3"
#property indicator_type4   DRAW_LINE
#property indicator_color4  clrHotPink
#property indicator_style4  STYLE_SOLID
#property indicator_width4  2
//--- plot O4
#property indicator_label5  "O4"
#property indicator_type5   DRAW_LINE
#property indicator_color5  clrRed
#property indicator_style5  STYLE_SOLID
#property indicator_width5  3
//--- plot O5
#property indicator_label6  "O5"
#property indicator_type6   DRAW_LINE
#property indicator_color6  C'143,188,139'
#property indicator_style6  STYLE_SOLID
#property indicator_width6  1
//--- plot O6
#property indicator_label7  "O6"
#property indicator_type7   DRAW_LINE
#property indicator_color7  clrKhaki
#property indicator_style7  STYLE_SOLID
#property indicator_width7  1
//--- plot O7
#property indicator_label8  "O7"
#property indicator_type8   DRAW_LINE
#property indicator_color8  clrDarkOrange
#property indicator_style8  STYLE_SOLID
#property indicator_width8  1
//--- plot O8
#property indicator_label9  "O8"
#property indicator_type9   DRAW_LINE
#property indicator_color9  clrYellow
#property indicator_style9  STYLE_SOLID
#property indicator_width9  1
//--- plot O9
#property indicator_label10  "O9"
#property indicator_type10   DRAW_LINE
#property indicator_color10  clrTomato
#property indicator_style10  STYLE_SOLID
#property indicator_width10  1
//--- indicator buffers
double         O0Buffer[];
double         O1Buffer[];
double         O2Buffer[];
double         O3Buffer[];
double         O4Buffer[];
double         O5Buffer[];
double         O6Buffer[];
double         O7Buffer[];
double         O8Buffer[];
double         O9Buffer[];



input string InpDirectoryName = "Data";

int a = 100;
int a2; 
int f_s = 49;

float Wh[10000],Wo[10000],Bh[100],Bo[100],I[150],H[100],O[100],Os[100];
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- indicator buffers mapping
   SetIndexBuffer(0,O0Buffer);
   SetIndexBuffer(1,O1Buffer);
   SetIndexBuffer(2,O2Buffer);
   SetIndexBuffer(3,O3Buffer);
   SetIndexBuffer(4,O4Buffer);
   SetIndexBuffer(5,O5Buffer);
   SetIndexBuffer(6,O6Buffer);
   SetIndexBuffer(7,O7Buffer);
   SetIndexBuffer(8,O8Buffer);
   SetIndexBuffer(9,O9Buffer);
   SetIndexShift(0,5-f_s+1);
   SetIndexShift(1,5-f_s+1);
   SetIndexShift(2,5-f_s+1);
   SetIndexShift(3,5-f_s+1);
   SetIndexShift(4,5-f_s+1);
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
   
   ArrayInitialize(Os,0);
   
   
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
   //Tick
   int k_end = 20;
   for(int i=f_s;i<a+k_end+f_s;i++)
   {
      I[i-f_s] = (float)(0.01*MathRound((Close[i]-Open[i])/Point()));
   }
   for(int i=0;i<k_end;i++)
   {
      for(int j=0;j<10-i;j++)
      {
         //Расчет H
         for(int i_s=0;i_s<a;i_s++)
         {
            float Sum = 0;
            for(int j_s=0;j_s<a;j_s++)
            {
               int ind_s = i_s + j_s*a;
               if(j_s>=j)
                  Sum += I[j_s+i-j]*Wh[ind_s];
               else
                  Sum += Os[10-i-j]*Wh[ind_s];
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
         Os[10-i-1-j] += (float)(ind_max_o-50)*10;
      }
      double old_bid;/*
      if(i==0)
      {
      old_bid = (float)Open[5-i+f_s-1];
      O0Buffer[10-i] = old_bid;
      for(int j=10-i-1;j>=0;j--)
      {
         old_bid =(double) (old_bid + Os[j]*Point());
         O0Buffer[j] = old_bid;      
      }}
      if(i==2)
      {
      old_bid = (float)Open[5-i+f_s-1];
      O2Buffer[10-i] = old_bid;
      for(int j=10-i-1;j>=0;j--)
      {
         old_bid =(double) (old_bid + Os[j]*Point());
         O2Buffer[j] = old_bid;      
      }}*/
      if(i==4)
      {
      old_bid = (float)Open[5-i+f_s-1];
      O4Buffer[10-i] = old_bid;
      for(int j=10-i-1;j>=0;j--)
      {
         old_bid =(double) (old_bid + Os[j]*Point()/k_end);
         O4Buffer[j] = old_bid;      
      }}
   }
      
//--- return value of prev_calculated for next call
   return(rates_total);
}
//+------------------------------------------------------------------+
