//
//  Axis.h
//  FlexChart
//
//  Copyright (c) GrapeCity, Inc. All rights reserved.
//

#import "FlexChartEnums.h"

#ifndef XUNI_INTERNAL_DYNAMIC_BUILD

#ifndef XuniChartCoreKit_h
#import "XuniChartCore/FlexChartBaseEnums.h"
#import "XuniCore/CollectionView.h"
#endif

#else
#import "XuniCoreDynamicKit/XuniCoreDynamicKit.h"
#import "XuniChartCoreDynamicKit/XuniChartCoreDynamicKit.h"
#endif

#import "LabelLoadingEventArgs.h"

@class XuniRenderEngine;
@class FlexChart;
@class XuniLabelLoadingEventArgs;
@class XuniSize;
@class XuniRect;

/**
 *  IXuniAxis protocol.
 */
@protocol IXuniAxis

/**
 *  Gets the actual axis data minimum value.
 */
@property (readonly) double actualDataMin;

/**
 *  Gets the actual axis data maximum value.
 */
@property (readonly) double actualDataMax;

/**
*  Gets the actual axis minimum value.
*/
@property (readonly) double actualMin;

/**
 *  Gets the actual axis maximum value.
 */
@property (readonly) double actualMax;

/**
 *  Converts a value from data to pixel coordinates.
 *
 *  @param val Value in data coordinates.
 *
 *  @return Value in pixel coordinates.
 */
- (double)convert:(double)val;

/**
 *  Converts value from data to pixel coordinate by specified max value.
 *
 *  @param val Value in data coordinates.
 *  @param specifiedMax specified max value.
 *
 *  @return the converted value from data to pixel coordinate.
 */
- (double)convert:(double)val specifiedMax:(double)specifiedMax;

/**
 *  Converts value from data to pixel coordinate by specified max & min values.
 *
 *  @param val          Value in data coordinates.
 *  @param specifiedMax specified max value.
 *  @param specifiedMin specified min value.
 *
 *  @return the converted value from data to pixel coordinate.
 */
- (double)convert:(double)val specifiedMax:(double)specifiedMax specifiedMin:(double)specifiedMin;

@end

/**
 *  Represents an axis in the chart.
 */
@interface XuniAxis : NSObject<IXuniAxis>

/**
 *  Gets or sets the chart of the axis.
 */
@property (nonatomic)FlexChart *chart;

/**
 *  Gets or sets axis origin.
 */
@property (nonatomic)double origin;

/**
 *  Gets or sets axis offset after setting the origin.
 */
@property (nonatomic)double offset;

/**
 *  @exclude.
 */
@property (nonatomic)NSString *axisName;

/**
 *  Gets or sets the position of the axis relative to the plot area.
 */
@property (nonatomic) XuniPosition position;

/**
 *  Gets or sets the axis title.
 */
@property (nonatomic) NSString *title;

/**
 *  Gets or sets the annotation format.
 */
@property (nonatomic) NSString *format;

/**
 *  Gets or sets the angle at which axis labels are drawn.
 */
@property (nonatomic) double labelAngle;

/**
 *  Gets or sets the font of the axis labels.
 */
@property (nonatomic) UIFont *labelFont;

/**
 *  Gets or sets the text color of the axis labels.
 */
@property (nonatomic) UIColor *labelTextColor;

/**
 *  Gets or sets the font of the axis title.
 */
@property (nonatomic) UIFont *titleFont;

/**
 *  Gets or sets the text color of the axis title.
 */
@property (nonatomic) UIColor *titleTextColor;

/**
 *  Gets or sets the color of the axis line.
 */
@property (nonatomic) UIColor *lineColor;

/**
 *  Gets or sets the width of the axis line.
 */
@property (nonatomic) double lineWidth;

/**
 *  Gets or sets the color of the major grid lines.
 */
@property (nonatomic) UIColor *majorGridColor;

/**
 *  Gets or sets the fill color of the major grid.
 */
@property (nonatomic) UIColor *majorGridFill;

/**
 *  Gets or sets the width of the major grid lines.
 */
@property (nonatomic) double majorGridWidth;

/**
 *  Gets or sets the color of the major tick marks.
 */
