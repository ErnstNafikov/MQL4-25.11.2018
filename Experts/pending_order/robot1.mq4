//+------------------------------------------------------------------+
//|                                                       robot1.mq4 |
//|                        Copyright 2018, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2018, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
input double del_price = 0.010;
input double del_stop = 0.0005;
double price1,price2;
int ticket_buy,ticket_sell,ticket_akt,k,k_int;
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
{
//---
   int int_price = (int)(Bid/Point());
   int int_del_price = (int)(del_price/Point());
   double s_price = int_price%int_del_price;
   if(s_price>10)
   {
      price1 = (int_price - s_price)*Point();
      price2 = (int_price - s_price)*Point() + del_price;
   }
   else
   {
      price1 = (int_price - s_price)*Point() - del_price;
      price2 = (int_price - s_price)*Point() + del_price;
   }
   ticket_buy=OrderSend(Symbol(),OP_BUYSTOP,0.01,price2,3,price2 - del_price + del_stop,price2 + del_price - del_stop);
   ticket_sell=OrderSend(Symbol(),OP_SELLSTOP,0.01,price1,3,price1 + del_price - del_stop,price1 - del_price + del_stop);
   ticket_akt = -1;
   k = 1;k_int=1;
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
   if(ticket_akt == -1)
   {
      if(OrderSelect(ticket_buy, SELECT_BY_TICKET)) 
      { 
         if(OrderType() == 0)
         {
            ticket_akt = ticket_buy;
            price2 = price2 + del_price;
            ticket_buy=OrderSend(Symbol(),OP_BUYSTOP,0.01,price2,3,price2 - del_price + del_stop,price2 + del_price - del_stop);     
         }
      }
      if(OrderSelect(ticket_sell, SELECT_BY_TICKET)) 
      { 
         if(OrderType() == 1)
         {
            ticket_akt = ticket_sell;
            price1 = price1 - del_price;
            ticket_sell=OrderSend(Symbol(),OP_SELLSTOP,0.01,price1,3,price1 + del_price - del_stop,price1 - del_price + del_stop);
         }
      } 
   }
   else
   {
      if(OrderSelect(ticket_akt, SELECT_BY_TICKET)) 
      { 
         int order_type = OrderType();
         if(OrderCloseTime() != 0)
         {      
            if(OrderSelect(ticket_buy, SELECT_BY_TICKET)) 
            { 
               if(OrderType() == 0)
               {
                  if(order_type == 1)
                  {
                     if(k_int != 1)
                        k *= 2;
                     int dop_ticket = OrderSend(Symbol(),OP_BUY,0.01*k,Ask,3,price2 - del_price + del_stop,price2 + del_price - del_stop);
                  }
                  else
                  {
                     k = 1;
                     k_int = 1;
                  }
                  ticket_akt = ticket_buy;
                  price2 = price2 + del_price;
                  ticket_buy=OrderSend(Symbol(),OP_BUYSTOP,0.01,price2,3,price2 - del_price + del_stop,price2 + del_price - del_stop);  
                  bool deleted = OrderDelete(ticket_sell);
                  price1 = price1 + del_price;
                  ticket_sell=OrderSend(Symbol(),OP_SELLSTOP,0.01,price1,3,price1 + del_price - del_stop,price1 - del_price + del_stop);   
               }
            }     
         
            if(OrderSelect(ticket_sell, SELECT_BY_TICKET)) 
            { 
               if(OrderType() == 1)
               {
                  if(order_type == 0)
                  {
                     if(k_int != 1)
                        k *= 2;
                     k_int++;
                     int dop_ticket = OrderSend(Symbol(),OP_SELL,0.01*k,Bid,3,price1 + del_price - del_stop,price1 - del_price + del_stop);
                  }
                  else
                  {
                     k = 1;
                     k_int = 1;
                  }
                  ticket_akt = ticket_sell;
                  price1 = price1 - del_price;
                  ticket_sell=OrderSend(Symbol(),OP_SELLSTOP,0.01,price1,3,price1 + del_price - del_stop,price1 - del_price + del_stop);
                  bool deleted = OrderDelete(ticket_buy);
                  price2 = price2 - del_price;
                  ticket_buy=OrderSend(Symbol(),OP_BUYSTOP,0.01,price2,3,price2 - del_price + del_stop,price2 + del_price - del_stop);
               }
            }     
         }
      }
   }
}
//+------------------------------------------------------------------+
