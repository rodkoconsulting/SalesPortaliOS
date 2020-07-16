//
//  IPlotter.h
//  FlexChart
//
//  Copyright (c) GrapeCity, Inc. All rights reserved.
//

#ifndef XUNI_INTERNAL_DYNAMIC_BUILD

#ifndef XuniChartCoreKit_h
#import "XuniChartCore/FlexChartBase.h"
#endif

#else
#import "XuniChartCoreDynamicKit/XuniChartCoreDynamicKit.h"
#endif


@class FlexChart;
@class XuniDataInfo;
@class XuniHitTester;
@class XuniObservableArray;
@protocol IXuniRenderEngine;
@protocol IXuniAxis;
@protocol IXuniSeries;
@protocol IXuniPalette;



/**
 *  protocol IXuniPlotter.
 */
@protocol IXuniPlotter
/**
 *  gets or sets  chart.
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
 *  gets or sets the time.
 */
@property double time;

/**
 *  gets or sets the dataInfoCount.
 */
@property int dataInfoCount;

/**
 *  gets or sets the size of symbols.
 */
@property double symbolSize;

/**
 *  gets or sets the origin of the series plotted.
 */
@property double origin;

/**
 *  reset something.
 */
- (void)clear;

/**
 *  Use for caculating the rect of chart.
 *
 *  @param dataInfo an instance contains data and info of chart.
 *  @param logBase  the logBase value.
 *
 *  @return the rect of chart.
 */
- (XuniRect*)adjustLimits:(XuniDataInfo*)dataInfo logBase:(NSNumber*)logBase;

/**
 *  Method for drawing chart when changing chart type.
 *
 *  @param engine the object of IXuniRenderEngine.
 */
- (void)redoSelection:(NSObject<IXuniRenderEngine>*)engine;

/**
 *  Gets real length.
 *
 *  @param seriesCollection the seriesCollection.
 *
 *  @return the real length.
 */
- (int)getRealLen:(XuniObservableArray*)seriesCollection;

/**
*  Specific method for plotting series.
*
*  @param series the series.
*  @param engine the engine.
*  @param ax the axis X.
*  @param ay the axis Y.
*  @param iser the index of the series in seriesCollection.
*  @param irealser the index of the series when only counting series that are visible.
*  @param nser the seriesCollection size.
*  @param sel the index of the selected series in seriesCollection.
*  @param chartType the type chart to plot.
*  @param stackPos internal stack of positive values.
*  @param stackNeg internal stack of negative values.
*
*/
- (void)plotSeries:(NSObject<IXuniSeries>*)series engine:(NSObject<IXuniRenderEngine>*)engine axisX:(NSObject<IXuniAxis>*)ax axisY:(NSObject<IXuniAxis>*)ay index:(int)iser realIndex:(int)irealser count:(int)nser selectedIndex:(int)sel chartType:(XuniChartType)chartType stackPos:(NSMutableDictionary *)stackPos stackNeg:(NSMutableDictionary *)stackNeg;

/**
*  Specific method for plotting series.
*
*  @param seriesCollection the seriesCollection to plot.
*  @param engine the engine.
*  @param ax the Axis X.
*  @param ay the Axis Y.
*  @param selection the selected series.
*  @param isel the index of the selected series in seriesCollection.
*  @param stackPos internal stack of positive values.
*  @param stackNeg internal stack of negative values.
*/
- (void)plotSeriesCollection:(XuniObservableArray*)seriesCollection engine:(NSObject<IXuniRenderEngine>*)engine axisX:(NSObject<IXuniAxis>*)ax axisY:(NSObject<IXuniAxis>*)ay selectedSeries:(NSObject<IXuniSeries>*)selection elementIndex:(int)isel stackPos:(NSMutableDictionary *)stackPos stackNeg:(NSMutableDictionary *)stackNeg;

@end

/**
 *  XuniBasePlotter Class.
 */
@interface XuniBasePlotter : NSObject<IXuniPlotter>

/**
 *  gets or sets  chart.
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
 *  gets or sets the time.
 */
@property double time;

/**
 *  gets or sets the dataInfoCount.
 */
@property int dataInfoCount;

/**
 *  gets or sets the size of symbols.
 */
@property double symbolSize;

/**
 *  gets or sets the origin of the series plotted.
 */
@property double origin;

/**
 *  Initialize an instance for LinePlotter.
 *
 *  @param chart the chart.
 *
 *  @return an instance of LinePlotter.
 */
- (id)init:(FlexChart*)chart;

/**
 *  Get real length.
 *
 *  @param seriesCollection the seriesCollection.
 *
 *  @return the real length.
 */
- (int)getRealLen:(XuniObservableArray*)seriesCollection;

/**
*  Specific method for plotting series.
*
*  @param series the series.
*  @param engine the engine.
*  @param ax the axis X.
*  @param ay the axis Y.
*  @param iser the index of the series in seriesCollection.
*  @param irealser the index of the series when only counting series that are visible.
*  @param nser the seriesCollection size.
*  @param sel the index of the selected series in seriesCollection.
*  @param chartType the type chart to plot.
*  @param stackPos internal stack of positive values.
*  @param stackNeg internal stack of negative values.
*
*/
- (void)plotSeries:(NSObject<IXuniSeries>*)series engine:(NSObject<IXuniRenderEngine>*)engine axisX:(NSObject<IXuniAxis>*)ax axisY:(NSObject<IXuniAxis>*)ay index:(int)iser realIndex:(int)irealser count:(int)nser selectedIndex:(int)sel chartType:(XuniChartType)chartType stackPos:(NSMutableDictionary *)stackPos stackNeg:(NSMutableDictionary *)stackNeg;

/**
*  Specific method for plotting series.
*
*  @param seriesCollection the seriesCollection to plot.
*  @param engine the engine.
*  @param ax the Axis X.
*  @param ay the Axis Y.
*  @param selection the selected series.
*  @param isel the index of the selected series in seriesCollection.
*  @param stackPos internal stack of positive values.
*  @param stackNeg internal stack of negative values.
*/
- (void)plotSeriesCollection:(XuniObservableArray*)seriesCollection engine:(NSObject<IXuniRenderEngine>*)engine axisX:(NSObject<IXuniAxis>*)ax axisY:(NSObject<IXuniAxis>*)ay selectedSeries:(NSObject<IXuniSeries>*)selection elementIndex:(int)isel stackPos:(NSMutableDictionary *)stackPos stackNeg:(NSMutableDictionary *)stackNeg;
@end
