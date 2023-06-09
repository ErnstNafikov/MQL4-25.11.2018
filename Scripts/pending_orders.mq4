//+------------------------------------------------------------------+
//|                                              ВыгрузкаОрдеров.mq4 |
//|                        Copyright 2018, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2018, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
#property script_show_inputs 
input datetime Date_start = __DATE__;
input string InpDirectoryName = "Data";
input string InpFileName = "OpenClose.csv";
//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
void OnStart()
  {
//---
     int file_handle=FileOpen(InpDirectoryName+"//"+InpFileName,FILE_READ|FILE_WRITE|FILE_CSV); 
     if(file_handle!=INVALID_HANDLE) 
       {
        int i,accTotal=OrdersHistoryTotal(); 
        for(i=0;i<accTotal;i++) 
          {  
           if(OrderSelect(i,SELECT_BY_POS,MODE_HISTORY)) 
             { 
              if(Date_start < OrderCloseTime())
                {
                 int Prohod = 0;
                 if(OrderProfit()<0)
                    Prohod = 0 - int(MathRound(MathAbs(OrderOpenPrice()-OrderClosePrice())*MathPow(10,MarketInfo(OrderSymbol(),MODE_DIGITS))));
                 else
                    Prohod = int(MathRound(MathAbs(OrderOpenPrice()-OrderClosePrice())*MathPow(10,MarketInfo(OrderSymbol(),MODE_DIGITS))));
                 int Stop = 0 - int(MathRound(MathAbs(OrderOpenPrice()-OrderStopLoss())*MathPow(10,MarketInfo(OrderSymbol(),MODE_DIGITS))));
                 string strProfit = string(OrderProfit());
                 for(int j=0;j<StringLen(strProfit);j++)
                    if(StringGetChar(strProfit,j) == '.')
                       strProfit=StringSetChar(strProfit,j,','); 
                 string strLots = string(OrderLots());
                 for(int j=0;j<StringLen(strLots);j++)
                    if(StringGetChar(strLots,j) == '.')
                       strLots=StringSetChar(strLots,j,',');
                 FileWrite(file_handle,OrderSymbol(),strLots,Prohod,strProfit,OrderCloseTime(),Stop); 
                }
             }  
          }
       }
     //--- закрываем файл 
     FileClose(file_handle); 
     PrintFormat("Данные записаны, файл %s закрыт",InpFileName); 
    


  }
//+------------------------------------------------------------------+
