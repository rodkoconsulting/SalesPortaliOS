//
//  FlexChartBase.h
//  XuniChartCore
//
//  Copyright (c) GrapeCity, Inc. All rights reserved.
//

#import "FlexChartBaseEnums.h"

#ifndef XUNI_INTERNAL_DYNAMIC_BUILD
#ifndef XuniCoreKit_h
#import "XuniCore/CollectionView.h"
#import "XuniCore/Drawing.h"
#import "XuniCore/XuniView.h"
#endif
#else
#import "XuniCoreDynamicKit/XuniCoreDynamicKit.h"
#endif

@class XuniObservableArray;
@class XuniHitTestInfo;
@class XuniSeries;
@class XuniRenderEngine;
@class XuniLegend;
@class XuniAxis;
@class XuniChartTooltip;
@class XuniLabelLoadingEventArgs;
@class FlexChartBase;
@class BasePlotElementRender;

/**
 *  Represents a chart palette.
 */
@protocol IXuniPalette

/**
 *  Gets a color from the palette by index.
 *
 *  @param i Index of color in palette.
 *
 *  @return UIColor value for the given index.
 */
- (UIColor*)getColor:(NSUInteger)i;

/**
 *  Gets a color from the palette by index.
 *
 *  @param i Index of color in palette.
 *  @param opacity Opacity of color.
 *
 *  @return UIColor value for the given index and opacity.
 */
- (UIColor*)getColor:(NSUInteger)i opacity:(double)opacity;

/**
 *  Gets a lighter color from the palette by index.
 *
 *  @param i Index of color in palette.
 *
 *  @return UIColor value for the given index.
 */
- (UIColor*)getColorLight:(NSUInteger)i;

/**
 *  Gets a darker color from the palette by index.
 *
 *  @param i Index of color in palette.
 *
 *  @return UIColor value for the given index.
 */
- (UIColor*)getColorDark:(NSUInteger)i;

/**
 *  Gets a lighter version of the specified color.
 *
 *  @param color Specified UIColor value.
 *
 *  @return Lighter UIColor value.
 */
- (UIColor*)lighten:(UIColor*)color;

/**
 *  Gets a lighter version of the specified color.
 *
 *  @param color Specified UIColor value.
 *  @param opacity Opacity of color.
 *
 *  @return Lighter UIColor value.
 */
- (UIColor*)lighten:(UIColor*)color opacity:(double)opacity;

/**
 *  Gets a darker version of the specified color.
 *
 *  @param color Specified UIColor value.
 *
 *  @return Darker UIColor value.
 */
- (UIColor*)darken:(UIColor*)color;

@end

/**
 *  protocol FlexChartDelegate.
 */
@protocol FlexChartDelegate <XuniViewDelegate>
@optional

/**
 *  Do something when selection changed.
 *
 *  @param sender the chart sending this event.
 *  @param hitTestInfo the info of the chart element at the specified point.
 */
- (void)selectionChanged:(FlexChartBase*)sender hitTestInfo:(XuniHitTestInfo*)hitTestInfo;

/**
 *  Do something when series visibility changed.
 *
 *  @param sender the chart sending this event.
 *  @param series the chart series at the specified coordinates.
 */
- (void)seriesVisibilityChanged:(FlexChartBase*)sender series:(XuniSeries*)series;

/**
 *  Get whether an axis range is changed
 *
 *  @param sender the chart sending this event.
 *  @param axis whose range is changed
 *
 */
- (void)axisRangeChanged:(FlexChartBase*)sender axis:(XuniAxis *)axis;

/**
 *  Handle customized tooltip.
 *
 *  @param sender the chart sending this event.
 *  @param point     the tapped point.
 *  @param isVisible the tooltip visibility.
 *  @param data      the tooltip data.
 *
 */
- (void)handleTooltip:(FlexChartBase*)sender point:(XuniPoint*)point isVisible:(BOOL)isVisible data:(NSArray*)data;

