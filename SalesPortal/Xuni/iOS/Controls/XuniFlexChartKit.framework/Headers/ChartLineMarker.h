//
//  ChartLineMarker.h
//  FlexChart
//
//  Copyright (c) GrapeCity, Inc. All rights reserved.
//

#ifndef XuniCoreKit_h
#import "XuniCore/Event.h"
#endif

@class FlexChart;
@class XuniChartMarkerBaseView;
@class XuniPoint;
@class XuniRect;
@class XuniSize;

#import "IChartMarkerRender.h"



#define DRAG_OFFSET 25

/**
 *  Class XuniChartLineMarker.
 */
@interface XuniChartLineMarker : NSObject

/**
 *  Gets or sets the positionChanged event.
 */
@property (nonatomic) XuniEvent<XuniEventArgs*> *positionChanged;

/**
 *  Gets or sets the type of lines.
 */
@property (nonatomic) XuniChartMarkerLines lines;

/**
 *  Gets or sets the type of marker interaction.
 */
@property (nonatomic) XuniChartMarkerInteraction interaction;

/**
 *  Gets or sets the label alignment.
 */
@property (nonatomic) XuniChartMarkerAlignment alignment;

/**
 *  If the Interaction is Drag, this property determines if the user can drag the label.
 */
@property (nonatomic) BOOL dragContent;

/**
 *  Gets or sets whether line marker is visible.
 */
@property (nonatomic) BOOL isVisible;

/**
 *  Gets or sets the horizontal position of the line marker relative to the plot area.
 */
@property (nonatomic) double horizontalPosition;

/**
 *  Gets or sets the vertical position of the line marker relative to the plot area.
 */
@property (nonatomic) double verticalPosition;

/**
 *  Gets the current x-value as chart data coordinates.
 */
@property (readonly) double x;

/**
 *  Gets the current y-value as chart data coordinates.
 */
@property (readonly) double y;

/**
 *  Gets or sets the index of the series in the chart in which the line marker appears.
 */
@property (nonatomic) int seriesIndex;

/**
 *  Gets or sets the content of the marker.
 */
@property (nonatomic) XuniChartMarkerBaseView *content;

/**
 *  Gets or sets the width of the horizontal line.
 */
@property (nonatomic) double horizontalLineWidth;

/**
 *  Gets or sets the color of the horizontal line.
 */
@property (nonatomic) UIColor *horizontalLineColor;

/**
 *  Gets or sets the width of the vertical line.
 */
@property (nonatomic) double verticalLineWidth;

/**
 *  Gets or sets the color of the vertical line.
 */
@property (nonatomic) UIColor *verticalLineColor;

/**
 *  Gets or sets the data points.
 */
@property (nonatomic) NSArray *dataPoints;

/**
 *  @exclude.
 */
@property (readonly) BOOL firstShow;

/**
 *  @exclude.
 */
@property (readonly) BOOL isShowXFContent;

/**
 *  Initialize an object for the XuniChartLineMarker.
 *
 *  @param chart   the chart.
 *
 *  @return an object for the XuniChartLineMarker.
 */
- (id)initWithChart:(FlexChart *)chart;

/**
 *  Show line marker at the specified position.
 *
 *  @param xPos   the x position.
 *  @param yPos   the y position.
 */
- (void)showAt:(double)xPos yPos:(double)yPos;

/**
 *  Hide the line marker.
 */
- (void)hide;

/**
*  Determine the position for the given content.
*
*  @param contentSize the size of the content.
*
*  @return position for content.
*/
- (XuniPoint *)calculateContentPosition:(XuniSize *)contentSize;

@end

/**
*  Default Chart Marker renderer.
*/
@interface XamarinChartMarkerRender : NSObject<IXuniChartMarkerRender>

/**
*  Show the chart marker.
*/
- (void)show;

/**
*  Hide the chart marker.
*/
- (void)hide;

@end
