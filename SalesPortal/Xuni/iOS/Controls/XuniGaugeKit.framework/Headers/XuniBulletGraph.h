//
//  XuniBulletGraph.h
//  FlexGauge
//
//  Copyright (c) GrapeCity, Inc. All rights reserved.
//

#import "XuniLinearGauge.h"

/**
 *  The XuniBulletGraph is a type of linear gauge designed specifically for use in dashboards.
 */
IB_DESIGNABLE
@interface XuniBulletGraph : XuniLinearGauge

/**
*  Gets or sets a reference value considered bad for the measure.
*/
@property (nonatomic) IBInspectable double bad;

/**
 *  Gets or sets a reference value considered good for the measure.
 */
@property (nonatomic) IBInspectable double good;

/**
 *  Gets or sets the target value for the measure.
 */
@property (nonatomic) IBInspectable double target;

/**
 *  Gets or sets the bad range fill.
 */
@property (nonatomic) IBInspectable UIColor *badRangeColor;

/**
 *  Gets or sets the good range fill.
 */
@property (nonatomic) IBInspectable UIColor *goodRangeColor;

/**
 *  Gets or sets the target fill.
 */
@property (nonatomic) IBInspectable UIColor *targetColor;

@end
