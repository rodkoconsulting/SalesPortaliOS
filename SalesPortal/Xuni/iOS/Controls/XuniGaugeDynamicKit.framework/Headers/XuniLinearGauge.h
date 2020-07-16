//
//  XuniLinearGauge.h
//  FlexGauge
//
//  Copyright (c) GrapeCity, Inc. All rights reserved.
//

#import "XuniGauge.h"

/**
 *  The XuniLinearGauge displays a linear scale with an indicator that represents
 *  a single value and optional ranges to represent reference values.
 */
IB_DESIGNABLE
@interface XuniLinearGauge : XuniGauge

/**
 *  The direction of the gague.
 */
@property (nonatomic) XuniGaugeDirection direction;

/**
 *  Get a rectangle of the range.
 *
 *  @param rng   the range of gague.
 *  @param value the given value.
 *
 *  @return a rectangle of the range.
 */
- (XuniRect*)getRangeRect:(XuniGaugeRange*)rng value:(double)value;


///#### Syntax <candies> for design-time property setting

/**
 *  Gets or sets whether the gauge is vertical.
 */
@property (nonatomic) IBInspectable BOOL isVertical;

/**
 *  Gets or sets whether the gauge is reversed
 */
@property (nonatomic) IBInspectable BOOL isReversed;


@end
