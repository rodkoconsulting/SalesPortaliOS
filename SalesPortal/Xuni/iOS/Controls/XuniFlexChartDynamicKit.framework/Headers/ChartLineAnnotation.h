//
//  ChartLineAnnotation.h
//  FlexChart
//
//  Copyright (c) GrapeCity, Inc. All rights reserved.
//

#import "ChartAnnotation.h"

/**
 *  The line annotation class.
 */
@interface XuniChartLineAnnotation : XuniChartAnnotation

/**
 *  ​Gets or sets the starting point of the line annotation.
 */
@property (nonatomic) XuniPoint *start;

/**
 *  ​Gets or sets the end point of the line annotatio.
 */
@property (nonatomic) XuniPoint *end;

/**
 *  ​​Gets or sets the color of the line.
 */
@property (nonatomic) UIColor *color;

/**
 *  Gets or sets the line width.
 */
@property (nonatomic) double lineWidth;

/**
 *  Initialize an instance of class XuniChartLineAnnotation.
 *
 *  @param chart the FlexChart to init with.
 *
 *  @return an instance of class XuniChartLineAnnotation.
 */
- (instancetype)initWithChart:(FlexChart *)chart;

@end
