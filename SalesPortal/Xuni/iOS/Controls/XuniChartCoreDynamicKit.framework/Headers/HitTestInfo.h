//
//  HitTestInfo.h
//  XuniChartCore
//
//  Copyright (c) GrapeCity, Inc. All rights reserved.
//

/**
 *  XuniHitTestInfo Class.
 */
@interface XuniHitTestInfo : NSObject

/**
 *  Gets the coordinate of the hit test / touch event.
 */
@property (readonly) XuniPoint *point;

/**
 *  Initialize an object of XuniHitTestInfo.
 *
 *  @param x the x coordinate.
 *  @param y the y coordinate.
 *
 *  @return an object of XuniHitTestInfo.
 */
- (id)initWithX:(double)x y:(double)y;

@end

