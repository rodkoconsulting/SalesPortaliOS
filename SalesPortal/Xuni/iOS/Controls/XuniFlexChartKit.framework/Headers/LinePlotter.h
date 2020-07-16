//
//  LinePlotter.h
//  FlexChart
//
//  Copyright (c) GrapeCity, Inc. All rights reserved.
//

#import "IPlotter.h"

@class FlexChart;
@class XuniDataInfo;
@class XuniHitTester;
@class XuniSeries;
@class XuniNotifyCollectionChangedEventArgs;
@class XuniChartDataPoint;

/**
 *  XuniLinePlotter class.
 */
@interface XuniLinePlotter : XuniBasePlotter

/**
 *  gets or sets chart.
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
 *  gets or sets whether the chart is rotated.
 */
@property BOOL hasSymbols;

/**
 *  gets or sets whether the chart has lines.
 */
@property BOOL hasLines;

/**
 *  gets or sets whether the chart is spline.
 */
@property BOOL isSpline;


/**
 *  Initialize an instance for LinePlotter.
 *
 *  @param chart     the chart.
 *  @param dataInfo  the dataInfo.
 *  @param hitTester the chart element at specified point.
 *
 *  @return an instance of LinePlotter.
 */
- (id)init:(FlexChart*)chart dataInfo:(XuniDataInfo*)dataInfo hitTester:(XuniHitTester*)hitTester;

/**
 *  Draw symbols with parameters.
 *
 *  @param engine       the specified engine.
 *  @param x            the specified X value.
 *  @param y            the specified Y value.
 *  @param borderWidth  the specified borderWidth.
 *  @param symbolSize   the specified symbolSize.
 *  @param fillColor    the specified fillColor.
 *  @param borderColor  the specified borderColor.
 *  @param symbolMarker the specified symbolMarker.
 *  @param series       the specified series.
 *  @param index        the specified index.
 *  @param dataPoint    the metadata that makes up this symbol to draw.
 *  @param type The symbol type.
 */
- (void)drawSymbol:(NSObject<IXuniRenderEngine>*)engine x:(double)x y:(double)y borderWidth:(double)borderWidth symbolSize:(double)symbolSize fillColor:(UIColor*)fillColor borderColor:(UIColor*)borderColor symbolMarker:(XuniMarkerType)symbolMarker series:(NSObject<IXuniSeries>*)series pointIndex:(int)index dataPoint:(XuniChartDataPoint*)dataPoint type:(XuniPlotElementLoadingType)type;

/**
 *  Get animation info with parameters..
 *
 *  @param series   the specified series.
 *  @param time     the specified time.
 *  @param duration the specified duration.
 *  @param count    the specified count.
 */
- (void)getAnimationInfo:(NSObject<IXuniSeries>*)series time:(double*)time duration:(double*)duration count:(int*)count;

/**
 *  Get points for point mode.
 *
 *  @param xs       the array of X value.
 *  @param ys       the array of Y value.
 *  @param time     the time.
 *  @param duration the duration.
 *  @param type     the ease type.
 *  @param rotated  whether rotated.
 *
 *  @return a NSDictionary object.
 */
- (NSDictionary*)getPointsForPointMode:(NSArray*)xs Y:(NSArray*)ys time:(double)time duration:(double)duration type:(id<IXuniEaseAction>)type rotated:(BOOL)rotated;

/**
 *  Get updated points dictionary.
 *
 *  @param updateEventArgs   the specified update EventArgs.
 *  @param ax                the specified axis X.
 *  @param ay                the specified axis Y.
 *  @param iser              the specified index.
 *  @param dx                the specified x data.
 *  @param dy                the specified y data.
 *  @param prevVals          the specified previous values.
 *  @param animationTime     the specified animation time.
 *  @param animationDuration the specified animation duration.
 *  @param type              the specified type.
 *  @param rotated           whether rotated.
 *
 *  @return NSDictionary object.
 */
- (NSDictionary*)getUpdatedPointsDictionary:(XuniNotifyCollectionChangedEventArgs*)updateEventArgs axisX:(NSObject<IXuniAxis>*)ax axisY:(NSObject<IXuniAxis>*)ay index:(int)iser dx:(NSArray*)dx dy:(NSArray*)dy prevVals:(NSArray*)prevVals time:(double)animationTime duration:(double)animationDuration type:(id<IXuniEaseAction>)type rotated:(BOOL)rotated;

/**
 *  Get scale for point mode.
 *
 *  @param type          the specified type.
 *  @param time          the specified time.
 *  @param duration      the specified duration.
 *  @param dataInfoIndex the specified index dataInfo.
 *  @param lastDataInfo  whether is last data info.
 *
 *  @return a double value.
 */
- (double)getScaleForPointMode:(id<IXuniEaseAction>)type time:(double)time duration:(double)duration dataInfoIndex:(int)dataInfoIndex lastDataInfo:(BOOL)lastDataInfo;

@end
