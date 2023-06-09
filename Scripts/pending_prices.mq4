//+------------------------------------------------------------------+
//|                                                  ВыгрузкаЦен.mq4 |
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
input string InpFileName = "OpenPrice.csv";
input int final_i = 10;
//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
void OnStart()
  {
//---
   int file_handle=FileOpen(InpDirectoryName+"//"+InpFileName,FILE_READ|FILE_WRITE|FILE_CSV); 
   if(file_handle!=INVALID_HANDLE) 
     {
      FileWrite(file_handle,"_DXY","USDCHF","USDCAD","NZDUSD","NZDCAD","CADCHF");
      for(int i=0;i<final_i;i++)
        {
         string Price0 = string(iOpen("_DXY",0,i));
         for(int j=0;j<StringLen(Price0);j++)
            if(StringGetChar(Price0,j) == '.')
               Price0=StringSetChar(Price0,j,',');
         string Price1 = string(iOpen("USDCHF",0,i));
         for(int j=0;j<StringLen(Price1);j++)
            if(StringGetChar(Price1,j) == '.')
               Price1=StringSetChar(Price1,j,',');
         string Price2 = string(iOpen("USDCAD",0,i));
         for(int j=0;j<StringLen(Price2);j++)
            if(StringGetChar(Price2,j) == '.')
               Price2=StringSetChar(Price2,j,',');
         string Price3 = string(iOpen("NZDUSD",0,i));
         for(int j=0;j<StringLen(Price3);j++)
            if(StringGetChar(Price3,j) == '.')
               Price3=StringSetChar(Price3,j,',');
         string Price4 = string(iOpen("NZDCAD",0,i));
         for(int j=0;j<StringLen(Price4);j++)
            if(StringGetChar(Price4,j) == '.')
               Price4=StringSetChar(Price4,j,',');
         string Price5 = string(iOpen("CADCHF",0,i));
         for(int j=0;j<StringLen(Price5);j++)
            if(StringGetChar(Price5,j) == '.')
               Price5=StringSetChar(Price5,j,',');
         FileWrite(file_handle,Price0,Price1,Price2,Price3,Price4,Price5);
        }
      //--- закрываем файл 
      FileClose(file_handle); 
      PrintFormat("Данные записаны, файл %s закрыт",InpFileName); 
     }
  }
//+------------------------------------------------------------------+
