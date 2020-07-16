//
//  ChartHitTestInfo.h
//  FlexChart
//
//  Copyright (c) GrapeCity, Inc. All rights reserved.
//

#ifndef XUNI_INTERNAL_DYNAMIC_BUILD

#ifndef XuniChartCoreKit_h
#import "XuniChartCore/HitTestInfo.h"
#endif

#else
#import "XuniCoreDynamicKit/XuniCoreDynamicKit.h"
#import "XuniChartCoreDynamicKit/XuniChartCoreDynamicKit.h"
#endif

@class FlexChart;
@class XuniChartDataPoint;
@class XuniChartAnnotation;

/**
 *  XuniChartHitTestInfo Class.
 */
@interface XuniChartHitTestInfo : XuniHitTestInfo

/**
 *  Gets the chart object the hit test occured inside.
 */
@property (readonly) FlexChart *chart;

/**
 *  Gets the DataPoint of the XuniChartHitTestInfo.
 */
@property (readonly) XuniChartDataPoint *dataPoint;

/**
 *  Gets the chart element type selected.
 */
@property (readonly) XuniChartElement chartElement;

/**
 *  Gets the distance from the closest data point.
 */
@property (readonly) double distance;

/**
 *  Gets or sets the selected annotation.
 */
@property (nonatomic) XuniChartAnnotation *annotation;

/**
 *  Initialize an object of XuniChartHitTestInfo.
 *
 *  @param chart the FlexChart.
 *  @param x     the x coordinate.
 *  @param y     the y coordinate.
 *
 *  @return an object of XuniChartHitTestInfo.
 */
- (id)initWithChart:(FlexChart *)chart x:(double)x y:(double)y;

@end
