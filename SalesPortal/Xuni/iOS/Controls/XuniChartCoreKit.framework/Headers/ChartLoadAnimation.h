//
//  ChartLoadAnimation.h
//  XuniChartCore
//
//  Copyright (c) GrapeCity, Inc. All rights reserved.
//

#import "FlexChartBaseEnums.h"
#import "FlexChartBase.h"

#ifndef XuniCoreKit_h
#import "XuniCore/Animation.h"
#endif

/**
 *  XuniChartLoadAnimation Class.
 */
@interface XuniChartLoadAnimation : XuniAnimation

/**
*  Specifies how plotted points are animated.
*/
@property (nonatomic) XuniAnimationMode animationMode;

/**
*  The chart control that owns this load animation.
*/
@property (nonatomic)FlexChartBase *chart;

/**
*  init a new XuniChartLoadAnimation.
*/
- (id)init;

@end
