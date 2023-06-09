//+------------------------------------------------------------------+
//|                                                     Пробитие.mq4 |
//|                        Copyright 2018, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2018, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
int input start_0 = 0;
int input stop_0 = 30;
int input start_1 = 20;
int input stop_1 = 70;
int input s_izm = 20;
double SL,TP;
int ticket;
bool sell_open,buy_open;
datetime time_old;
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
   sell_open = false;
   buy_open = false;
   SL = s_izm*Point();
   TP = 4*s_izm*Point();
   time_old = TimeCurrent();
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
   if(NewBar(time_old,TimeCurrent()))
   {
      if(ticket!=-1 && OrderSelect(ticket,SELECT_BY_TICKET))
         if(OrderCloseTime()!=0)
         {
            if(OrderType() == OP_BUY)
               sell_open = false;
            if(OrderType() == OP_SELL)   
               buy_open = false;
         }
   }
   time_old = TimeCurrent();
   double line_blue10 = iCustom(NULL,0,"ДядяВиталик\\УровниПоддержки",start_1,stop_1,2,0);
   double line_blue11 = iCustom(NULL,0,"ДядяВиталик\\УровниПоддержки",start_1,stop_1,2,1);
   double line_blue00 = iCustom(NULL,0,"ДядяВиталик\\УровниПоддержки",start_0,stop_0,2,0);
   double line_blue01 = iCustom(NULL,0,"ДядяВиталик\\УровниПоддержки",start_0,stop_0,2,1);
   
   double line_red10 = iCustom(NULL,0,"ДядяВиталик\\УровниПоддержки",start_1,stop_1,0,0);
   double line_red11 = iCustom(NULL,0,"ДядяВиталик\\УровниПоддержки",start_1,stop_1,0,1);
   double line_red00 = iCustom(NULL,0,"ДядяВиталик\\УровниПоддержки",start_0,stop_0,0,0);
   double line_red01 = iCustom(NULL,0,"ДядяВиталик\\УровниПоддержки",start_0,stop_0,0,1);
   if(line_blue10>line_blue11 && line_blue01>line_blue00 && !sell_open)
   {
      ticket = OrderSend(_Symbol,OP_SELL,10,Bid,3,Ask+SL,Ask-TP,"down");
      sell_open = true;buy_open = true; 
   }
   if(line_red11>line_red10 && line_red00>line_red01 && !buy_open)
   {
      ticket = OrderSend(_Symbol,OP_BUY,10,Ask,3,Bid-SL,Bid+TP,"up");
      buy_open = true;sell_open = true;
   }
}
//+------------------------------------------------------------------+
