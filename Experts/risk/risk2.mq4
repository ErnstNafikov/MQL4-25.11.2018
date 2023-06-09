//+------------------------------------------------------------------+
//|                                                        risk2.mq4 |
//|                        Copyright 2018, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2018, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
input int Period_in = 5;
datetime time_old;
bool flag_risk, check;
bool NewBar(datetime time1,datetime time0)
   {
   if(time0%(60*Period_in)<time1%(60*Period_in))
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
   time_old = TimeCurrent();
   int file_handle=FileOpen("Data//flag",FILE_READ|FILE_CSV); 
      if(file_handle!=INVALID_HANDLE) 
        {
         flag_risk = bool(FileReadBool(file_handle)); 
         FileClose(file_handle); 
        } 
   if(!flag_risk)
        {
         Print("Торговля на сегодня запрещена все позиции будут закрыты");
         int accTotal=OrdersTotal();
         for(int i=0;i<accTotal;i++) 
           {  
              if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)) 
                {
                 if(OrderType() == OP_BUY)
                  if(!OrderClose(OrderTicket(),OrderLots(),Bid,3))
                     check = false;
                 if(OrderType() == OP_SELL)
                  if(!OrderClose(OrderTicket(),OrderLots(),Ask,3))
                     check = false;
                }
           }
        }
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
      int file_handle=FileOpen("Data//flag",FILE_READ|FILE_CSV); 
         if(file_handle!=INVALID_HANDLE) 
           {
            flag_risk = bool(FileReadBool(file_handle)); 
            FileClose(file_handle); 
           } 
      if(!flag_risk)
        {
         Print("Торговля на сегодня запрещена все позиции будут закрыты");
         int accTotal=OrdersTotal();
         for(int i=0;i<accTotal;i++) 
           {  
              if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)) 
                {
                 if(OrderType() == OP_BUY)
                  if(!OrderClose(OrderTicket(),OrderLots(),Bid,3))
                     check = false;
                 if(OrderType() == OP_SELL)
                  if(!OrderClose(OrderTicket(),OrderLots(),Ask,3))
                     check = false;
                }
           }
        }
     }
  }
//+------------------------------------------------------------------+
