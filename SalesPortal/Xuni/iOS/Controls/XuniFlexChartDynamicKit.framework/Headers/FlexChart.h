//
//  FlexChart.h
//  FlexChart
//
//  Copyright (c) GrapeCity, Inc. All rights reserved.
//

#ifndef FlexChartKit_h

#import "Axis.h"
#import "FlexChartEnums.h"
#import "ChartOptions.h"
#import "ChartDataLabel.h"
#import "ChartDataPoint.h"
#import "FlexChartDataLabelRenderer.h"
#import "ChartHitTestInfo.h"
#import "ChartPlotElementEventArgs.h"

#endif


#ifndef XUNI_INTERNAL_DYNAMIC_BUILD

#ifndef XuniChartCoreKit_h
#import "XuniChartCore/FlexChartBase.h"
#import "XuniChartCore/ChartLoadAnimation.h"
#import "XuniChartCore/ChartTooltip.h"
#import <CoreText/CoreText.h>
#endif

#else
#import "XuniCoreDynamicKit/XuniCoreDynamicKit.h"
#import "XuniChartCoreDynamicKit/XuniChartCoreDynamicKit.h"
#endif

@protocol IXuniValueFormatter;
@protocol IXuniEaseAction;
@class XuniCollectionView;
@class XuniRenderEngine;
@class XuniLegend;
@class XuniSeries;
@class XuniBaseChartTooltipView;
@class XuniBaseTooltipView;
@class XuniAnimation;
@class XuniChartLoadAnimation;
@class FlexChartOptions;
@class FlexChartDataLabel;
@class FlexChartDataLabelRenderer;
@class XuniChartLineMarker;
@class XuniChartPlotElementEventArgs;
@class XuniChartAnnotation;

/**
 *  The FlexChart control provides a powerful and flexible way to visualize data.
 */
IB_DESIGNABLE
@interface FlexChart : FlexChartBase<UIGestureRecognizerDelegate>

/**
 *  The bounds of the plot area.
 */
@property (readonly) XuniRect *plotRect;

/**
 *  Data Label for the FlexChart
 */
@property (nonatomic) FlexChartDataLabel *dataLabel;

/**
 *  Data Label for the FlexChart
 */
@property (nonatomic) FlexChartDataLabelRenderer *dataLabelRenderer;

/**
 *  Gets or sets the line marker for the FlexChart.
 */
@property (nonatomic) XuniChartLineMarker *lineMarker;

/**
 *  Gets the array of data series collections.
 */
@property (readonly) XuniObservableArray<XuniSeries*> *series;

/**
 *  Gets or sets the array of annotations.
 */
@property (nonatomic) XuniObservableArray<XuniChartAnnotation*> *annotations;

/**
 *  Gets the array of Axes collection.
 */
@property (nonatomic) NSMutableArray<XuniAxis*> *axesArray;

/**
 *  Gets the main horizontal (X) axis.
 */
@property (readonly) XuniAxis *axisX;

/**
 *  Gets the main vertical (Y) axis.
 */
@property (readonly) XuniAxis *axisY;

/**
 *  Gets or sets whether series should be stacked or plotted independently.
 */
@property (nonatomic) XuniStacking stacking;

/**
 *  Gets or sets the size of the symbols used to render this chart.
 */
@property (nonatomic) double symbolSize;

/**
 *  Gets or sets whether to interpolate null data values.
 *  If true, the chart will interpolate the value of any missing data
 *  based on neighboring points. If false, it will leave a break in lines
 *  and areas at the points with null values.
 */
@property (nonatomic) IBInspectable BOOL interpolateNulls;

/**
 *  Gets whether the chart is rotated.
 */
@property (readonly) BOOL isReallyRotated;

/**
 *  Gets or sets whether the direction of plotting is inverted.
 *  If false (the default), the direction of plotting is horizontal. If true,
 *  the direction of plotting is vertical and the axes are swapped.
 */
@property (nonatomic) IBInspectable BOOL rotated;

/**
 *  Gets or sets whether animation is enabled for the chart.
 */
@property (nonatomic) IBInspectable BOOL isAnimated;

/**
 *  Gets or sets the animation that occurs when the chart is first displayed.
 */
@property (nonatomic) XuniChartLoadAnimation *loadAnimation;

/**
 *  Gets or sets the animation that occurs when a data point
 *  changes or a series is removed or hidden.
 */
@property (nonatomic) XuniAnimation *updateAnimation;


/**
 *  Gets or sets the maximum number of items to be plotted in
 *  the X axis. If the total number of items is greater than this value,
 *  then the user must swipe to view the remaining items.
 */
@property (nonatomic) IBInspectable NSUInteger maxItemsVisible;

/**
 *  Gets or sets the axis scrolling behavior.
 */
@property (nonatomic) XuniZoomMode zoomMode;

/**
 *  Gets or sets the axis scrolling behavior.
 */
@property (nonatomic) FlexChartOptions *options;

// Internal properties
/**
 *  Gets the labels array of axis X.
 */
@property (readonly) NSArray *xlabels;

/**
 *  Gets the vals of axis X.
 */
@property (readonly) NSArray *xvals;

/**
 *  Gets the xDataType.
 */
@property (readonly) XuniDataType xDataType;

/**
 *  Gets the plotterChart.
 */
@property (readonly) XuniRect* plotterChart;

/**
 *  Gets or sets the value format.
 */
