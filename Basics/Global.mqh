//+------------------------------------------------------------------+
//|                                                      Global.mqh |
//|                                  Copyright 2021, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+

CTradeHedge Trade;
CPending    Pending;
CPositions  Positions;
CBars       Bar;
CTrailing   Trail;
CTimer      Timer;
CNewBar     NewBar;


double      TrendBuffer[];
double      ColorBuffer[];
double      ExtFastMaBuffer[];
double      ExtMiddleMaBuffer[];
double      ExtSlowMaBuffer[];



//int      tickvolumeHandle;
//double   tickVolumeBuffer[];