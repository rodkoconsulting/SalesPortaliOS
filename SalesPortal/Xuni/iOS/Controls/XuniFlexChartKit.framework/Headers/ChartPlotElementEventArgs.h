//
//  ChartPlotElementEventArgs.h
//  FlexChart
//
//  Copyright (c) GrapeCity, Inc. All rights reserved.
//

#ifndef XuniCoreKit_h
#import "XuniCore/Event.h"
#endif

@class XuniChartHitTestInfo;
@class XuniChartDataPoint;
@class BasePlotElementRender;

/**
 *  Arguments for ChartPlotElement event.
 */
@interface XuniChartPlotElementEventArgs : XuniEventArgs

/**
 *  Gets or sets the render engine.
 */
@property (nonatomic) NSObject<IXuniRenderEngine> *renderEngine;

/**
 *  Gets or sets the hitTest info.
 */
@property (nonatomic) XuniChartHitTestInfo *hitTestInfo;

/**
 *  Gets or sets the dataPoint.
 */
@property (nonatomic) XuniChartDataPoint *dataPoint;

/**
 *  Gets or sets the default render.
 */
@property (nonatomic) BasePlotElementRender *defaultRender;
/**
 *  Gets or sets the candle fill color of the candle chart when open > close or close > open.
 */
@property (nonatomic) UIColor *candleFillColor;
/**
 *  Gets or sets the candle border color of the candle chart.
 */
@property (nonatomic) UIColor *candleBorderColor;

/**
 *  Initialize an instance for ChartPlotElementEventArgs.
 *
 *  @param renderEngine the render engine.
 *  @param hitTestInfo the hitTest info.
 *  @param dataPoint the dataPoint.
 *  @param defaultRender the default render.
 *
 *  @return an instance of ChartPlotElementEventArgs.
 */
- (id)init:(NSObject<IXuniRenderEngine> *)renderEngine hitTestInfo:(XuniChartHitTestInfo *)hitTestInfo dataPoint:(XuniChartDataPoint *)dataPoint defaultRender:(BasePlotElementRender *)defaultRender;

@end
