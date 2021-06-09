//+------------------------------------------------------------------+
//|                                                       Inputs.mqh |
//|                                  Copyright 2021, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+

enum ENUM_SGL_GWL {
   SGL = 0, // SGL
   GWL = 1 // GWL
};

input ENUM_SGL_GWL        InpSGL_GWL_Type = SGL;
input ENUM_TIMEFRAMES     InpTimeframe = PERIOD_M1;
input int                 InpFastMAPeriod = 10;
input int                 InpMiddleMAPeriod = 100;
input int                 InpSlowMAPeriod = 200;
input double              InpMinTrendStrength = 30;
input double              InpMinFastMiddleOffset = 30;
input double              InpMinMiddleSlowOffset = 30;
//+------------------------------------------------------------------+
