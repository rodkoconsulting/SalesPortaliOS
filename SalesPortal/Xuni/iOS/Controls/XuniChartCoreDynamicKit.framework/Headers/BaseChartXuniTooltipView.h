//
//  BaseChartXuniTooltipView.h
//  XuniChartCore
//
//  Copyright (c) GrapeCity, Inc. All rights reserved.
//

#ifndef XuniCoreKit_h
#import "XuniCore/XuniTooltip.h"
#endif

@class XuniDataPoint;

/**
 *  XuniBaseChartTooltipView.
 */
@interface XuniBaseChartTooltipView : XuniBaseTooltipView

/**
 *  Gets or sets the chart data.
 */
@property(nonatomic) XuniDataPoint* chartData;

@end