/**
 *  handle plot element loading event.
 *
 *  @param sender the chart sending this event.
 *  @param renderEngine the render engine.
 *  @param rect the element rect.
 *  @param point the point.
 *  @param seriesIndex the series index.
 *  @param pointIndex the point index.
 *  @param defaultRender the default render
 *
 *  @return return a boolean value.
 */
- (BOOL)handlePlotElementLoading:(FlexChartBase*)sender renderEngine:(XuniRenderEngine *)renderEngine rect:(XuniRect*)rect pointIndex:(int)pointIndex point:(XuniPoint*)point seriesIndex:(int)seriesIndex defaultRender:(BasePlotElementRender *)defaultRender;

/**
 *  Handle axis label loading event.
 *
 *  @param sender the chart sending this event.
 *  @param renderEngine  the render engine.
 *  @param axisIndex     the axis index.
 *  @param eventArgs     the event arguments.
 *
 *  @return return a boolean value.
 */
- (BOOL)handleLabelLoading:(FlexChartBase*)sender renderEngine:(XuniRenderEngine *)renderEngine axisIndex:(int)axisIndex eventArgs:(XuniLabelLoadingEventArgs*)eventArgs;

/**
 *  Do something when line Marker position changed.
 *
 *  @param sender flexChart sender object.
 */
- (void)lineMarkerPositionChanged:(FlexChartBase*)sender;

@end

/**
 *  The base control from which FlexChart derives.
 */
@interface FlexChartBase : XuniView<IXuniPalette>

/**
 *  Gets or set the tooltip of Chart.
 */
@property (nonatomic) XuniChartTooltip* tooltip;

/**
 *  These properties affect the space between the axis/plot area rectangle vs the outer rectangle made up of the header/footer/legend.
 */
@property (nonatomic) UIEdgeInsets plotMargin;

/**
 *  Gets or sets the padding of the chart.
 */
@property (nonatomic) UIEdgeInsets padding;

/**
 *  Gets the IXuniCollectionView that contains the chart data.
 */
@property (nonatomic) XuniCollectionView *collectionView;

/**
 *  Gets or sets the delegate for handling notifications.
 */
@property (nonatomic, weak) id<FlexChartDelegate> delegate;

/**
 *  Gets or sets whether interaction is enabled for the user.
 */
@property (nonatomic) IBInspectable BOOL isEnabled;

/**
 *  Gets or sets the name of the bound property to be plotted on the Y axis.
 */
@property (nonatomic) IBInspectable NSString *binding;

/**
 *  Gets or sets the name of the bound property to be plotted on the X axis.
 */
@property (nonatomic) IBInspectable NSString *bindingX;

/**
 *  Gets or sets the chart legend object.
 */
@property (nonatomic) XuniLegend *legend;

/**
 *  Gets or sets the chart header.
 */
@property (nonatomic) IBInspectable NSString *header;

/**
 *  Gets or sets the chart footer.
 */
@property (nonatomic) IBInspectable NSString *footer;

/**
 *  Gets or sets the font of the chart header.
 */
@property (nonatomic) UIFont *headerFont;

/**
 *  Gets or sets the text color of the chart header.
 */
@property (nonatomic) IBInspectable UIColor *headerTextColor;

/**
 *  Gets or sets the horizontal alignment of the chart header.
 */
@property (nonatomic) XuniHorizontalAlignment headerTextAlignment;

/**
 *  Gets or sets the font of the chart footer.
 */
@property (nonatomic) UIFont *footerFont;

/**
 *  Gets or sets the text color of the chart footer.
 */
@property (nonatomic) IBInspectable UIColor *footerTextColor;

/**
 *  Gets or sets the horizontal alignment of the chart footer.
 */
@property (nonatomic) XuniHorizontalAlignment footerTextAlignment;

/**
 *  Gets or sets an array with default colors used for displaying each series.
 */
