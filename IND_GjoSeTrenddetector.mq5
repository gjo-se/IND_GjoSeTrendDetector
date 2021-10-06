/*

   IND_GjoSeTrenddetector.mq5
   Copyright 2021, Gregory Jo
   https://www.gjo-se.com

   Version History
   ===============

   1.0.0 Initial version
   1.3.0 optimize Trend
   1.4.0 add GWL
   1.4.1 add SGL & GWL

   ===============

//*/
#include "Basics\\Includes.mqh"

#property   copyright   "2021, GjoSe"
#property   link        "http://www.gjo-se.com"
#property   description "GjoSe Trenddetector"
#define     VERSION "2.0"
#property   version VERSION
#property   strict

#property indicator_chart_window

#property indicator_buffers   11
#property indicator_plots     1

#property indicator_label1  ""
#property indicator_type1   DRAW_COLOR_CANDLES
#property indicator_color1  Gray, Green, Red
#property indicator_style1  STYLE_SOLID
#property indicator_width1  1

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnInit() {
   SetIndexBuffer(0, OpenBuffer, INDICATOR_DATA);
   SetIndexBuffer(1, HighBuffer, INDICATOR_DATA);
   SetIndexBuffer(2, LowBuffer, INDICATOR_DATA);
   SetIndexBuffer(3, CloseBuffer, INDICATOR_DATA);
   SetIndexBuffer(4, CandleColorBuffer, INDICATOR_COLOR_INDEX);

   IndicatorSetInteger(INDICATOR_DIGITS, _Digits);
   PlotIndexSetInteger(0, PLOT_SHOW_DATA, false);
   PlotIndexSetDouble(0, PLOT_EMPTY_VALUE, EMPTY_VALUE);
   PlotIndexSetDouble(1, PLOT_EMPTY_VALUE, EMPTY_VALUE);
   PlotIndexSetDouble(2, PLOT_EMPTY_VALUE, EMPTY_VALUE);
   PlotIndexSetDouble(3, PLOT_EMPTY_VALUE, EMPTY_VALUE);

   ExtSGLFastMaHandle = iMA(Symbol(), Period(), InpFastMAPeriod, 0, MODE_SMA, PRICE_CLOSE);
   SetIndexBuffer(5, ExtSGLFastMaBuffer, INDICATOR_DATA);
   ExtSGLMiddleMaHandle = iMA(Symbol(), Period(), InpMiddleMAPeriod, 0, MODE_SMA, PRICE_CLOSE);
   SetIndexBuffer(6, ExtSGLMiddleMaBuffer, INDICATOR_DATA);
   ExtSGLSlowMaHandle = iMA(Symbol(), Period(), InpSlowMAPeriod, 0, MODE_SMA, PRICE_CLOSE);
   SetIndexBuffer(7, ExtSGLSlowMaBuffer, INDICATOR_DATA);

   ExtGWLFastMaHandle = iMA(Symbol(), InpGWLTimeframe, InpFastMAPeriod, 0, MODE_SMA, PRICE_CLOSE);
   SetIndexBuffer(8, ExtGWLFastMaBuffer, INDICATOR_DATA);
   ExtGWLMiddleMaHandle = iMA(Symbol(), InpGWLTimeframe, InpMiddleMAPeriod, 0, MODE_SMA, PRICE_CLOSE);
   SetIndexBuffer(9, ExtGWLMiddleMaBuffer, INDICATOR_DATA);
   ExtGWLSlowMaHandle = iMA(Symbol(), InpGWLTimeframe, InpSlowMAPeriod, 0, MODE_SMA, PRICE_CLOSE);
   SetIndexBuffer(10, ExtGWLSlowMaBuffer, INDICATOR_DATA);

   periodSecondsSGL = PeriodSeconds();
   periodSecondsGWL = PeriodSeconds(InpGWLTimeframe);

   if(periodSecondsSGL <= periodSecondsGWL) {
      periodRatio = periodSecondsGWL / periodSecondsSGL;
   } else {
      Alert("GWL muss größer oder gleich SGL sein");
   }

}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int OnCalculate(const int pRatesTotal,
                const int pPrevCalculated,
                const datetime &pTime[],
                const double &pOpen[],
                const double &pHigh[],
                const double &pLow[],
                const double &pClose[],
                const long &pTickVolume[],
                const long &pVolume[],
                const int &pSpread[]         ) {

   int      start, i;
   int      barsGWLTimeFrameCount;
   int      calculatedBars;
   int      gwlTrend = 0;
   int      sglTrend = 0;
   int      trend = 0;
   
   barsGWLTimeFrameCount = Bars(Symbol(), InpGWLTimeframe) - 1;
   if(barsGWLTimeFrameCount < InpSlowMAPeriod || pRatesTotal < InpSlowMAPeriod) {
      return(0);
   }

   OpenBuffer[pRatesTotal - 1] = EMPTY_VALUE;
   HighBuffer[pRatesTotal - 1] = EMPTY_VALUE;
   LowBuffer[pRatesTotal - 1] = EMPTY_VALUE;
   CloseBuffer[pRatesTotal - 1] = EMPTY_VALUE;

   calculatedBars = BarsCalculated(ExtSGLFastMaHandle);
   if(calculatedBars < pRatesTotal) {
      Print("Not all data of ExtSGLFastMaHandle is calculated (", calculatedBars, " bars). Error ", GetLastError());
      return(0);
   }
   calculatedBars = BarsCalculated(ExtSGLMiddleMaHandle);
   if(calculatedBars < pRatesTotal) {
      Print("Not all data of ExtSGLMiddleMaHandle is calculated (", calculatedBars, " bars). Error ", GetLastError());
      return(0);
   }
   calculatedBars = BarsCalculated(ExtSGLSlowMaHandle);
   if(calculatedBars < pRatesTotal) {
      Print("Not all data of ExtSGLSlowMaHandle is calculated (", calculatedBars, " bars). Error ", GetLastError());
      return(0);
   }

   calculatedBars = BarsCalculated(ExtGWLFastMaHandle);
   if(calculatedBars < barsGWLTimeFrameCount) {
      Print("Not all data of ExtGWLFastMaHandle is calculated (", calculatedBars, " bars). Error ", GetLastError());
      return(0);
   }

   calculatedBars = BarsCalculated(ExtGWLMiddleMaHandle);
   if(calculatedBars < barsGWLTimeFrameCount) {
      Print("Not all data of ExtGWLMiddleMaHandle is calculated (", calculatedBars, " bars). Error ", GetLastError());
      return(0);
   }

   calculatedBars = BarsCalculated(ExtGWLSlowMaHandle);
   if(calculatedBars < barsGWLTimeFrameCount) {
      Print("Not all data of ExtGWLSlowMaHandle is calculated (", calculatedBars, " bars). Error ", GetLastError());
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
   if(CopyBuffer(ExtSGLFastMaHandle, 0, 0, to_copy, ExtSGLFastMaBuffer) <= 0) {
      Print("Getting fast EMA is failed! Error ", GetLastError());
      return(0);
   }

   if(IsStopped()) return(0);
   if(CopyBuffer(ExtSGLMiddleMaHandle, 0, 0, to_copy, ExtSGLMiddleMaBuffer) <= 0) {
      Print("Getting middle SMA is failed! Error ", GetLastError());
      return(0);
   }

   if(IsStopped()) return(0);
   if(CopyBuffer(ExtSGLSlowMaHandle, 0, 0, to_copy, ExtSGLSlowMaBuffer) <= 0) {
      Print("Getting slow SMA is failed! Error ", GetLastError());
      return(0);
   }

   if(pPrevCalculated == 0) {
      start = 0;
   } else {
      start = pPrevCalculated - 1;
   }

   for(i = start; i < pRatesTotal && !IsStopped(); i++) {
   
      OpenBuffer[i]         = pOpen[i];
      HighBuffer[i]         = pHigh[i];
      LowBuffer[i]          = pLow[i];
      CloseBuffer[i]        = pClose[i];
      CandleColorBuffer[i]  = ROTATION_AREA;

      if(i > 0) {
         if(CopyBuffer(ExtGWLFastMaHandle, 0, pTime[i], 1, ExtGWLFastMaTmpArray) <= 0) {
            if(InpShowErrorMessages) Print("Getting GWLFastMa failed! Error", GetLastError());
            return(0);
         } else {
            ExtGWLFastMaBuffer[i] = ExtGWLFastMaTmpArray[0];
         }

         if(CopyBuffer(ExtGWLMiddleMaHandle, 0, pTime[i], 1, ExtGWLMiddleMaTmpArray) <= 0) {
            if(InpShowErrorMessages) Print("Getting GWLMiddleMa failed! Error", GetLastError());
            return(0);
         } else {
            ExtGWLMiddleMaBuffer[i] = ExtGWLMiddleMaTmpArray[0];
         }

         if(CopyBuffer(ExtGWLSlowMaHandle, 0, pTime[i], 1, ExtGWLSlowMaTmpArray) <= 0) {
            if(InpShowErrorMessages) Print("Getting GWLSlowMa failed! Error", GetLastError());
            return(0);
         } else {
            ExtGWLSlowMaBuffer[i] = ExtGWLSlowMaTmpArray[0];
         }
      }

      // SGL UP
      if(ExtSGLFastMaBuffer[i] > ExtSGLSlowMaBuffer[i]) {
         if(ExtSGLFastMaBuffer[i] > ExtSGLMiddleMaBuffer[i]) {
            sglTrend = UP_TREND;
         }
      }

      // SGL DOWN
      if(ExtSGLFastMaBuffer[i] < ExtSGLSlowMaBuffer[i]) {
         if(ExtSGLFastMaBuffer[i] < ExtSGLMiddleMaBuffer[i]) {
            sglTrend = DOWN_TREND;
         }
      }

      // GWL UP
      if(ExtGWLFastMaBuffer[i] > ExtGWLSlowMaBuffer[i]) {
         if(ExtGWLFastMaBuffer[i] > ExtGWLMiddleMaBuffer[i]) {
            gwlTrend = UP_TREND;
         }
      }

      // GWL DOWN
      if(ExtGWLFastMaBuffer[i] < ExtGWLSlowMaBuffer[i]) {
         if(ExtGWLFastMaBuffer[i] < ExtGWLMiddleMaBuffer[i]) {
            gwlTrend = DOWN_TREND;
         }
      }

      if(gwlTrend == UP_TREND) {
         if(sglTrend == UP_TREND){
            CandleColorBuffer[i] = UP_TREND;
         }
      }

      if(gwlTrend == DOWN_TREND) {
         if(sglTrend == DOWN_TREND){
            CandleColorBuffer[i] = DOWN_TREND;
         }
      }

   }

   return(pRatesTotal);
}
//+------------------------------------------------------------------+
