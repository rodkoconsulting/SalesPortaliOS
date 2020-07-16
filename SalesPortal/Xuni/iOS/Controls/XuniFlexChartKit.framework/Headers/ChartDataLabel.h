//
//  ChartDataLabel.h
//  FlexChart
//
//  Copyright (c) GrapeCity, Inc. All rights reserved.
//


#ifndef FlexChartKit_h
#import "Axis.h"
#import "FlexChartEnums.h"
#import "ChartOptions.h"
#endif

#ifndef XUNI_INTERNAL_DYNAMIC_BUILD

#ifndef XuniChartCoreKit_h
#import "XuniChartCore/FlexChartBase.h"
#import "XuniChartCore/ChartLoadAnimation.h"
#import "XuniChartCore/BaseDataLabel.h"
#endif

#else
#import "XuniCoreDynamicKit/XuniCoreDynamicKit.h"
#import "XuniChartCoreDynamicKit/XuniChartCoreDynamicKit.h"
#endif

/**
 *  FlexChartDataLabelPosition
 */
typedef NS_ENUM(NSInteger, FlexChartDataLabelPosition){
    /**
     *  FlexChartDataLabelPositionNone
     */
    FlexChartDataLabelPositionNone,
    /**
     *  FlexChartDataLabelPositionLeft
     */
    FlexChartDataLabelPositionLeft,
    /**
     *  FlexChartDataLabelPositionRight
     */
    FlexChartDataLabelPositionRight,
    /**
     *  FlexChartDataLabelPositionTop
     */
    FlexChartDataLabelPositionTop,
    /**
     *  FlexChartDataLabelPositionBottom
     */
    FlexChartDataLabelPositionBottom,
    /**
     *  FlexChartDataLabelPositionCenter
     */
    FlexChartDataLabelPositionCenter
};

/**
 * FlexChartDataLabel.
 */
@interface FlexChartDataLabel : XuniBaseDataLabel

/**
 *  Initialize an object for FlexChartDataLabel.
 *
 *  @param chart the chart.
 *
 *  @return an object for FlexChartDataLabel.
 */
-(id)init:(FlexChart*)chart;

/**
 *  Gets or sets the position of datalabel.
 */
@property(nonatomic) FlexChartDataLabelPosition position;
@end
