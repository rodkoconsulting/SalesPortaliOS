//
//  PieDataPoint.h
//  FlexPie
//
//  Copyright (c) GrapeCity, Inc. All rights reserved.
//


#ifndef XUNI_INTERNAL_DYNAMIC_BUILD
#ifndef XuniChartCoreKit_h
#import "XuniChartCore/DataPoint.h"
#endif
#else
#import "XuniCoreDynamicKit/XuniCoreDynamicKit.h"
#import "XuniChartCoreDynamicKit/XuniChartCoreDynamicKit.h"
#endif
/**
 *  XuniPieDataPoint Class.
 */
@interface XuniPieDataPoint : XuniDataPoint

/**
 *  Gets the name as it appears in the legend.
 */
@property (readonly) NSString *name;

/**
 *  Gets the percentage of this slice in the series.
 */
@property (readonly) double percentage;

@end
