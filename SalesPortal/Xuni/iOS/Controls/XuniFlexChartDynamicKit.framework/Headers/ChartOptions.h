//
//  ChartOptions.h
//  FlexChart
//
//  Copyright (c) GrapeCity, Inc. All rights reserved.
//

#ifndef FlexChartKit_h
#import "FlexChart.h"
#endif

#import <Foundation/Foundation.h>

/**
 *  FlexChartOptions
 */
@interface FlexChartOptions : NSObject

/**
 *  Gets or sets minimum size of bubble.
 */
@property(nonatomic)  float bubbleMinSize;
/**
 *  Gets or sets maximum size of bubble.
 */
@property(nonatomic)  float bubbleMaxSize;
/**
 *  Gets or sets group width.
 */
@property(nonatomic)  float groupWidth;
/**
 *  Gets or sets candle width.
 */
@property(nonatomic) float candleWidth;

/**
 *  Initialize an object for FlexChartOptions.
 *
 *  @param chart the specified chart.
 *
 *  @return an object for FlexChartOptions.
 */
-(id)init:(FlexChart*)chart;

@end
