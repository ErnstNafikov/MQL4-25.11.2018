//+------------------------------------------------------------------+
//|                                                   ПроверкаBB.mq4 |
//|                        Copyright 2018, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2018, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
#property script_show_inputs 
input int Bar_in = 100;
input int BB_s = 20;
input int BB_o = 2;
input int del = 0;
int all_inter,all_not_inter,pr;
//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
void OnStart()
  {
//---
   all_inter = 0;
   all_not_inter = 0;
   pr = 0;
   for(int i=0;i<Bar_in;i++)
     {
      double MU = iBands(NULL,0,BB_s,BB_o,0,PRICE_CLOSE,MODE_UPPER,i)+del*_Point;
      double ML = iBands(NULL,0,BB_s,BB_o,0,PRICE_CLOSE,MODE_LOWER,i)-del*_Point;
      int not_inter = 0;
      int all = int(MathRound((iHigh(_Symbol,_Period,i)-iLow(_Symbol,_Period,i))*MathPow(10,MarketInfo(_Symbol,MODE_DIGITS))));
      if(iHigh(_Symbol,_Period,i)>MU)
         not_inter = int(MathRound((iHigh(_Symbol,_Period,i)-MU)*MathPow(10,MarketInfo(_Symbol,MODE_DIGITS))));
      if(iLow(_Symbol,_Period,i)<ML)
         not_inter = int(MathRound((ML-iLow(_Symbol,_Period,i))*MathPow(10,MarketInfo(_Symbol,MODE_DIGITS))));
      if(not_inter>0)
        {
         all_inter = all_inter + all - not_inter;
         all_not_inter = all_not_inter + not_inter;
        } 
      else
         all_inter = all_inter + all;
     }
   pr = int(all_not_inter*100/(all_inter+all_not_inter));
   Print("Процент цен за диапазоном составляет " + string(pr)+"%");
  } 
//+------------------------------------------------------------------+
