//
//  ChartTooltip.h
//  XuniChartCore
//
//  Copyright (c) GrapeCity, Inc. All rights reserved.
//


@class XuniBaseChartTooltipView;
@class FlexChartBase;

/**
 *  Class XuniChartTooltip.
 */
@interface XuniChartTooltip : NSObject
{
    FlexChartBase* _chart;
}

/**
 *  Gets or sets the backgroundColor of tooltip.
 */
@property (nonatomic) UIColor* backgroundColor;

/**
 *  Gets or sets the textColor of tooltip.
 */
@property (nonatomic) UIColor* textColor;

/**
 *  Gets or sets the content of tooltip.
 */
@property (nonatomic) XuniBaseChartTooltipView* content;

/**
 *  Gets or sets the gap of tooltip.
 */
@property (nonatomic) double gap;

/**
 *  Gets or sets whether tooltip is visible.
 */
@property (nonatomic) bool isVisible;

/**
 *  Gets or sets the showDelay of tooltip.
 */
@property (nonatomic) long showDelay;

/**
 *  Gets or set the hideDelay of tooltip.
 */
@property (nonatomic) long hideDelay;

/**
 *  Show the tooltip.
 */
- (void)show;

/**
 *  Hide the tooltip.
 */
- (void)hide;

/**
 *  Initialize an object for the XuniChartTooltip.
 *
 *  @param chart   the chart.
 *  @param content the content.
 *
 *  @return an object for the XuniChartTooltip.
 */
-(id)init:(FlexChartBase*)chart content:(XuniBaseChartTooltipView*)content;

@end
