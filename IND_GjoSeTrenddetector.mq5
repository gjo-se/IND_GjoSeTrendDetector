/*

   IND_GjoSeTrenddetector.mq5
   Copyright 2021, Gregory Jo
   https://www.gjo-se.com

   Version History
   ===============

   1.0.0 Initial version
   1.3.0 optimize Trend

   ===============

//*/
#include "Basics\\Includes.mqh"

#property   copyright   "2021, GjoSe"
#property   link        "http://www.gjo-se.com"
#property   description "GjoSe Trenddetector"
#define     VERSION "1.3.0"
#property   version VERSION
#property   strict

#property indicator_separate_window

#property indicator_applied_price   PRICE_CLOSE
#property indicator_minimum            -300
#property indicator_maximum            +300

#property indicator_buffers   5
#property indicator_plots     1

#property indicator_type1     DRAW_COLOR_HISTOGRAM
#property indicator_color1    clrBlack, clrGreen, clrRed
#property indicator_width1    2

int    ExtFastMaHandle;
int    ExtMiddleMaHandle;
int    ExtSlowMaHandle;

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnInit() {
   SetIndexBuffer(0, TrendBuffer, INDICATOR_DATA);
   SetIndexBuffer(1, ColorBuffer, INDICATOR_COLOR_INDEX);

   SetIndexBuffer(2, ExtFastMaBuffer, INDICATOR_CALCULATIONS);
   SetIndexBuffer(3, ExtMiddleMaBuffer, INDICATOR_CALCULATIONS);
   SetIndexBuffer(4, ExtSlowMaBuffer, INDICATOR_CALCULATIONS);


   ExtFastMaHandle = iMA(NULL, 0, InpFastMAPeriod, 0, MODE_SMA, PRICE_CLOSE);
   ExtMiddleMaHandle = iMA(NULL, 0, InpMiddleMAPeriod, 0, MODE_SMA, PRICE_CLOSE);
   ExtSlowMaHandle = iMA(NULL, 0, InpSlowMAPeriod, 0, MODE_SMA, PRICE_CLOSE);

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
   }

   int calculated = BarsCalculated(ExtFastMaHandle);
   if(calculated < pRatesTotal) {
      Print("Not all data of ExtFastMaHandle is calculated (", calculated, " bars). Error ", GetLastError());
      return(0);
   }
   calculated = BarsCalculated(ExtMiddleMaHandle);
   if(calculated < pRatesTotal) {
      Print("Not all data of ExtMiddleMaHandle is calculated (", calculated, " bars). Error ", GetLastError());
      return(0);
   }
   calculated = BarsCalculated(ExtSlowMaHandle);
   if(calculated < pRatesTotal) {
      Print("Not all data of ExtSlowMaHandle is calculated (", calculated, " bars). Error ", GetLastError());
      return(0);
   }

   int to_copy;
   if(pPrevCalculated > pRatesTotal || pPrevCalculated < 0)
      to_copy = pRatesTotal;
   else {
      to_copy = pRatesTotal - pPrevCalculated;
      if(pPrevCalculated > 0)
         to_copy++;
   }
   if(IsStopped()) return(0);
   if(CopyBuffer(ExtFastMaHandle, 0, 0, to_copy, ExtFastMaBuffer) <= 0) {
      Print("Getting fast EMA is failed! Error ", GetLastError());
      return(0);
   }

   if(IsStopped()) return(0);
   if(CopyBuffer(ExtMiddleMaHandle, 0, 0, to_copy, ExtMiddleMaBuffer) <= 0) {
      Print("Getting slow SMA is failed! Error ", GetLastError());
      return(0);
   }

   if(IsStopped()) return(0);
   if(CopyBuffer(ExtSlowMaHandle, 0, 0, to_copy, ExtSlowMaBuffer) <= 0) {
      Print("Getting slow SMA is failed! Error ", GetLastError());
      return(0);
   }

   if(pPrevCalculated == 0) {
      start = 0;
   } else {
      start = pPrevCalculated - 1;
   }

   for(i = start; i < pRatesTotal && !IsStopped(); i++) {
      TrendBuffer[i] = TrendDetector(i, close, time);

      if(i > 0) {
         // RO => UP
         //if((TrendBuffer[i - 1] == 0 && TrendBuffer[i] > 0)) {
         //   createVLine(__FUNCTION__ + IntegerToString(time[i]), time[i], clrGreen, 2);
         //}
         //// UP => RO
         //if((TrendBuffer[i - 1] > 0 && TrendBuffer[i] == 0)) {
         //   createVLine(__FUNCTION__ + IntegerToString(time[i]), time[i], clrBlack);
         //}
         //// RO => DOWN
         //if((TrendBuffer[i - 1] == 0 && TrendBuffer[i] < 0)) {
         //   createVLine(__FUNCTION__ + IntegerToString(time[i]), time[i], clrRed, 2);
         //}
         //// DOWN => RO
         //if((TrendBuffer[i - 1] < 0 && TrendBuffer[i] == 0)) {
         //   createVLine(__FUNCTION__ + IntegerToString(time[i]), time[i], clrBlack);
         //}
      }
   }

   return(pRatesTotal);
}
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
