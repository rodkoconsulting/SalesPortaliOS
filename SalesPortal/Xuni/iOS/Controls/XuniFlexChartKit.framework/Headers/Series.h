//
//  Series.h
//  XuniChartCore
//
//  Copyright (c) GrapeCity, Inc. All rights reserved.
//

@class FlexChart;
@class XuniHitTestInfo;
@class XuniRenderEngine;
@class XuniAxis;
@class XuniCollectionView;

/**
 *  Data series interface.
 */
@protocol IXuniSeries

/**
*  Gets or sets the chart type of this data series.
*/
@property (nonatomic) XuniChartType chartType;

/**
 *  Gets or sets the fill color for plot elements.
 */
@property (nonatomic) UIColor *color;

/**
 *  Gets or sets the border color for plot elements.
 */
@property (nonatomic) UIColor *borderColor;

/**
 *  Gets or sets the border width for plot elements.
 */
@property (nonatomic) double borderWidth;

/**
 *  Gets or sets the opacity value applied to plot elements.
 */
@property (nonatomic) double opacity;

/**
 *  Gets or sets the fill color for symbols.
 */
@property (nonatomic) UIColor *symbolColor;

/**
 *  Gets or sets the border color for symbols.
 */
@property (nonatomic) UIColor *symbolBorderColor;

/**
 *  Gets or sets the border width for symbols.
 */
@property (nonatomic) double symbolBorderWidth;

/**
 *  Gets or sets the opacity value applied to symbols.
 */
@property (nonatomic) double symbolOpacity;

/**
 *  Gets or sets the symbol marker.
 */
@property (nonatomic) XuniMarkerType symbolMarker;

/**
 *  Gets or sets the symbol size.
 */
@property (nonatomic) double symbolSize;

/**
 *  Gets or sets the animation time of series.
 */
@property (nonatomic) double animationTime;

/**
 *  Gets or sets the animation duration of series.
 */
@property (nonatomic) double animationDuration;

/**
 *  Gets or sets the item's row number in the chart legend.
 */
@property (nonatomic) int itemRowNum;

/**
 *  Gets or sets the item's column number in the chart legend.
 */
@property (nonatomic) int itemColumnNum;

/**
 *  Get values.
 *
 *  @param dim use for distinguishing data type.
 *
 *  @return return values.
 */
- (NSArray*)getValues:(int)dim;

/**
 *  Get the type of the data.
 *
 *  @param dim use for distinguishing data type.
 *
 *  @return return the type of the data.
 */
- (XuniDataType)getDataType:(int)dim;

/**
 *  Draw legend items.
 *
 *  @param engine the engine.
 *  @param rect   the rect of the legend.
 */
- (void)drawLegendItem:(XuniRenderEngine*)engine inRect:(XuniRect*)rect;

/**
 *  Measure legend item.
 *
 *  @param engine the engine.
 *
 *  @return return the size of the legend item.
 */
- (XuniSize*)measureLegendItem:(XuniRenderEngine*)engine;

@end

/**
 *  Represents a series in the chart.
 */
@interface XuniSeries : NSObject<IXuniSeries>

/**
*  The chart control that owns this series.
*/
@property (nonatomic) FlexChart *chart;

/**
 *  binding Axis x to the series.
 */
@property (nonatomic) XuniAxis *axisX;

/**
 *  binding Axis Y to the series.
 */
@property (nonatomic) XuniAxis *axisY;

/**
 *  Gets or sets axisXname.
 */
@property (nonatomic) NSString *axisXname;

/**
 *  Gets or sets axisYname.
 */
@property (nonatomic) NSString *axisYname;

/**
 *  Gets or sets the chart type of this data series.
 */
@property (nonatomic) XuniChartType chartType;

/**
 *  Gets or sets the series name to be displayed in the chart legend. Series without names do not appear in the legend.
 */
@property (nonatomic) NSString *name;

/**
 *  Gets or sets the name of the bound property to be plotted on the Y axis.
 */
@property (nonatomic) NSString *binding;

