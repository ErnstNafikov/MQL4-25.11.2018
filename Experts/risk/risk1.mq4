//+------------------------------------------------------------------+
//|                                                        risk1.mq4 |
//|                        Copyright 2018, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2018, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
input double pr_risk = 0.5;
input int Period_in = 1440;
bool check,work;
datetime time_old,start_date_sum;
double sum_pr;
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
   work = true;
   start_date_sum = TimeCurrent()-TimeCurrent()%(60*Period_in);
   time_old = TimeCurrent();
   int file_handle=FileOpen("Data//flag",FILE_WRITE|FILE_CSV); 
      if(file_handle!=INVALID_HANDLE) 
        {
         FileWrite(file_handle,"true");
         FileClose(file_handle); 
          
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
      start_date_sum = TimeCurrent();
      work = true;
      int file_handle=FileOpen("Data//flag",FILE_WRITE|FILE_CSV); 
      if(file_handle!=INVALID_HANDLE) 
        {
         FileWrite(file_handle,"true");
         FileClose(file_handle); 
          
        } 
     }
   
   //Модуль закрытия сделок при максимальном прохождении
   sum_pr=0;
   int i,accTotal=OrdersHistoryTotal();
      for(i=0;i<accTotal;i++) 
        {
         if(OrderSelect(i,SELECT_BY_POS,MODE_HISTORY))
            if(OrderCloseTime()>start_date_sum)
               if(MathAbs(OrderProfit())<500)   
                  sum_pr += OrderProfit();
        }
   double hod_max = double(MathRound(AccountBalance()*pr_risk)/100);
   if(hod_max<MathAbs(AccountProfit()+sum_pr) && (OrdersTotal()>0 || work))
     {
      //создание внешнего флага
      work = false;
      int file_handle=FileOpen("Data//flag",FILE_WRITE|FILE_CSV); 
      if(file_handle!=INVALID_HANDLE) 
        {
         FileWrite(file_handle,"false");
         FileClose(file_handle); 
          
        } 
      Print("Торговля на сегодня запрещена все позиции будут закрыты");
      accTotal=OrdersTotal();
      for(i=0;i<accTotal;i++) 
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
   time_old = TimeCurrent();
  }
//+------------------------------------------------------------------+
