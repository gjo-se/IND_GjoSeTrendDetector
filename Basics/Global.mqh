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

double      OpenBuffer[];
double      HighBuffer[];
double      LowBuffer[];
double      CloseBuffer[];
double      CandleColorBuffer[];


double      ExtSGLFastMaBuffer[];
int         ExtSGLFastMaHandle;
double      ExtSGLMiddleMaBuffer[];
int         ExtSGLMiddleMaHandle;
double      ExtSGLSlowMaBuffer[];
int         ExtSGLSlowMaHandle;

double      ExtGWLFastMaBuffer[];
double      ExtGWLFastMaTmpArray[];
int         ExtGWLFastMaHandle;
double      ExtGWLMiddleMaBuffer[];
double      ExtGWLMiddleMaTmpArray[];
int         ExtGWLMiddleMaHandle;
double      ExtGWLSlowMaBuffer[];
double      ExtGWLSlowMaTmpArray[];
int         ExtGWLSlowMaHandle;

int         periodSecondsSGL = 0;
int         periodSecondsGWL = 0;
int         periodRatio = 1;
