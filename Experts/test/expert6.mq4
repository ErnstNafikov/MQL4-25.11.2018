//+------------------------------------------------------------------+
//|                                                       robot6.mq4 |
//|                        Copyright 2018, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2018, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
input double vol_max = 0.12;//Максимальный объем
input int del = -5; //Отклонение
input int check_in = 0; //0F/1LOW/2UP/3SELL/4BUY
input double Pr = 0.5; //Процент рабочий
input int Trade_in = 0; //0F/1BUY/2SELL
bool  LOW_check,UP_check,SELL_signal_check,BUY_signal_check,BUY_open_check, SELL_open_check,flag_risk; 
int ticket;
datetime time_old;
bool NewBar(datetime time1,datetime time0)
   {
   if(time0%(60*5)<time1%(60*5))
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
   LOW_check = false;UP_check = false;SELL_signal_check = false;BUY_signal_check = false;
   if(check_in==1)LOW_check = true;
   else if(check_in==2)UP_check = true;
   else if(check_in==3)SELL_signal_check = true;
   else if(check_in==4)BUY_signal_check = true;
   int file_handle=FileOpen("Data//flag",FILE_READ|FILE_CSV); 
      if(file_handle!=INVALID_HANDLE) 
        {
         flag_risk = bool(FileReadBool(file_handle)); 
         FileClose(file_handle); 
        } 
   SELL_open_check=false;BUY_open_check=false;
   ticket=-1; 
   if(flag_risk)
      Print("Торговля разрешена");
   else
      Print("Торговля запрещена");
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
   double MU = iBands(NULL,0,20,2,0,PRICE_CLOSE,MODE_UPPER,0)-del*_Point;
   double McU = iBands(NULL,0,20,2,0,PRICE_CLOSE,MODE_MAIN,0)+del*_Point;
   double ML = iBands(NULL,0,20,2,0,PRICE_CLOSE,MODE_LOWER,0)+del*_Point;
   double McL = iBands(NULL,0,20,2,0,PRICE_CLOSE,MODE_MAIN,0)-del*_Point;
   if(NewBar(time_old,TimeCurrent()))
     {
      int file_handle=FileOpen("Data//flag",FILE_READ|FILE_CSV); 
         if(file_handle!=INVALID_HANDLE) 
           {
            flag_risk = bool(FileReadBool(file_handle)); 
            FileClose(file_handle); 
           } 
      if(flag_risk)
         Print("Торговля разрешена");
      else
         Print("Торговля запрещена");
     }
   if(!LOW_check && ML>Bid) {LOW_check = true;UP_check = false;SELL_signal_check = false;BUY_signal_check = false;}
   if(!UP_check && MU<Bid) {UP_check = true;LOW_check = false;SELL_signal_check = false;BUY_signal_check = false;}
   if(!SELL_signal_check && LOW_check && McL<Bid) {SELL_signal_check = true;BUY_signal_check = false;LOW_check = false;UP_check = false;}
   if(!BUY_signal_check && UP_check && McU>Bid) {BUY_signal_check = true;SELL_signal_check = false;LOW_check = false;UP_check = false;}
   
   if(Trade_in!=2 && BUY_signal_check && !BUY_open_check && flag_risk)
     {
      double SL = Bid - ML;
      double TP = MU - Bid;
      double vol = double(MathRound(AccountBalance()*Pr/0.675/SL*_Point/100)/100);
      if(vol>vol_max){Print(vol);vol = vol_max;}
      ticket = OrderSend(_Symbol,OP_BUY,vol,Ask,3,Bid-SL,Bid+TP,"up");
      BUY_open_check=true;SELL_open_check=false;
     }
   if(Trade_in!=1 && SELL_signal_check && !SELL_open_check && flag_risk)
     {
      double SL = MU - Ask;
      double TP = Ask - ML;
      double vol = double(MathRound(AccountBalance()*Pr/0.675/SL*_Point/100)/100);
      if(vol>vol_max){Print(vol);vol = vol_max;}
      ticket = OrderSend(_Symbol,OP_SELL,vol,Bid,3,Ask+SL,Ask-TP,"down");
      SELL_open_check=true;BUY_open_check=false;
     }
   
   if(ticket!=-1 && OrderSelect(ticket,SELECT_BY_TICKET))
      if(OrderCloseTime()==0)
        {
         if(LOW_check || UP_check)
           {
            if(BUY_open_check)
               if(OrderClose(OrderTicket(),OrderLots(),Bid,3))
                  BUY_open_check = false;
            if(SELL_open_check)
               if(OrderClose(OrderTicket(),OrderLots(),Ask,3))
                  SELL_open_check = false;
           }
        }
      else
        {
         LOW_check = false;UP_check = false;SELL_signal_check = false;BUY_signal_check = false;
         BUY_open_check=false;SELL_open_check=false;
         ticket=-1;
        }
    time_old = TimeCurrent();
    //if(LOW_check)Print("1");
    //else if(UP_check)Print("2");
    //else if(SELL_signal_check)Print("3");
    //else if(BUY_signal_check)Print("4");
  }
//+------------------------------------------------------------------+
