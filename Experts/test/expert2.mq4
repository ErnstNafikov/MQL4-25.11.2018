//+------------------------------------------------------------------+
//|                                                       robot2.mq4 |
//|                        Copyright 2017, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2017, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
int Bull,Bear;
bool trand;
input double VolumeTrade = 0.5;
input double parametr=0.5;
input int b=12,m=24,s=9;
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//---
   Bull=0;
   Bear=0;
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
   if(iMACD(NULL,0,b,m,s,PRICE_CLOSE,MODE_MAIN,0)>iMACD(NULL,0,b,m,s,PRICE_CLOSE,MODE_SIGNAL,0)) trand = True;
   if(iMACD(NULL,0,b,m,s,PRICE_CLOSE,MODE_MAIN,0)<iMACD(NULL,0,b,m,s,PRICE_CLOSE,MODE_SIGNAL,0)) trand = False;
   //double val1=iCustom(NULL,30,"BBI",0,0);
   double val2=iCustom(NULL,15,"Kanat",0,0);
   Print(val2);
   if(trand)
     {
      if(( val2 > parametr)&&VolumeTrade>Bull*0.15)
        {
         int Order=OrderSend(_Symbol,0,0.15,Ask,100,NULL,NULL);
         Bull++;
        }
      if(Bear!=0)
         for(int i=0;i<Bear;i++)
           {
            bool check = false;
            if(OrderSelect(i,SELECT_BY_POS))
               check = OrderClose(OrderTicket(),OrderLots(),Ask,100);
            if(check == false){int buf = Bear; Bear = Bear - i; i = buf; Print("Ордер",i," закрыт не успешно");}
            else if(i == Bear-1)Bear=0;
           }
     }
   else
     {
      if(( val2 < -parametr)&&VolumeTrade>Bear*0.15)
        {
         int Order=OrderSend(_Symbol,1,0.15,Bid,100,NULL,NULL);
         Bear++;
        }
      if(Bull!=0)
         for(int i=0;i<Bull;i++)
           {
            bool check = false;
            if(OrderSelect(i,SELECT_BY_POS))
               check = OrderClose(OrderTicket(),OrderLots(),Bid,100);
            if(check == false){int buf = Bull; Bull = Bull - i; i = buf; Print("Ордер",i," закрыт не успешно");}
            else if(i == Bull-1)Bull=0;
           }
      
     }
   
  }
//+------------------------------------------------------------------+
