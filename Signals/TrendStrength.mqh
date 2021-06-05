//+------------------------------------------------------------------+
//|                                                TrendStrength.mqh |
//|                                  Copyright 2021, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+

double TrendDetector(int pBarShift, const double &pPrice[]) {

   double   fastMA = 0;
   double   middleMA = 0;
   double   slowMA = 0;
   double   fastMAPoints = 0;
   double   middleMAPoints = 0;
   double   slowMAPoints = 0;
   double   trendStrength = ROTATION_AREA;
   double   minMiddleSlowOffset = 25;

   fastMA = ExtFastMaBuffer[pBarShift];
   middleMA = ExtMiddleMaBuffer[pBarShift];
   slowMA = ExtSlowMaBuffer[pBarShift];
   
   fastMAPoints = fastMA / Point();
   middleMAPoints = middleMA / Point();
   slowMAPoints = slowMA / Point();
   
    // UP-TREND
   if(fastMA > middleMA && middleMA > slowMA) {
      trendStrength = fastMAPoints - middleMAPoints;
      if(trendStrength < InpMinTrendStrength){
        trendStrength = ROTATION_AREA;
      }
   }

    // DOWN-TREND
   if(fastMA < middleMA && middleMA < slowMA) {
      trendStrength = fastMAPoints - middleMAPoints;
      if(trendStrength > InpMinTrendStrength){
        trendStrength = ROTATION_AREA;
      }
   }

   // Filter ROTATION_AREA
   if(MathMax(middleMAPoints, slowMAPoints) - MathMin(middleMAPoints, slowMAPoints) < minMiddleSlowOffset){
      trendStrength = ROTATION_AREA;
   }

   return(trendStrength);
}
//+------------------------------------------------------------------+