@property (nonatomic) UIColor *majorTickColor;

/**
 *  Gets or sets the width of the major tick marks.
 */
@property (nonatomic) double majorTickWidth;

/**
 *  Gets or sets the length of the major tick marks.
 */
@property (nonatomic) double majorTickLength;

/**
 *  Gets or sets the color of the minor grid lines.
 */
@property (nonatomic) UIColor *minorGridColor;

/**
 *  Gets or sets the fill color of the minor grid.
 */
@property (nonatomic) UIColor *minorGridFill;

/**
 *  Gets or sets the width of the minor grid lines.
 */
@property (nonatomic) double minorGridWidth;

/**
 *  Gets or sets the color of the minor tick marks.
 */
@property (nonatomic) UIColor *minorTickColor;

/**
 *  Gets or sets the width of the minor tick marks.
 */
@property (nonatomic) double minorTickWidth;

/**
 *  Gets or sets the length of the minor tick marks.
 */
@property (nonatomic) double minorTickLength;

/**
 *  Gets the actual axis minimum value.
 */
@property (readonly) double actualMin;

/**
 *  Gets the actual axis maximum value.
 */
@property (readonly) double actualMax;

/**
 *  Gets or sets the desired axis minimum value.
 */
@property (nonatomic) NSObject *min;

/**
 *  Gets or sets the dash pattern for grid.
 */
@property (nonatomic) NSArray<NSNumber*> *majorGridDashes;

/**
 *  Gets or sets the dash pattern for grid.
 */
@property (nonatomic) NSArray<NSNumber*> *minorGridDashes;

/**
 *  Gets or sets the desired axis maximum value.
 */
@property (nonatomic) NSObject *max;

/**
 *  Gets the axis type (X or Y).
 */
@property (readonly) XuniAxisType axisType;

/**
 *  Gets whether the axis contains time values.
 */
@property (nonatomic) BOOL isTimeAxis;

/**
 *  Gets axis's time values of data index.
 */
@property (nonatomic) NSArray *dataIndexTimeVals;

/**
 *  Gets or sets whether the axis line is visible.
 */
@property (nonatomic) BOOL axisLineVisible;

/**
 *  Gets or sets whether the axis labels are visible.
 */
@property (nonatomic) BOOL labelsVisible;

/**
 *  Gets or sets whether the axis should include major grid lines.
 */
@property (nonatomic) BOOL majorGridVisible;

/**
 *  Gets or sets the major tick mark overlap with the axis.
 */
@property (nonatomic) double majorTickOverlap;

/**
 *  Gets or sets the distance between axis major tick marks.
 */
@property (nonatomic) double majorUnit;

/**
 *  Gets or sets whether the axis should include minor grid lines.
 */
@property (nonatomic) BOOL minorGridVisible;

/**
 *  Gets or sets the minor tick mark overlap with the axis.
 */
@property (nonatomic) double minorTickOverlap;

/**
 *  Gets or sets the distance between axis minor tick marks.
 */
@property (nonatomic) double minorUnit;

/**
 *  Gets or sets whether the axis is reversed.
 */
@property BOOL reversed;

/**
 *  Gets or sets the absolute range of values displayed in the view.
 */
@property (nonatomic) double displayedRange;

/**
 *  Gets or sets the logarithmical base of the axis.
 */
@property (nonatomic) NSNumber* logBase;

/**
 *  Gets or sets the relative range of values displayed in the view.
 */
@property (nonatomic) double scale;

/**
 *  Gets or sets the relative scroll position of the axis.
 */
@property (nonatomic) double scrollPosition;

// Internal properties
/**
 *  Gets or sets the size.
 */
@property (readonly) XuniSize *annoSize;

/**
 *  Gets or sets the proportional relation for pinch gestures.
 */
@property CGFloat gestureProportion;

/**
 *  Gets or sets the size desired.
 */
@property XuniSize *desiredSize;

/**
 *  Gets or sets the ax rect.
 */
@property (readonly) XuniRect *axrect;

/**
 *  Gets or sets whether the axis is overlapping labels.
 */
@property (nonatomic)XuniChartOverlappingLabels overlappingLabels;

/**
 *  Gets or sets the labelLoading event.
 */
