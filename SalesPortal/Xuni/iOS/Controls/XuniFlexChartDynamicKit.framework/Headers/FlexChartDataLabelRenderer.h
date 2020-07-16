//
//  FlexChartDataLabelRenderer.h
//  FlexChart
//
//  Copyright (c) GrapeCity, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifndef FlexChartKit_h
#import "FlexChart.h"
#import "ChartDataLabel.h"
#endif

@class FlexChartDataLabel;

/**
 *  Class FlexChartDataLabelRenderer.
 */
@interface FlexChartDataLabelRenderer : NSObject
{
    FlexChart *_chart;
    FlexChartDataLabel *_label;
}

/**
 *  Initialize an object for FlexChartDataLabelRenderer with parameters.
 *
 *  @param chart the chart.
 *  @param label the label.
 *
 *  @return an object for FlexChartDataLabelRenderer.
 */
-(id)init:(FlexChart *)chart label:(FlexChartDataLabel *)label;

/**
 *  Render data label.
 *
 *  @param seriesName  the series name.
 *  @param rect        the rect.
 *  @param seriesIndex the index of series.
 *  @param pointIndex  the index of point.
 *  @param x           the x value.
 *  @param y           the y value.
 *  @param valueX      the valueX.
 */
-(void)render:(NSString *)seriesName rect:(XuniRect *)rect seriesIndex:(NSInteger)seriesIndex pointIndex:(NSInteger)pointIndex x:(double)x y:(double)y valueX:(NSObject *)valueX;

/**
 *  Render data label.
 *
 *  @param seriesName the series name.
 *  @param rect       the rect.
 *  @param seriesIndex the index of series.
 *  @param pointIndex  the index of point.
 *  @param x          the x value.
 *  @param y          the y value.
 *  @param valueX      the valueX.
 *  @param bubbleSize the bubble size.
 */
-(void)render:(NSString *)seriesName rect:(XuniRect *)rect seriesIndex:(NSInteger)seriesIndex pointIndex:(NSInteger)pointIndex x:(double)x y:(double)y valueX:(NSObject *)valueX bubbleSize:(double)bubbleSize;
@end


/**
 *  Class FleChartDataLabelData.
 */
@interface FleChartDataLabelData : NSObject

/**
 *  Gets the seriesName.
 */
@property (readonly) NSString *seriesName;

/**
 *  Gets the rect.
 */
@property (readonly) XuniRect *rect;

/**
 *  Gets the seriesIndex.
 */
@property (readonly) NSInteger seriesIndex;

/**
 *  Gets the pointIndex.
 */
@property (readonly) NSInteger pointIndex;

/**
 *  Gets the dataX.
 */
@property (readonly) double dataX;

/**
 *  Gets the dataY.
 */
@property (readonly) double dataY;

/**
 *  Gets the X value.
 */
@property (readonly) NSObject *valueX;

/**
 *  Initialize an object for FleChartDataLabelData with parameters.
 *
 *  @param seriesName The name of the series this data label is for.
 *  @param rect The bounds of the data label.
 *  @param seriesIndex The index of the series this data label is for.
 *  @param pointIndex The index of the object in ItemsSource this data label is for.
 *  @param dataX The X value.
 *  @param dataY The Y value.
 *  @param valueX The valueX.
 *
 *  @return an object for FleChartDataLabelData.
 */
- (id)init:(NSString *)seriesName rect:(XuniRect *)rect seriesIndex:(NSInteger)seriesIndex pointIndex:(NSInteger)pointIndex dataX:(double)dataX dataY:(double)dataY valueX:(NSObject *)valueX;

@end
