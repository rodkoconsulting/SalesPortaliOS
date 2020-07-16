//
//  AreaPlotter.h
//  FlexChart
//
//  Copyright (c) GrapeCity, Inc. All rights reserved.
//

#import "IPlotter.h"

@class FlexChart;
@class XuniDataInfo;
@class XuniHitTester;

/**
 *  XuniAreaPlotter Class.
 */
@interface XuniAreaPlotter : XuniBasePlotter

/**
 *  gets or sets chart.
 */
@property FlexChart *chart;

/**
 *  gets or sets dataInfo.
 */
@property XuniDataInfo *dataInfo;

/**
 *  gets or sets the chart element at specified point.
 */
@property XuniHitTester *hitTester;

/**
 *  gets or sets the stacking type of chart.
 */
@property XuniStacking stacking;

/**
 *  gets or sets whether the direction of plotting is inverted.
 */
@property BOOL rotated;

/**
 *  gets or sets whether the chart is spline.
 */
@property BOOL isSpline;

/**
 *  Initialize an instance for AreaPlotter.
 *
 *  @param chart     the chart.
 *  @param dataInfo  the dataInfo.
 *  @param hitTester the chart element at specified point.
 *
 *  @return an instance of AreaPlotter.
 */
- (id)init:(FlexChart*)chart dataInfo:(XuniDataInfo*)dataInfo hitTester:(XuniHitTester*)hitTester;
@end