@property (nonatomic) XuniEvent<XuniLabelLoadingEventArgs*> *labelLoading;

/**
 *  Gets or sets whether handle XF axis label loading event.
 */
@property (nonatomic) BOOL isHandleXFAxisLabelLoading;

// Internal methods for scrolling
/**
 *  Gets a boolean type value.
 *
 *  @return a boolean type value.
 */

/**
 *  Gets or sets whether the axis should above the series.
 */
@property (nonatomic) BOOL above;

/**
 *  Gets or sets whether the grid line is exsit.
 */
@property (nonatomic) BOOL gridLineIsExsit;

/**
*  Gets a boolean type value.
*
*  @return a boolean type value.
*/
- (BOOL)hasMore;

/**
 *  Gets a boolean type value.
 *
 *  @return a boolean type value.
 */
- (BOOL)hasLess;

/**
 *  Gets a boolean type value.
 *
 *  @return a boolean type value.
 */
- (void)showMore;

/**
 *  Gets a boolean type value.
 *
 *  @return a boolean type value.
 */
- (void)showLess;


/**
 *  Scrolls the axis to the particular data value
 *
 *  @param dataValue the value to scroll to
 *  @param position the position of relative data positioning
 */
- (void)scrollTo:(double)dataValue position:(XuniAxisScrollPosition)position;

// Internal methods
/**
 *  Initialize an instance for Axis.
 *
 *  @return an instance for Axis.
 */
-(instancetype)init;
/**
 *  Initialize an instance for Axis.
 *
 *  @param position the postion of axis.
 *  @param chart    the chart.
 *
 *  @return an instance of Axis.
 */
- (id)initWithPosition:(XuniPosition)position forChart:(FlexChart*)chart;

/**
 *  Gets axis height.
 *
 *  @param engine the engine.
 *
 *  @return the axis height.
 */
- (double)getHeight:(XuniRenderEngine*)engine;

/**
 *  Update actual axis limits based on specified data range.
 *
 *  @param dataType the data type.
 *  @param dataMin  the minimun data.
 *  @param dataMax  the maximun data.
 *  @param labels   the labels of axis.
 *  @param values   the values of axis.
 */
- (void)updateActualLimits:(XuniDataType)dataType dataMin:(double)dataMin dataMax:(double)dataMax labels:(NSArray*)labels values:(NSArray*)values;

/**
 *  Update actual axis limits based on specified data range.
 *
 *  @param dataType the data type.
 *  @param dataMin  the minimun data.
 *  @param dataMax  the maximun data.
 */
- (void)updateActualLimits:(XuniDataType)dataType dataMin:(double)dataMin dataMax:(double)dataMax;

/**
 *  Layout axis.
 *
 *  @param axisRect the rect of axis.
 *  @param plotRect the plot rect of axis.
 */
- (void)layout:(XuniRect*)axisRect plotRect:(XuniRect*)plotRect;

/**
 *  Render the axis.
 *
 *  @param engine the engine.
 *  @param overlap the type of overlap for the label.
 */
- (void)render:(XuniRenderEngine*)engine isOverlap:(XuniChartOverlappingLabels)overlap;

/**
 *  Gets the converted value from data to pixel coordinate.
 *
 *  @param val value.
 *
 *  @return the converted value from data to pixel coordinate.
 */
- (double)convert:(double)val;

/**
 *  Gets the converted value from pixel to data coordinate.
 *
 *  @param val value.
 *
 *  @return the converted value from pixel to data coordinate.
 */
- (double)convertBack:(double)val;

/**
 *  Get the formatted value string.
 *
 *  @param val val
 *
 *  @return the formatted value string.
 */
- (NSString*)formatValue:(double)val;

/**
 *  Occurs on axis data range change (scroll, zoom or programmatic change)
 */
@property XuniEvent<XuniEventArgs*> *rangeChanged;


/**
 *  Creates event args and calls rangeChanged.
 */
- (void) raiseRangeChanged;

/**
 *  Refresh ScrollDataValue.
 *
 *  @param scrollPosition the scrollPosition value use for caculating the ScrollDataValue.
 */
- (void)refreshScrollDataValue:(double)scrollPosition;
@end
