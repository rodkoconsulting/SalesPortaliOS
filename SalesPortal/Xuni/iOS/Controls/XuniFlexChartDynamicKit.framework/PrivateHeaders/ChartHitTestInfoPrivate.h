//
//  ChartHitTestInfoPrivate.h
//  FlexChart
//
//  Copyright (c) GrapeCity, Inc. All rights reserved.
//

#ifndef FlexChart_ChartHitTestInfoPrivate_h
#define FlexChart_ChartHitTestInfoPrivate_h

@class FlexChart;
@class XuniChartDataPoint;
@protocol IXuniHitArea;

/**
 *  XuniChartHitTestInfo Class.
 */
@interface XuniChartHitTestInfo ()

/**
 *  Gets or sets the chart object the hit test occured inside.
 */
@property FlexChart *chart;

/**
 *  Gets or sets the DataPoint of the XuniChartHitTestInfo.
 */
@property XuniChartDataPoint *dataPoint;

/**
 *  Gets or sets the chart element type selected.
 */
@property XuniChartElement chartElement;

/**
 *  Gets or sets the distance from the closest data point.
 */
@property double distance;

/**
 *  Gets or sets the hit area.
 */
@property NSObject<IXuniHitArea> *area;

/**
 *  Gets or sets the chart series of the XuniChartHitTestInfo.
 */
@property (nonatomic) XuniSeries *series;

@end

#endif
