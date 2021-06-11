//+------------------------------------------------------------------+
//|                                                       Inputs.mqh |
//|                                  Copyright 2021, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+

input ENUM_TIMEFRAMES     InpTimeframe = PERIOD_M1;
input int                 InpFastMAPeriod = 1;
input int                 InpMiddleMAPeriod = 50;
input int                 InpSlowMAPeriod = 200;
input double              InpMinTrendStrength = 30;
input double              InpMinFastMiddleOffset = 30;
input double              InpMinMiddleSlowOffset = 30;
input int                 InpExitValue = 999999;
//+------------------------------------------------------------------+
