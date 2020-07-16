//
//  ChartDataPointPrivate.h
//  FlexChart
//
//  Copyright (c) GrapeCity, Inc. All rights reserved.
//

#ifndef FlexChart_ChartDataPointPrivate_h
#define FlexChart_ChartDataPointPrivate_h

/**
 *  XuniChartDataPoint Class.
 */
@interface XuniChartDataPoint ()

/**
 *  Gets or sets the bubble size for this data point.
 */
@property double bubbleSize;

/**
 *  Gets or sets the high value for this data point.
 */
@property double high;

/**
 *  Gets or sets the low value for this data point.
 */
@property double low;

/**
 *  Gets or sets the open value for this data point.
 */
@property double open;

/**
 *  Gets or sets the close value for this data point.
 */
@property double close;

/**
 *  Gets or sets the series index for this data point.
 */
@property int seriesIndex;

/**
 *  Gets or sets the series name for this data point.
 */
@property NSString *seriesName;

/**
 *  Gets or sets the X value for this data point as an object.
 */
@property NSObject *valueX;

/**
 *  Gets or sets numeric X value for this data point.
 */
@property double dataX;

/**
 *  Gets or sets this data point's x coordinate.
 */
@property double x;

/**
 *  Gets or sets this data point's y coordinate.
 */
@property double y;

@end

#endif
