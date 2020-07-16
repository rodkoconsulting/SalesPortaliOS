//
//  ChartShapeAnnotation.h
//  FlexChart
//
//  Copyright (c) GrapeCity, Inc. All rights reserved.
//

#import "ChartTextAnnotation.h"

/**
 *  The shape annotation class.
 */
@interface XuniChartShapeAnnotation : XuniChartTextAnnotation

/**
 *  Gets or sets the fill color for the annotation.
 */
@property (nonatomic) UIColor *color;

/**
 *  Gets or sets the border color for the annotation.
 */
@property (nonatomic) UIColor *borderColor;

/**
 *  ​Gets or sets the border width for the annotation.
 */
@property (nonatomic) double borderWidth;

/**
 *  Initialize an instance of class XuniChartShapeAnnotation.
 *
 *  @param chart the FlexChart to init with.
 *
 *  @return an instance of class XuniChartShapeAnnotation.
 */
- (instancetype)initWithChart:(FlexChart *)chart;

/**
 *  Get the chart.
 *
 *  @return The chart.
 */
- (FlexChart *)getChart;

@end
