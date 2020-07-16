//
//  DefaultChartDataLabelRenderer.h
//  FlexChart
//
//  Copyright (c) GrapeCity, Inc. All rights reserved.
//

#ifndef FlexChartKit_h
#import "FlexChartDataLabelRenderer.h"
#endif

/**
 * Class DefaultChartDataLabelRenderer.
 */
@interface DefaultChartDataLabelRenderer : FlexChartDataLabelRenderer

/**
 *  Initialize an object for DefaultChartDataLabelRenderer with parameters.
 *
 *  @param chart the chart.
 *  @param label the label.
 *
 *  @return an object for DefaultChartDataLabelRenderer.
 */
-(id)init:(FlexChart *)chart label:(FlexChartDataLabel *)label;


@end
