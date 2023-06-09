//+------------------------------------------------------------------+
//|                                                         VolK.mq4 |
//|                        Copyright 2017, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property library
#property copyright "Copyright 2017, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
//+------------------------------------------------------------------+
//| My function                                                      |
//+------------------------------------------------------------------+
struct Kanat
   {
   int k;
   int sum;
   double plotnost;
   datetime time;
   int Itog;
   bool check;
   };
Kanat VBear[2],VBull[2];
void CountingKanat(double bid0,double bid1)
   {
   int razn;
   razn=int((bid0-bid1)/Point);
   if(NewBar(VBear[0].time,TimeCurrent()))
      {
      VBull[1].k=VBull[0].k;
      VBull[1].sum=VBull[0].sum;
      VBull[1].plotnost=VBull[0].plotnost;
      VBull[1].Itog=VBull[0].Itog;
      VBear[1].k=VBear[0].k;
      VBear[1].sum=VBear[0].sum;
      VBear[1].plotnost=VBear[0].plotnost;
      VBear[1].Itog=VBear[0].Itog;
      if(!VBear[1].check)
         {
         VBear[1].check=true;
         VBull[1].check=true;
         }
      VBull[0].k=0;
      VBull[0].sum=0;
      VBear[0].k=0;
      VBear[0].sum=0;
      }
   VBear[0].time=TimeCurrent();
   if(razn>0)
      {
      VBull[0].k++;
      VBull[0].sum+=razn;
      VBull[0].plotnost=(double)VBull[0].sum/VBull[0].k;
      }
   else
   if(razn<0)
      {
      VBear[0].k++;
      VBear[0].sum+=MathAbs(razn);
      VBear[0].plotnost=(double)VBear[0].sum/VBear[0].k;
      }
   if(VBear[1].check)
      {
      VBear[0].Itog=0;
      VBull[0].Itog=0;
      int k=0;
      if(VBear[0].sum>VBull[0].sum) k--;
      if(VBear[0].sum<VBull[0].sum) k++;
      if(VBear[0].k>VBull[0].k) k--;
      if(VBear[0].k<VBull[0].k) k++;
      if(VBear[0].plotnost>VBear[0].plotnost) k--;
      if(VBear[0].plotnost<VBear[0].plotnost) k++;
      if((VBear[0].sum-VBear[1].sum)>(VBull[0].sum-VBull[1].sum)) k--;
      if((VBear[0].sum-VBear[1].sum)<(VBull[0].sum-VBull[1].sum)) k++;
      if((VBear[0].k-VBear[1].k)>(VBull[0].k-VBull[1].k)) k--;
      if((VBear[0].k-VBear[1].k)<(VBull[0].k-VBull[1].k)) k++;
      if((VBear[0].plotnost-VBear[1].plotnost)>(VBull[0].plotnost-VBull[1].plotnost)) k--;
      if((VBear[0].plotnost-VBear[1].plotnost)<(VBull[0].plotnost-VBull[1].plotnost)) k++;
      VBear[0].Itog=k;
      VBull[0].Itog=k;
      }
   };
bool NewBar(datetime time1,datetime time0)
   {
   if(time0%(60*_Period)<time1%(60*_Period))
      return true;
   else 
      return false;
   };
   
void LowUp(int itog)
   {
//3-Действия
//Рассчет /kof
   int kof=1;
  // if(itog<6 && itog>-6) kof*=2;
  // if(pere!=0)kof*=2;
   double VolOrder=AccountBalance()*VolPr/100/MarketInfo(_Symbol,MODE_MARGINREQUIRED);
//3.1 Открытие
   bool BullOpen=true,BearOpen=true;
   BearClose=false;
   BullClose=false;
   //Логика открытия
   for(int i=0;i<ArraySize(bull);i++)
      if(!bull[i])BullOpen=false;
   for(int i=0;i<ArraySize(bear);i++)
      if(!bear[i])BearOpen=false;
   //Логика закрытия
   if(BullOpen || !bull[3])BearClose=true;
   if(BearOpen || !bull[3])BullClose=true;
   
   
   if(BullOpen)
      {
      if(OrderBull!=0)
      {
      if(OpenOrder<NormalizeDouble(Ask-PointOrder/4*Point,Digits))
         {
         if(OrderSelect(OrderBull,SELECT_BY_TICKET))
            bool oc=OrderClose(OrderBull,OrderLots(),Bid,100);
         OrderBull=OrderSend(_Symbol,0,VolOrder,Ask,100,NormalizeDouble(Ask-PointOrder/kof*Point,Digits),NormalizeDouble(Ask+PointOrder/kof*Point,Digits));
         if(OrderSelect(OrderBull,SELECT_BY_TICKET))
            OpenOrder=OrderOpenPrice();
         }}else{
         OrderBull=OrderSend(_Symbol,0,VolOrder,Ask,100,NormalizeDouble(Ask-PointOrder/kof*Point,Digits),NormalizeDouble(Ask+PointOrder/kof*Point,Digits));
         if(OrderSelect(OrderBull,SELECT_BY_TICKET))
         OpenOrder=OrderOpenPrice();
         }
      }
   if(BearOpen)
      {
      if(OrderBear!=0)
      {
      if(OpenOrder>NormalizeDouble(Bid+PointOrder/4*Point,Digits))
         {
         if(OrderSelect(OrderBear,SELECT_BY_TICKET))
            bool oc=OrderClose(OrderBear,OrderLots(),Ask,100);
         OrderBear=OrderSend(_Symbol,1,VolOrder,Bid,100,NormalizeDouble(Bid+PointOrder/kof*Point,Digits),NormalizeDouble(Bid-PointOrder/kof*Point,Digits));
         if(OrderSelect(OrderBear,SELECT_BY_TICKET))
            OpenOrder=OrderOpenPrice();
         }}else{
         OrderBear=OrderSend(_Symbol,1,VolOrder,Bid,100,NormalizeDouble(Bid+PointOrder/kof*Point,Digits),NormalizeDouble(Bid-PointOrder/kof*Point,Digits));
         if(OrderSelect(OrderBear,SELECT_BY_TICKET))
         OpenOrder=OrderOpenPrice();
         }
      }
//3.2 Закрытие по сигналу

   if(BullClose && OrderBull!=0)
      {
      if(OrderSelect(OrderBull,SELECT_BY_TICKET))
            bool oc=OrderClose(OrderBull,OrderLots(),Bid,100);
      OrderBull=0;
      }
   if(BearClose && OrderBear!=0)
      {
      if(OrderSelect(OrderBear,SELECT_BY_TICKET))
         bool oc=OrderClose(OrderBear,OrderLots(),Ask,100);
      OrderBear=0;
      }  
   };