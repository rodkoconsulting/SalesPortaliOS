//
//  ChartTextAnnotation.h
//  FlexChart
//
//  Copyright (c) GrapeCity, Inc. All rights reserved.
//

#import "ChartAnnotation.h"
@class FlexChart;
/**
 *  The text annotation class.
 */
@interface XuniChartTextAnnotation : XuniChartAnnotation

/**
 *  Gets or sets the text of the annotation.
 */
@property (nonatomic) NSString *text;

/**
 *  Gets or sets the text color of the annotation.
 */
@property (nonatomic) UIColor *textColor;

/**
 *  Gets or sets the font of the annotation.
 */
@property (nonatomic) UIFont *font;

/**
 *  Initialize an instance of class XuniChartTextAnnotation.
 *
 *  @param chart the FlexChart to init with.
 *
 *  @return an instance of class XuniChartTextAnnotation.
 */
- (instancetype)initWithChart:(FlexChart *)chart;

@end
