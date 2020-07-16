//
//  XuniRadialGauge.h
//  FlexGauge
//
//  Copyright (c) GrapeCity, Inc. All rights reserved.
//

#import "XuniGauge.h"

/**
 *  The XuniRadialGauge displays a circular scale with an indicator
 *  that represents a single value and optional ranges to represent reference values.
 */
IB_DESIGNABLE
@interface XuniRadialGauge : XuniGauge

/**
 *  Gets or sets the start angle of the radial gague.
 */

@property (nonatomic) IBInspectable double startAngle;
/**
 *  Gets or sets the sweep angle of the radial gague.
 */
@property (nonatomic) IBInspectable double sweepAngle;
/**
 *  Gets or sets whether to auto scale the gague.
 */
@property (nonatomic) IBInspectable BOOL autoScale;

@end