@property (nonatomic) NSArray *palette;

/**
 *  Gets or sets whether clicking legend items should toggle the series visibility.
 */
@property (nonatomic) IBInspectable BOOL legendToggle;

/**
 *  Gets or sets the text color of the chart.
 */
@property (nonatomic) IBInspectable UIColor *textColor;

/**
 *  Gets or sets the background color of the chart.
 */
@property (nonatomic) IBInspectable UIColor *backgroundColor;

/**
 *  Gets or sets the border color of the chart.
 */
@property (nonatomic) IBInspectable UIColor *borderColor;

/**
 *  Gets or sets the border width of the chart.
 */
@property (nonatomic) IBInspectable double borderWidth;

/**
 *  Gets or sets the background color of the plot area.
 */
@property (nonatomic) IBInspectable UIColor *plotAreaBackgroundColor;

/**
 *  Gets or sets the selected border color of the chart.
 */
@property (nonatomic) IBInspectable UIColor *selectedBorderColor;

/**
 *  Gets or sets the selected border width of the chart.
 */
@property (nonatomic) IBInspectable double selectedBorderWidth;

/**
 *  ​Gets or sets the selected border dashes of the chart.
 */
@property (nonatomic) NSArray<NSNumber*>* selectedDashes;

/**
 *  Gets or sets the selection mode of the chart.
 */
@property (nonatomic) XuniSelectionMode selectionMode;

/**
 *  Gets or sets the chart data source for all series.
 */
@property (nonatomic) NSMutableArray *itemsSource;

/**
 *  Gets or sets the chart type of all data series.
 */
@property (nonatomic) XuniChartType chartType;

/**
 *  Gets or sets the chart selection.
 */
@property (nonatomic) XuniSeries *selection;

/**
 *  Gets or sets the index of the chart selection.
 */
@property (nonatomic) int selectionIndex;

/**
 *  Gets the render engine.
 */
@property (readonly) XuniRenderEngine* renderEngine;

/**
 *  Gets the rect of chart.
 */
@property (readonly) XuniRect* rectChart;

/**
 *  Gets the rect of chart header.
 */
@property (readonly) XuniRect* rectHeader;

/**
 *  Gets the rect of chart footer.
 */
@property (readonly) XuniRect* rectFooter;

/**
 *  @exclude.
 */
@property (nonatomic) BOOL isSeriesVisibilityAnimation;

/**
 *  Occurs on chart rendering finished
 */
@property XuniEvent<XuniEventArgs*> *chartRendered;

/**
 *  Creates event args and calls onChartRendered.
 */
- (void) raiseChartRendered;

/**
 *  Occurs before chart rendering starts
 */
@property XuniEvent<XuniEventArgs*> *chartRendering;

/**
 *  Creates event args and calls onChartRendering.
 */
- (void) raiseChartRendering;

/**
 *  Occurs before chart rendering starts
 */
@property XuniEvent<XuniPointEventArgs*> *chartTapped;

/**
 *  Creates event args and calls onChartRendering.
 *
 *  @param point the x/y coordinates the tapped event occured.
 */
- (void) raiseChartTapped: (XuniPoint*) point;


/**
 *  Causes the chart to be redrawn.
 */
- (void)invalidate;

/**
 *  Refresh the chart.
 */
- (void)refresh;

// Internal methods
/**
 *  Initialize some properties of chart.
 */
- (void)initInternals;

/**
  * @abstract Binds the chart to the current data source.
 */
- (void)bindChart;

/**
 *  Clear series.
 */
- (void)clearSeries;

/**
 *  Prepare something for rendering the chart.
 */
- (void)prepareForRender;

/**
 *  Render the chart.
 *
 *  @param engine the engine.
 */
- (void)render:(XuniRenderEngine*)engine;

/**
 *  Convert the point to the control.
 *
 *  @param x x value of the point.
 *  @param y y value of the point.
 *
 *  @return the point of the control.
 */
