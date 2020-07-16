//
//  ChartImageAnnotation.h
//  FlexChart
//
//  Copyright (c) GrapeCity, Inc. All rights reserved.
//

#import "ChartAnnotation.h"
#import "FlexChart.h"
#import <ImageIO/ImageIO.h>

/**
 *  The image annotation class.
 */
@interface XuniChartImageAnnotation : XuniChartAnnotation<NSURLConnectionDataDelegate,NSURLConnectionDelegate>

/**
 *  Gets or sets the image source.
 */
@property (nonatomic) UIImage *source;

/**
 *  Initialize an instance of class XuniChartImageAnnotation.
 *
 *  @param chart the FlexChart to init with.
 *
 *  @return an instance of class XuniChartImageAnnotation.
 */
- (instancetype)initWithChart:(FlexChart *)chart;

/**
 *  Set image with URL.
 *  @param urlString url string.
 */
- (void)setImageWithURL:(NSString *)urlString;

@end
