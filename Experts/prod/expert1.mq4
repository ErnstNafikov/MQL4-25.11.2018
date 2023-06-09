//+------------------------------------------------------------------+
//|                                                  glavproduct.mq4 |
//|                        Copyright 2017, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2017, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
#include "VolK.mq4"
bool bull[],bear[],BullClose,BearClose;
int OrderBull,OrderBear,pere;
double OpenOrder,BidOld,result[3];
input double VolPr=15;
input int PointOrder=40;
input int hourStart=10;
input int hourEnd=12;
input bool kanat=true;
input bool macd=true;
input bool stochastic=true;
input bool hour=true;
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//---
   ArrayResize(bull,4);
   ArrayResize(bear,4);
   VBull[0].k=0;
   VBull[0].sum=0;
   VBear[0].k=0;
   VBear[0].sum=0;
   VBear[0].time=TimeCurrent();
   VBull[0].time=TimeCurrent();
   VBear[0].check=true;
   VBear[1].check=false;
   VBull[0].check=true;
   VBull[1].check=false;
   BidOld=Bid;
   pere=0;
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
//1-Проверка первоначальная
   if(hour){
   if(Hour()>hourStart && Hour()<hourEnd){bull[3]=true;bear[3]=true;}
   else{bull[3]=false;bear[3]=false;}}else{bull[3]=true;bear[3]=true;}
   
//Новый бар  
   if(NewBar(VBull[0].time,TimeCurrent()))
      {
      result[2]=result[1];
      result[1]=result[0];
      }
      
     //-------------MACD
   if(macd)
   {
   result[0]=iMACD(_Symbol,_Period,12,26,9,5,0,0);
   if(((MathAbs(result[1])>MathAbs(result[2])&& result[0]<0)||(MathAbs(result[1])<MathAbs(result[2])&& result[0]>0))&&result[2]!=0)
      {
      bear[0]=true;
      bull[0]=false;
     // BullClose=true;
     // BearClose=false;
      }
   else
   if(((MathAbs(result[1])>MathAbs(result[2])&& result[0]>0)||(MathAbs(result[1])<MathAbs(result[2])&& result[0]<0))&&result[2]!=0)
      {
      bear[0]=false;
      bull[0]=true;
     // BullClose=false;
      //BearClose=true;
      }
   else
   {
   bear[0]=false;
   bull[0]=false;
   }}else{bull[0]=true;bear[0]=true;}
   
   //-------------Stochastic
   if(stochastic)
   {
   double red = iStochastic(_Symbol,_Period,5,3,3,1,0,1,0);  
   double blue = iStochastic(_Symbol,_Period,5,3,3,1,0,0,0);
   if(red>blue){bull[2]=false;bear[2]=true;}
   else if(blue>red){bull[2]=true;bear[2]=false;}
   else {bull[2]=false;bear[2]=false;}
   
   if(blue>90|| red>75){pere=1;bull[2]=false;}
   else if(blue<10 || red<25){pere=-1;bear[2]=false;}
   else {pere=0;}
   }else{bull[2]=true;bear[2]=true;}
   
   //-------------Kanat
   if(kanat)
   {
   CountingKanat(Bid,BidOld);
   BidOld=Bid;
   if(VBull[1].check)
      {
      if(VBull[0].Itog>4){bull[1]=true;bear[1]=false;}
      else if(VBull[0].Itog<-4){bear[1]=true;bull[1]=false;}
      else 
         {
         bear[1]=false;
         bull[1]=false;
         }
      }else{
      bear[1]=false;
      bull[1]=false;
      }
    }else{bear[1]=true;bull[1]=true;}
    VBull[0].time=TimeCurrent();
    
  
   
//--Совершаем открытие/закрытие
  LowUp(VBear[0].Itog);
//Вывод занчения 
  Print(VBear[0].Itog);  
  }
//+------------------------------------------------------------------+
