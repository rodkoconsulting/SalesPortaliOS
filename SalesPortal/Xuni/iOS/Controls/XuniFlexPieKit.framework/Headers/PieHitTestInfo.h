//
//  PieHitTestInfo.h
//  FlexPie
//
//  Copyright (c) GrapeCity, Inc. All rights reserved.
//
#ifndef XUNI_INTERNAL_DYNAMIC_BUILD
#ifndef XuniChartCoreKit_h
#import "XuniChartCore/HitTestInfo.h"
#endif
#else
#import "XuniCoreDynamicKit/XuniCoreDynamicKit.h"
#import "XuniChartCoreDynamicKit/XuniChartCoreDynamicKit.h"
#endif

@class FlexPie;
@class XuniPieDataPoint;

/**
 *  XuniPieHitTestInfo
 */
@interface XuniPieHitTestInfo : XuniHitTestInfo

/**
 *  Initialize an object of XuniPieHitTestInfo.
 *
 *  @param pie the FlexPie.
 *  @param x the x coordinate.
 *  @param y the y coordinate.
 *
 *  @return an object of XuniPieHitTestInfo.
 */
- (id)initWithPie:(FlexPie *)pie x:(double)x y:(double)y;

/**
 *  Gets the pie object the hit test occured inside.
 */
@property (readonly) FlexPie *pie;

/**
 *  Gets the DataPoint of the XuniChartHitTestInfo.
 */
@property (readonly) XuniPieDataPoint *dataPoint;

/**
 *  Gets the center coordinate of the tapped slice.
 */
@property  XuniPoint *sliceCenter;

@end
