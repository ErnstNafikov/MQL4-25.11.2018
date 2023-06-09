//+------------------------------------------------------------------+
//|                                              УровниПоддержки.mq4 |
//|                        Copyright 2018, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2018, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
#property indicator_chart_window
#property indicator_buffers 3
#property indicator_plots   3
//--- plot max_level
#property indicator_label1  "max_level"
#property indicator_type1   DRAW_LINE
#property indicator_color1  clrRed
#property indicator_style1  STYLE_SOLID
#property indicator_width1  3
//--- plot s_level
#property indicator_label2  "s_level"
#property indicator_type2   DRAW_LINE
#property indicator_color2  clrYellow
#property indicator_style2  STYLE_SOLID
#property indicator_width2  3
//--- plot min_level
#property indicator_label3  "min_level"
#property indicator_type3   DRAW_LINE
#property indicator_color3  clrBlue
#property indicator_style3  STYLE_SOLID
#property indicator_width3  3
//--- indicator buffers
double         max_levelBuffer[];
double         s_levelBuffer[];
double         min_levelBuffer[];
int input start_bar = 20; // 0..70
int input stop_bar = 50;  //start..70
int max_k,min_k,k_bar;
double pogr_max_sum,pogr_min_sum,old_price_zigzag;

double max_price[70],min_price[70],fakt_price[70],max_price_line[70],min_price_line[70],buf_price_line[70];
int max_index[70],min_index[70];
datetime time_old;
bool NewBar(datetime time1,datetime time0)
   {
   if(time0%(60*60*4)<time1%(60*60*4))
      return true;
   else 
      return false;
   };
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
{
   //--- indicator buffers mapping
   SetIndexBuffer(0,max_levelBuffer);
   SetIndexBuffer(1,s_levelBuffer);
   SetIndexBuffer(2,min_levelBuffer);
   k_bar =70;
   max_k = 0;
   min_k = 0;
   ArrayInitialize(max_price,-1);
   ArrayInitialize(min_price,-1);
   ArrayInitialize(fakt_price,-1);
   old_price_zigzag = -1;
   //---
   return(INIT_SUCCEEDED);
   time_old = TimeCurrent();
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
   if(old_price_zigzag != iCustom(NULL,0,"ZigZag",5,5,3,0,start_bar) || NewBar(time_old,TimeCurrent()))
   {
      old_price_zigzag = iCustom(NULL,0,"ZigZag",5,5,3,0,start_bar);
      max_k = 0;
      min_k = 0;
      for(int i=start_bar;i<stop_bar;i++)
      {
         if(iCustom(NULL,0,"ZigZag",5,5,3,1,i)!=0)
         {
            max_price[max_k] = iCustom(NULL,0,"ZigZag",5,5,3,1,i);
            max_index[max_k] = i;
            max_k++;

         }
         if(iCustom(NULL,0,"ZigZag",5,5,3,2,i)!=0)
         {
            min_price[min_k] = iCustom(NULL,0,"ZigZag",5,5,3,2,i);
            min_index[min_k] = i;
            min_k++;

         } 
      }
      //Найти линию максимума
      pogr_max_sum = 100000;
      for(int i=0;i<max_k-1;i++)
      {
         for(int j=i+1;j<max_k;j++)
         {
            double del_price = (max_price[i]-max_price[j])/(max_index[i]-max_index[j]);
            for(int i_del=0;i_del<k_bar;i_del++)
            {
               buf_price_line[i_del] = max_price[i] + del_price*(i_del-max_index[i]);
            }
            double pog_sum =0;
            for(int i_del=0;i_del<max_k;i_del++)
            {
               pog_sum += MathAbs(buf_price_line[max_index[i_del]]-max_price[i_del]);
            }
            if(pogr_max_sum>pog_sum)
            {
               ArrayCopy(max_price_line,buf_price_line);
               pogr_max_sum = pog_sum;
            }                    
         }
      }   
      //Найти линию минимума
      pogr_min_sum = 100000;
      for(int i=0;i<min_k-1;i++)
      {
         for(int j=i+1;j<min_k;j++)
         {
            double del_price = (min_price[i]-min_price[j])/(min_index[i]-min_index[j]);
            for(int i_del=0;i_del<k_bar;i_del++)
            {
               buf_price_line[i_del] = min_price[i] + del_price*(i_del-min_index[i]);
            }
            double pog_sum =0;
            for(int i_del=0;i_del<min_k;i_del++)
            {
               pog_sum += MathAbs(buf_price_line[min_index[i_del]]-min_price[i_del]);
            }
            if(pogr_min_sum>pog_sum)
            {
               ArrayCopy(min_price_line,buf_price_line);
               pogr_min_sum = pog_sum;
            }                    
         }
      }  
      //Расчет центральной
      for(int i=0;i<k_bar;i++)
      {
         fakt_price[i] = (max_price_line[i]+min_price_line[i])/2;
      }
      //Нарисовать      
      ArrayInitialize(max_levelBuffer,EMPTY_VALUE);
      ArrayCopy(max_levelBuffer,max_price_line,0,0,stop_bar);
      ArrayInitialize(min_levelBuffer,EMPTY_VALUE);
      ArrayCopy(min_levelBuffer,min_price_line,0,0,stop_bar);
      ArrayInitialize(s_levelBuffer,EMPTY_VALUE);
      ArrayCopy(s_levelBuffer,fakt_price,0,0,stop_bar);
      //Проверка
      //Заполнить fakt_price
   }
   time_old = TimeCurrent();
   //--- return value of prev_calculated for next call
   return(rates_total);
}
//+------------------------------------------------------------------+
