//+------------------------------------------------------------------+
//|                                                        robot.mq4 |
//|                        Copyright 2017, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2017, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
double histogram[2],average[2];

//---Линии экстремума
input int Take_Profit=40;
input int Stop_Los=40;
input double Volume_Order=0.05;
input bool Close_Plus=false; //закрытие только в плюсе
input double deviation=0.00001; //возможное отклонение
input int count_dev=5; //количество баров в отклонении 
int OrderBull,OrderBear; 
bool Bull_Signal,Bear_Signal;
//---Рабочий таймфрейм
input int work_period=5; //в минутах
int buf[1];
bool New_Bar()
  {
   int ost=1;
   bool otv=false;
   if(work_period<60)
     {
      ost=Minute()%work_period;
      if(ost==0)
        {
         if(Minute()!=buf[0]){buf[0]=Minute();otv=true;}
         else otv=false;
        }
     }
   else if(work_period<1440)
     {
      ost=(Hour()*60+Minute())%work_period;
      if(ost==0)
        {
         int time=Hour()*60+Minute();
         if(time!=buf[0]){buf[0]=time;otv=true;}
         else otv=false;
        }
     }
   return otv;
  };
//---
input string work_time_string="[10;11;12;13;14;15]";///; разделитель//- продолжение//от 0 до 23
bool work_time_bool[24];
//---Модуль рабочего временни
void Data_Processing_wt()
  {
   for(int i=0;i<StringLen(work_time_string);i++)
     {
      int znak=StringGetChar(work_time_string,i);
      int time;
      if(znak==91 || znak==59)
        {
         znak=StringGetChar(work_time_string,i+2);
         if(znak==45 || znak==59 || znak==93)
           {
            //однозначное число1
            time=(int)StringToInteger(StringSubstr(work_time_string,i+1,1));
            
            if(znak==93 || znak==59)
              {
               //разделитель
               work_time_bool[time]=true;
               i+=1;
              }else{
               //продолжитель
               znak=StringGetChar(work_time_string,i+4);
               int time2;
               if(znak==59 || znak==93)
                {
                 //однозначное число2
                 time2=(int)StringToInteger(StringSubstr(work_time_string,i+3,1));
                 for(int t=time;t<=time2;t++)
                    work_time_bool[t]=true;
                 i+=3;
                }else{
                 //двузначное число2
                 time2=(int)StringToInteger(StringSubstr(work_time_string,i+3,2));
                 for(int t=time;t<=time2;t++)
                    work_time_bool[t]=true;
                 i+=4;
                }
              } 
           }else{ 
            //двузначное число1
            time=(int)StringToInteger(StringSubstr(work_time_string,i+1,2));
            znak=StringGetChar(work_time_string,i+3);
            if(znak==93 || znak==59)
              {
               //разделитель
               work_time_bool[time]=true;
               i+=2;
              }else{
               //продолжитель //двузначное число2
               
               int time2;
               time2=(int)StringToInteger(StringSubstr(work_time_string,i+4,2));
               for(int t=time;t<=time2;t++)
                  work_time_bool[t]=true;
               i+=5; 
              }
           }
        }
      //выход
     }
  };
//---

void Bull_Open()
  {
   OrderBull=OrderSend(_Symbol,0,Volume_Order,Ask,100,NormalizeDouble(Ask-Take_Profit*Point,Digits),NormalizeDouble(Ask+Stop_Los*Point,Digits));  
  };
void Bear_Open()
  {
   OrderBear=OrderSend(_Symbol,1,Volume_Order,Bid,100,NormalizeDouble(Bid+Take_Profit*Point,Digits),NormalizeDouble(Bid-Stop_Los*Point,Digits)); 
  };
