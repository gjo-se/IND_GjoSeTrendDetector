//+------------------------------------------------------------------+
//|                                                TrendStrength.mqh |
//|                                  Copyright 2021, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+

double TrendDetector(int pBarShift, const double &pPrice[], const datetime &pTime[]) {

   double   fastMA = 0;
   double   middleMA = 0;
   double   slowMA = 0;
   double   fastMAPoints = 0;
   double   middleMAPoints = 0;
   double   slowMAPoints = 0;
   double   trendStrength = ROTATION_AREA;
   double   fastMiddleOffset = 0;
   double   middleSlowOffset = 0;

   fastMA = ExtFastMaBuffer[pBarShift];
   middleMA = ExtMiddleMaBuffer[pBarShift];
   slowMA = ExtSlowMaBuffer[pBarShift];

   fastMAPoints = fastMA / Point();
   middleMAPoints = middleMA / Point();
   slowMAPoints = slowMA / Point();

   fastMiddleOffset = MathMax(fastMAPoints, middleMAPoints) - MathMin(fastMAPoints, middleMAPoints);
   middleSlowOffset = MathMax(middleMAPoints, slowMAPoints) - MathMin(middleMAPoints, slowMAPoints);

// UP-TREND
//   if(fastMA > middleMA && middleMA > slowMA) {
//      trendStrength = fastMAPoints - middleMAPoints;
//      ColorBuffer[pBarShift] = 1;
//
//      if(trendStrength < InpMinTrendStrength || middleSlowOffset < InpMinMiddleSlowOffset) {
//         trendStrength = ROTATION_AREA;
//         ColorBuffer[pBarShift] = 0;
//      }
//
//      if(fastMiddleOffset > InpMinFastMiddleOffset) {
//         trendStrength = fastMAPoints - middleMAPoints;
//         ColorBuffer[pBarShift] = 1;
//      }
//
//      //if(ColorBuffer[pBarShift - 1] == 0 && ColorBuffer[pBarShift] == 1) {
//      //   //createVLine(__FUNCTION__ + IntegerToString(pTime[pBarShift]), pTime[pBarShift], clrGreen, 2);
//      //}
//      //if(ColorBuffer[pBarShift - 1] == 1 && ColorBuffer[pBarShift] == 0) {
//      //   //createVLine(__FUNCTION__ + IntegerToString(pTime[pBarShift]), pTime[pBarShift], clrBlack);
//      //}
//   }

// DOWN-TREND
   if(fastMA < slowMA) {

      if(fastMA < middleMA) {
         trendStrength = fastMAPoints - slowMAPoints;
         ColorBuffer[pBarShift] = 2;

         if(fastMiddleOffset < InpMinFastMiddleOffset) {
            trendStrength = ROTATION_AREA;
            ColorBuffer[pBarShift] = 0;
         }

         if(pBarShift > 0) {
            if(ColorBuffer[pBarShift - 1] == 0 && ColorBuffer[pBarShift] == 2) {
               createVLine(__FUNCTION__ + IntegerToString(pTime[pBarShift]), pTime[pBarShift], clrRed, 2);
            }
            if(ColorBuffer[pBarShift - 1] == 2 && ColorBuffer[pBarShift] == 0) {
               createVLine(__FUNCTION__ + IntegerToString(pTime[pBarShift]), pTime[pBarShift], clrBlack);
            }
         }
         
      } else {
         trendStrength = InpExitValue;
         ColorBuffer[pBarShift] = 0;
      }
   }

   return(trendStrength);
}


//+------------------------------------------------------------------+
