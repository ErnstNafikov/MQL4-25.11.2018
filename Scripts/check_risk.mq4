//+------------------------------------------------------------------+
//|                                        ПроверкаСтоповОбъемов.mq4 |
//|                        Copyright 2018, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2018, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
#property script_show_inputs 
input double pr_risk = 0.5;
//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
void OnStart()
  {
//---
   Print("Максимальный объем "+(string)_Point);
   double hod_max = double(MathRound(AccountBalance()*pr_risk)/100);
   Print("Максимальное движение "+(string)hod_max);
   double vol = double(MathRound(AccountBalance()*pr_risk/0.675/800/100)/100);
   Print("Максимальный объем "+(string)vol);
  }
//+------------------------------------------------------------------+
