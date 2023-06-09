//+------------------------------------------------------------------+
//|                                                       robot7.mq4 |
//|                        Copyright 2018, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2018, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
input int S_fast = 10;//Быстрая
int period1,period2;
bool p12up,p12low;
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//---
   Print(MarketInfo("USDCHF",MODE_BID));
   Print(MarketInfo("USDCAD",MODE_BID));
   Print(MarketInfo("NZDUSD",MODE_BID));
   
   Print(MarketInfo("NZDCAD",MODE_BID));
   Print(MarketInfo("CADCHF",MODE_BID));
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
   //double price12 = MarketInfo("CADCHF",MODE_BID);
   //double price1 = MarketInfo("USDCHF",MODE_BID);
   //double price2 = MarketInfo("USDCAD",MODE_BID);
   period1 = 1;
   while(iMA("USDCHF",_Period,S_fast,0,MODE_EMA,PRICE_WEIGHTED,0)>=iMA("USDCHF",_Period,S_fast+period1,0,MODE_EMA,PRICE_WEIGHTED,0)) 
     { 
      period1+=1;
        
     }
   period2 = 1;
   while(iMA("USDCAD",_Period,S_fast,0,MODE_EMA,PRICE_WEIGHTED,0)>=iMA("USDCAD",_Period,S_fast+period2,0,MODE_EMA,PRICE_WEIGHTED,0)) 
     { 
      period2+=1;
        
     }
   Print((string)period1+"/"+(string)period2);
  }
//+------------------------------------------------------------------+
