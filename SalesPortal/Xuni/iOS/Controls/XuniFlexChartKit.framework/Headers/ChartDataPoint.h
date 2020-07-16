//
//  ChartDataPoint.h
//  FlexChart
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
 *  XuniChartDataPoint Class.
 */
@interface XuniChartDataPoint : XuniDataPoint

/**
 *  Gets the bubble size for this data point.
 */
@property (readonly) double bubbleSize;

/**
 *  Gets the high value for this data point.
 */
@property (readonly) double high;

/**
 *  Gets the low value for this data point.​
 */
@property (readonly) double low;

/**
 *  Gets the open value for this data point.
 */
@property (readonly) double open;

/**
 *  Gets the close value for this data point.
 */
@property (readonly) double close;

/**
 *  Gets the series index for this data point.​
 */
@property (readonly) int seriesIndex;

/**
 *  Gets the series name for this data point.​
 */
@property (readonly) NSString *seriesName;

/**
 *  Gets the X value for this data point as an object.​
 */
@property (readonly) NSObject *valueX;

/**
 *  Gets this data point's x coordinate.
 */
@property (readonly) double x;

/**
 *  Gets this data point's y coordinate.
 */
@property (readonly) double y;

@end
