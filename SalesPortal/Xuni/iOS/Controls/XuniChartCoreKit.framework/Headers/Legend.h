//
//  Legend.h
//  XuniChartCore
//
//  Copyright (c) GrapeCity, Inc. All rights reserved.
//

#import "FlexChartBaseEnums.h"

@class FlexChartBase;
@class XuniRenderEngine;

/**
 *  Represents the chart legend.
 */
@interface XuniLegend : NSObject

/**
*  Gets or sets the legend position.
*/
@property (nonatomic,getter=getPosition) XuniChartLegendPosition position;

/**
 *  Gets or sets the background color of the legend.
 */
@property (nonatomic) UIColor *backgroundColor;

/**
 *  Gets or sets the border color of the legend.
 */
@property (nonatomic) UIColor *borderColor;

/**
 *  Gets or sets the border width of the legend.
 */
@property (nonatomic) double borderWidth;

/**
 *  Gets or sets the font of the legend labels.
 */
@property (nonatomic) UIFont *labelFont;

/**
 *  Gets or sets the text color of the legend labels.
 */
@property (nonatomic) UIColor *labelTextColor;

// Internal properties
// removed :

/**
 *  Gets whether the legend is vertical.
 */
@property (readonly) BOOL isVertical;

/**
 *  Gets or sets the orientation of the legend.
 */
@property (nonatomic, getter=getOrientation) XuniChartLegendOrientation orientation;

// Internal methods

/**
 *  Initialize an object for XuniLegend.
 *
 *  @param chart the chart.
 *
 *  @return return an object of XuniLegend.
 */
- (id)initForChart:(FlexChartBase*)chart;

/**
 *  Gets desired size.
 *
 *  @param engine the engine.
 *
 *  @return return the desired size.
 */
- (XuniSize*)getDesiredSize:(XuniRenderEngine*)engine;

/**
 *  Render legend at the point.
 *
 *  @param engine the engine.
 *  @param point  the point.
 */
- (void)render:(XuniRenderEngine*)engine atPoint:(XuniPoint*)point;

/**
 *  Judge which area the point is in.
 *
 *  @param point the point.
 *
 *  @return return the index of the area.
 */
- (int)hitTest:(XuniPoint*)point;

@end
