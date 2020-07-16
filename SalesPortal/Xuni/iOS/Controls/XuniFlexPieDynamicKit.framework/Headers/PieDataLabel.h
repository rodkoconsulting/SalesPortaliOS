//
//  PieDataLabel.h
//  FlexPie
//
//  Copyright (c) GrapeCity, Inc. All rights reserved.
//


#ifndef XUNI_INTERNAL_DYNAMIC_BUILD
#ifndef  XuniChartCoreKit_h
#import "XuniChartCore/BaseDataLabel.h"
#endif

#else
#import "XuniChartCoreDynamicKit/XuniChartCoreDynamicKit.h"
#endif

#ifndef FlexPieKit_h
#import "FlexPie.h"
#endif

/**
 *  ChartDataLabelPosition
 */
typedef NS_ENUM(NSInteger, FlexPieDataLabelPosition){
    /**
     *  FlexPieDataLabelPositionNone
     */
    FlexPieDataLabelPositionNone,
    /**
     *  FlexPieDataLabelPositionInside
     */
    FlexPieDataLabelPositionInside,
    /**
     *  FlexPieDataLabelPositionOutside
     */
    FlexPieDataLabelPositionOutside,
    /**
     *  FlexPieDataLabelPositionCenter
     */
    FlexPieDataLabelPositionCenter
};

@class FlexPie;

/**
 * FlexPieDataLabel
 */
@interface FlexPieDataLabel : XuniBaseDataLabel

/**
 *  Initialize an object for FlexPieDataLabel.
 *
 *  @param pie the pie.
 *
 *  @return an object for FlexPieDataLabel.
 */
-(id)init:(FlexPie*)pie;

/**
 *  Gets or sets the position of datalabel.
 */
@property(nonatomic) FlexPieDataLabelPosition position;
@end