/**
 *  Gets or sets the name of the bound property to be plotted on the X axis.
 */
@property (nonatomic) NSString *bindingX;

/**
 *  Gets or sets the data source for this series.
 */
@property (nonatomic) NSMutableArray *itemsSource;

/**
 *  Gets the XuniCollectionView that contains the series data.
 */
@property (nonatomic) XuniCollectionView *collectionView;

/**
 *  Gets or sets the series visibility.
 */
@property (nonatomic) XuniSeriesVisibility visibility;

/**
 *  Gets or sets the fill color for plot elements.
 */
@property (nonatomic) UIColor *color;

/**
 *  Gets or sets the border color for plot elements.
 */
@property (nonatomic) UIColor *borderColor;

/**
 *  Gets or sets the border width for plot elements.
 */
@property (nonatomic) double borderWidth;

/**
 *  Gets or sets the opacity value applied to plot elements.
 */
@property (nonatomic) double opacity;

/**
 *  Gets or sets the fill color for symbols.
 */
@property (nonatomic) UIColor *symbolColor;

/**
 *  Gets or sets the border color for symbols.
 */
@property (nonatomic) UIColor *symbolBorderColor;

/**
 *  Gets or sets the border width for symbols.
 */
@property (nonatomic) double symbolBorderWidth;

/**
 *  Gets or sets the opacity value applied to symbols.
 */
@property (nonatomic) double symbolOpacity;

/**
 *  Gets or sets the symbol marker.
 */
@property (nonatomic) XuniMarkerType symbolMarker;

/**
 *  Gets or sets the symbol size.
 */
@property (nonatomic) double symbolSize;

/**
 *  Gets or sets the the values of series.
 */
@property (nonatomic, readonly) NSArray* values;

/**
 *  Gets or sets the the X values of series.
 */
@property (nonatomic, readonly) NSArray* xvalues;

/**
 *  Gets or sets the animation time of series.
 */
@property (nonatomic) double animationTime;

/**
 *  Gets or sets the animation duration of series.
 */
@property (nonatomic) double animationDuration;

/**
 *  Gets or sets the item's row number in the chart legend.
 */
@property (nonatomic) int itemRowNum;

/**
 *  Gets or sets the item's column number in the chart legend.
 */
@property (nonatomic) int itemColumnNum;

// Internal methods

/**
 *  Initialize an object for series.
 *
 *  @return an object of series.
 */
-(instancetype)init;
/**
 *  Initialize an object for series.
 *
 *  @param chart   the chart.
 *  @param binding the key for values.
 *  @param name    the key for values.
 *
 *  @return return an object of series.
 */
- (id)initForChart:(FlexChart *)chart binding:(NSString *)binding name:(NSString *)name;

/**
 *  Gets the info after hit the area.
 *
 *  @param point the point in control coordinates that this HitTestInfo refers to.
 *
 *  @return return the info after hit the area.
 */
- (XuniHitTestInfo*)hitTest:(XuniPoint*)point;

/**
 *  Gets the info after hit the area.
 *
 *  @param x x value of a point.
 *  @param y y value of a point.
 *
 *  @return return the info after hit the area.
 */
- (XuniHitTestInfo*)hitTest:(double)x y:(double)y;

/**
 *  Clear some values.
 */
- (void)clearValues;

/**
 *  Get the corresponding item.
 *
 *  @param pointIndex the index of the item.
 *
 *  @return the corresponding item.
 */
- (id)getItem:(NSInteger)pointIndex;

/**
 *  Get binging values.
 *
 *  @param index the index of object in binging array.
 *
 *  @return return binging values.
 */
- (NSArray*)getBindingValues:(NSInteger)index;

/**
 *  Get binging values.
 *
 *  @param index the index of object in binging array.
 *
 *  @return return binging values.
 */
- (NSString*)getBinding:(NSInteger)index;

/**
 *  Get the count of itemSource.
 *
 *  @return return the count of itemSource.
 */
- (NSInteger)getLength;

@end