void Order_Close()
  {
   if(OrderBull!=-1)
   if(OrderSelect(OrderBull,SELECT_BY_TICKET))
     {
      if(Close_Plus)
        {
         if(OrderOpenPrice()<Bid)
           {
            bool Order_Close=OrderClose(OrderBull,OrderLots(),Bid,100);
           }else{
            bool Order_Modify=OrderModify(OrderBear,OrderOpenPrice(),NULL,OrderOpenPrice(),0);
           }
        }else{
         bool Order_Close=OrderClose(OrderBull,OrderLots(),Bid,100);
        }
      OrderBull=-1;
      
     }
   if(OrderBear!=-1)
   if(OrderSelect(OrderBear,SELECT_BY_TICKET))
     {
      if(Close_Plus)
        {
         if(OrderOpenPrice()>Ask)
           {
            bool Order_Close=OrderClose(OrderBear,OrderLots(),Ask,100);
           }else{
            bool Order_Modify=OrderModify(OrderBear,OrderOpenPrice(),NULL,OrderOpenPrice(),0);
           }
        }else{
         bool Order_Close=OrderClose(OrderBear,OrderLots(),Ask,100);
        }
      OrderBear=-1;
     }
  };



//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//---
   Data_Processing_wt();
   OrderBear=-1;Bear_Signal=true;
   OrderBull=-1;Bull_Signal=true;
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
   if(New_Bar())
   if(work_time_bool[Hour()])
     {
      //---
      histogram[1]=iMACD(NULL,0,12,26,9,PRICE_TYPICAL,MODE_MAIN,2);
      average[1]=iMACD(NULL,0,12,26,9,PRICE_TYPICAL,MODE_SIGNAL,2);
      int i=2;
      while(average[1]==histogram[1])
        {
         i+=1;
         histogram[1]=iMACD(NULL,0,12,26,9,PRICE_TYPICAL,MODE_MAIN,i);
         average[1]=iMACD(NULL,0,12,26,9,PRICE_TYPICAL,MODE_SIGNAL,i);
        }
      histogram[0]=iMACD(NULL,0,12,26,9,PRICE_TYPICAL,MODE_MAIN,1);     // гистограма серая
      average[0]=iMACD(NULL,0,12,26,9,PRICE_TYPICAL,MODE_SIGNAL,1);     // средняя красная 
      //---
      //
      if(average[1]!=histogram[1])
        {
         if(average[1]>histogram[1] && average[0]<histogram[0] && Bull_Signal) 
           {
            Bear_Signal=true;
            Bull_Signal=false;
            Order_Close();
            if(histogram[0]>0)
              {
               i=1;
               double razn=0;
               int count=0;
               do 
                 {
                  i++;
                  histogram[1]=iMACD(NULL,0,12,26,9,PRICE_TYPICAL,MODE_MAIN,i);
                  average[1]=iMACD(NULL,0,12,26,9,PRICE_TYPICAL,MODE_SIGNAL,i);
                  razn=MathAbs(histogram[1]- average[1]);
                  if(deviation>razn)count++;
                  else break;
                 }
               while(count_dev<count);
               if(count_dev>count)
                  Bull_Open();//Открыть позицию вверх
              }
           }
            //if(0>histogram[1] && 0<histogram[0]) ;              //закрываем часть позиций вверх
            //if(max_line>histogram[1] && max_line<histogram[0]) ; //Закрытие всех позиций вверх
            //if(histogram[1]>histogram[0]) ;                    //держать позиции вверх, закрыть позици вниз
            //
         if(average[1]<histogram[1] && average[0]>histogram[0] && Bear_Signal) 
           {
            Bear_Signal=false;
            Bull_Signal=true;
            Order_Close();
            if(histogram[0]<0)
              {
               i=1;
               double razn=0;
               int count=0;
               do 
                 {
                  i+=1;
                  histogram[1]=iMACD(NULL,0,12,26,9,PRICE_TYPICAL,MODE_MAIN,i);
                  average[1]=iMACD(NULL,0,12,26,9,PRICE_TYPICAL,MODE_SIGNAL,i);
                  razn=MathAbs(histogram[1]- average[1]);
                  if(deviation>razn)count++;
                  else break;
                 }
               while(count_dev<count);
               if(count_dev>count)
                  Bear_Open(); //Открытие позиций вниз
              }
           }
            // if(0<histogram[1] && 0>histogram[0]) ;               //закрываем часть позиций вниз
            // if(min_line<histogram[1] && min_line>histogram[0]) ; //Закрытие всех позиций вниз
            // if(histogram[1]<histogram[0]) ;                      //держать позиции вниз, закрыть позици вверх 
        }
     }else{
      if(OrderBear!=-1 || OrderBull!=-1)
         Order_Close();
     }
   
   
   
   
   //Выход 
   //ExpertRemove();
  }
//+------------------------------------------------------------------+
