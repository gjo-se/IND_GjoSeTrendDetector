/*

   IND_GjoSeTrenddetector.mq5
   Copyright 2021, Gregory Jo
   https://www.gjo-se.com

   Version History
   ===============

   1.0.0 Initial version

   ===============

//*/

#include <GjoSe\Indicators\MovingAverages.mqh>
#include <GjoSe\\Objects\\InclVLine.mqh>

// Berta ""

#property   copyright   "2021, GjoSe"
#property   link        "http://www.gjo-se.com"
#property   description "GjoSe Trenddetector"
#define     VERSION "1.0.0-dev"
#property   version VERSION
#property   strict

#property indicator_separate_window

#property indicator_applied_price   PRICE_CLOSE
#property indicator_minimum            -1.4
#property indicator_maximum            +1.4

#property indicator_buffers   1
#property indicator_plots     1

#property indicator_type1     DRAW_HISTOGRAM
#property indicator_color1    Black
#property indicator_width1    2


input int   InpFastMAPeriod = 18;
input int   InpMiddleMAPeriod = 150;
input int   InpSlowMAPeriod = 280;

double      TrendBuffer[];

const int   UP_TREND = 1;
const int   DOWN_TREND = -1;
const int   ROTATION_AREA = 0;

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnInit() {
   SetIndexBuffer(0, TrendBuffer, INDICATOR_DATA);
   PlotIndexSetInteger(0, PLOT_DRAW_BEGIN, InpSlowMAPeriod);
   PlotIndexSetString(0, PLOT_LABEL, "GjoSe Trenddetector( " + (string)InpFastMAPeriod +
                      ", " + (string)InpMiddleMAPeriod + ", " + (string) InpSlowMAPeriod + " ) Version: " + VERSION);

   //int fastMAHandle = iMA(Symbol(), PERIOD_CURRENT, "Custom Moving Average", 13, 0, MODE_EMA, PRICE_TYPICAL);
   //int handle=iMA(Symbol(),PERIOD_M1,InpFastMAPeriod,0,MODE_SMA,PRICE_CLOSE); 
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int OnCalculate(const int pRatesTotal,
                const int pPrevCalculated,
                const datetime &time[],
                const double &open[],
                const double &high[],
                const double &low[],
                const double &close[],
                const long &tick_volume[],
                const long &volume[],
                const int &spread[]         ) {

   int         start, i;

   if(pRatesTotal < InpSlowMAPeriod) {
      return(0);
      Print("Berta: " + pRatesTotal);
   }

   if(pPrevCalculated == 0) {
      start = InpSlowMAPeriod;
   } else {
      start = pPrevCalculated - 1;
   }

// Loop of calculating the indicator buffer values:
   for(i = start; i < pRatesTotal; i++) {
      TrendBuffer[i] = TrendDetector(i, close);

      if(TrendBuffer[i] != TrendBuffer[i - 1]) {
         createVLine(__FUNCTION__ + time[i], time[i]);
      }
   }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
   return(pRatesTotal);
}
//+------------------------------------------------------------------+
int TrendDetector(int pBarShift, const double &pPrice[]) {

   double   bid = 0;
   double   fastMA = 0;
   double   middleMA = 0;
   double   slowMA = 0;
   int      trendDirection = ROTATION_AREA;

   bid = SymbolInfoDouble(Symbol(),SYMBOL_BID);
   fastMA = SimpleMA(pBarShift, InpFastMAPeriod, pPrice);
   middleMA = SimpleMA(pBarShift, InpMiddleMAPeriod, pPrice);
   slowMA = SimpleMA(pBarShift, InpSlowMAPeriod, pPrice);
   
   
   
   Print("Diff bid-Fast: " + (bid / Point() - fastMA / Point()));
   Print("pPrice[0]: " + bid / Point());

   if(bid > fastMA && fastMA > middleMA && middleMA > slowMA) {
      trendDirection = UP_TREND;
   }

   if(bid < fastMA && fastMA < middleMA && middleMA < slowMA) {
      trendDirection = DOWN_TREND;
   }

   return(trendDirection);
}
//+------------------------------------------------------------------+