- (XuniPoint*)toControl:(double)x y:(double)y;

/**
 *  Gets legend size desired
 *
 *  @param engine     an object of XuniRenderEngine.
 *  @param isVertical whether is vertical.
 *
 *  @return legend size desired.
 */
- (XuniSize*)getLegendDesiredSize:(XuniRenderEngine*)engine isVertical:(BOOL)isVertical;

/**
 *  Render the legend.
 *
 *  @param engine     an object of XuniRenderEngine.
 *  @param point      Point in chart data coordinates.
 *  @param isVertical whether is vertical.
 *  @param areas      areas of series.
 */
- (void)renderLegend:(XuniRenderEngine*)engine atPoint:(XuniPoint*)point isVertical:(BOOL)isVertical areas:(NSMutableArray*)areas;

/**
 *  Draw the title of the footer or header.
 *
 *  @param engine   the engine.
 *  @param rect     the frame of the footer or header.
 *  @param title    the title of the footer or header.
 *  @param isFooter whether is footer.
 *
 *  @return return a frame.
 */
- (XuniRect*)drawTitle:(XuniRenderEngine*)engine rect:(XuniRect*)rect title:(NSString*)title isFooter:(BOOL)isFooter;

/**
 *  Judge whether the point is in the rect.
 *
 *  @param rect  the frame.
 *  @param point the point in control coordinates that this HitTestInfo refers to.
 *
 *  @return return a boolean value.
 */
+ (BOOL)contains:(XuniRect*)rect point:(XuniPoint*)point;

/**
 *  Render the text.
 *
 *  @param engine the engine.
 *  @param text   the text of items.
 *  @param pos    the position of text.
 *  @param halign the horizontal alignment.
 *  @param valign the vertical alignment.
 *  @param sz     the size of the text.
 */
+ (void)renderText:(XuniRenderEngine*)engine text:(NSString*)text pos:(XuniPoint*)pos halign:(XuniHorizontalAlignment)halign valign:(XuniVerticalAlignment)valign size:(XuniSize *)sz;

/**
 *  Render the text.
 *
 *  @param engine the engine.
 *  @param text   the text of items.
 *  @param pos    the position of text.
 *  @param halign the horizontal alignment.
 *  @param valign the vertical alignment.
 */
+ (void)renderText:(XuniRenderEngine*)engine text:(NSString*)text pos:(XuniPoint*)pos halign:(XuniHorizontalAlignment)halign valign:(XuniVerticalAlignment)valign;

/**
 *   Render the rotated text.
 *
 *  @param engine the engine.
 *  @param text   the text of items.
 *  @param pos    the position of text.
 *  @param halign the horizontal alignment.
 *  @param valign the vertical alignment.
 *  @param center the center of the text.
 *  @param angle  the angle of the text.
 *  @param sz     the size of the text.
 */
+ (void)renderRotatedText:(XuniRenderEngine*)engine text:(NSString*)text pos:(XuniPoint*)pos halign:(XuniHorizontalAlignment)halign valign:(XuniVerticalAlignment)valign center:(XuniPoint*)center angle:(double)angle size:(XuniSize *)sz;

/**
 *   Render the rotated text.
 *
 *  @param engine the engine.
 *  @param text   the text of items.
 *  @param pos    the position of text.
 *  @param halign the horizontal alignment.
 *  @param valign the vertical alignment.
 *  @param center the center of the text.
 *  @param angle  the angle of the text.
 */
+ (void)renderRotatedText:(XuniRenderEngine*)engine text:(NSString*)text pos:(XuniPoint*)pos halign:(XuniHorizontalAlignment)halign valign:(XuniVerticalAlignment)valign center:(XuniPoint*)center angle:(double)angle;

/**
 *  Find axis use axis name.
 *
 *  @param axisName the specified axis name.
 *
 *  @return an axis.
 */
- (XuniAxis *)findAxis:(NSString *)axisName;

@end