@property (nonatomic) NSObject<IXuniValueFormatter> *valueFormatter;

/**
 *  Gets or sets the custom plot element.
 */
@property (nonatomic) UIView *customPlotElement;

/**
 *  Gets or sets whether begin plot element loading event.
 */
@property (nonatomic) BOOL beginPlotElementLoading;

/**
 *  Gets or sets whether handle XF plot element loading event.
 */
@property (nonatomic) BOOL isHandleXFPlotElementLoading;

// Internal properties for update animation
/**
 *  Gets or sets the active updateAnimation.
 */
@property (nonatomic) XuniAnimation *activeUpdateAnimation;

/**
 *  Gets or sets whether is isUpdateTask1.
 */
@property (nonatomic) BOOL isUpdateTask1;

/**
 *  Gets or sets whether is updateTask2.
 */
@property (nonatomic) BOOL isUpdateTask2;

/**
 *  Gets or sets whether is seriesCollection updated.
 */
@property (nonatomic) BOOL isSeriesCollectionUpdated;

/**
 *  Gets or sets whether is collectionView updated.
 */
@property (nonatomic) BOOL isCollectionViewUpdated;

/**
 *  Gets or sets the update event arguments.
 */
@property (nonatomic) XuniNotifyCollectionChangedEventArgs *updateEventArgs;

/**
 *  Gets or sets the previous axis Y maximum value.
 */
@property (nonatomic) double prevAxisYMax;

/**
 *  Gets or sets the previous axis Y minimum value.
 */
@property (nonatomic) double prevAxisYMin;

/**
 *  Gets or sets the previous axis X maximum value.
 */
@property (nonatomic) double prevAxisXMax;

/**
 *  Gets or sets the previous axis X minimum value.
 */
@property (nonatomic) double prevAxisXMin;

/**
 *  Gets or sets the previous X values array.
 */
@property (nonatomic) NSMutableArray *prevXValsArray;

/**
 *  Gets or sets the previous Y values array.
 */
@property (nonatomic) NSMutableArray *prevYValsArray;

/**
 *  @exclude.
 */
@property (nonatomic) NSMutableDictionary *stackAbs;

/**
 *  Gets whether chart is in update animation.
 */
@property (readonly) BOOL isChartUpdate;

/**
 *  Gets or sets the plotElementLoading event.
 */
@property (nonatomic) XuniEvent<XuniChartPlotElementEventArgs*> *plotElementLoading;

/**
 *  Raised the plotElementLoading event before the plot Element is loading.
 *
 *  @param args the event arguments.
 */
- (void)onPlotElementLoading:(XuniChartPlotElementEventArgs *)args;

/**
 *  Converts a point from control coordinates to chart data coordinates.
 *
 *  @param point Point in control coordinates.
 *
 *  @return Point in chart data coordinates.
 */
- (XuniPoint*)pointToData:(XuniPoint*)point;

/**
 *  Converts a point from chart data coordinates to control coordinates.
 *
 *  @param point  Point in chart data coordinates.
 *
 *  @return Point in control coordinates.
 */
- (XuniPoint*)dataToPoint:(XuniPoint*)point;

/**
 *  Gets a HitTestInfo object with information about a given point.
 *
 *  @param point Point to investigate, in screen coordinates.
 *
 *  @return XuniChartHitTestInfo object with information about the point.
 */
- (XuniChartHitTestInfo *)hitTest:(XuniPoint *)point;

// Internal methods
/**
 *  Get ease type.
 *
 *  @return a ease type.
 */
- (id<IXuniEaseAction> )getEasing;

/**
 *  Get a descriptor of font.
 *
 *  @param attributes the font attributes.
 *
 *  @return a descriptor.
 */
- (UIFontDescriptor*)getDescriptor:(NSMutableDictionary*)attributes;

/**
 *  Judge whether the series is selected.
 *
 *  @param series  the series.
 *
 *  @return return a boolean value.
 */
- (BOOL)isSeriesSelected:(XuniSeries*)series;

/**
*  Get an array of data points around coordinate x/y.
*
*  @param x the x coordinate.
*  @param y the y coordinate.
*
*  @return return an array of data points.
*/
- (NSArray *)getDataPointsAroundPoint:(double)x y:(double)y;

/**
 *  Get the value.
 *
 *  @param index      the index of series.
 *  @param formatted  whether is formatted.
 *  @param pointIndex the pointIndex of series.
 *  @param series     the series.
 *
 *  @return return the value.
 */
- (id)getHitTestInfoValue:(int)index formatted:(BOOL)formatted pointIndex:(int)pointIndex series:(XuniSeries*)series;

/**
 *  Get the chart element info at specified point.
 *
 *  @param point       Point in chart data coordinates.
 *  @param seriesIndex the index of series.
 *
 *  @return the chart element info at specified point.
 */
- (XuniChartHitTestInfo *)hitTestSeries:(XuniPoint *)point seriesIndex:(int)seriesIndex;

/**
 *  Get the interpolated value based on neighboring values.
 *
 *  @param arrvalues Array of values.
 *  @param index     The index.
 *  @param count     The count.
 *
 *  @return The interpolated value.
 */
- (double)getInterpolatedValue:(NSArray *)arrvalues index:(int)index count:(int)count;

/**
 *  Judge if all series are hidden.
 *
 *  @return return a boolean value.
 */
- (BOOL)isAllSeriesHidden;

@end
