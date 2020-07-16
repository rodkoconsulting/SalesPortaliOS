//
//  FinancePlotter.h
//  FlexChart
//
//  Copyright (c) GrapeCity, Inc. All rights reserved.
//

#import "IPlotter.h"

/**
 *  XuniFinancePlotter class.
 */
@interface XuniFinancePlotter : XuniBasePlotter

/**
 *  gets or sets chart.
 */
@property FlexChart *chart;

/**
 *  gets or sets dataInfo.
 */
@property XuniDataInfo *dataInfo;

/**
 *  gets or sets hitTester.
 */
@property XuniHitTester *hitTester;

/**
 *  gets or sets index of series.
 */
@property int seriesIndex;

/**
 *  gets or sets series count.
 */
@property int seriesCount;

/**
 *  gets or sets the stacking type of chart.
 */
@property XuniStacking stacking;

/**
 *  gets or sets whether the direction of plotting is inverted.
 */
@property BOOL rotated;

/**
 *  gets or sets  whether the chart is candle.
 */
@property BOOL isCandle;

/**
 *  Initialize an instance for FinancePlotter.
 *
 *  @param chart     the chart.
 *  @param dataInfo  the dataInfo.
 *  @param hitTester the chart element at specified point.
 *
 *  @return an instance of FinancePlotter.
 */
- (id)init:(FlexChart*)chart dataInfo:(XuniDataInfo*)dataInfo hitTester:(XuniHitTester*)hitTester;
@end
