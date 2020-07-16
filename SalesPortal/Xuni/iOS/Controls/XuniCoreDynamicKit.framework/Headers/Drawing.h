//
//  Drawing.h
//  XuniCore
//
//  Copyright (c) GrapeCity, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  XuniHorizontalAlignment
 */
typedef NS_ENUM (NSInteger, XuniHorizontalAlignment){
    /**
     *  XuniHorizontalAlignmentLeft
     */
    XuniHorizontalAlignmentLeft,
    /**
     *  XuniHorizontalAlignmentCenter
     */
    XuniHorizontalAlignmentCenter,
    /**
     *  XuniHorizontalAlignmentRight
     */
    XuniHorizontalAlignmentRight
};

/**
 *  XuniVerticalAlignment
 */
typedef NS_ENUM (NSInteger, XuniVerticalAlignment){
    /**
     *  XuniVerticalAlignmentTop
     */
    XuniVerticalAlignmentTop,
    /**
     *  XuniVerticalAlignmentCenter
     */
    XuniVerticalAlignmentCenter,
    /**
     *  XuniVerticalAlignmentBottom
     */
    XuniVerticalAlignmentBottom
};

/**
 *  Class XuniPoint.
 */
@interface XuniPoint : NSObject

/**
 *  Gets or sets the x value of the XuniPoint.
 */
@property double x;
/**
 *  Gets or sets the y value of the XuniPoint.
 */
@property double y;

/**
 *  Initialize an object for XuniPoint.
 *
 *  @return return an object of XuniPoint.
 */
- (id)init;

/**
 *  Initialize an object for XuniPoint with x value and y value.
 *
 *  @param x the x coordinate.
 *  @param y the y coordinate.
 *
 *  @return return an object of XuniPoint.
 */
- (id)initX:(double)x Y:(double)y;

/**
 *  Clone an object of XuniPoint.
 *
 *  @return return an object of XuniPoint.
 */
- (id)clone;

/**
 *  Judge whether the two points are equal.
 *
 *  @param other the other point.
 *
 *  @return return a boolean value.
 */
- (BOOL)isEqual:(XuniPoint *)other;
@end

/**
 *  XuniSize.
 */
@interface XuniSize : NSObject
/**
 *  Gets or sets the width of an XuniRect.
 */
@property double width;
/**
 *  Gets or sets the height of an XuniRect.
 */
@property double height;

/**
 *  Initialize an object for XuniSize.
 *
 *  @return return an object of XuniSize.
 */
- (id)init;

/**
 *  Initialize an object for XuniSize with width and height.
 *
 *  @param width  the width.
 *  @param height the height.
 *
 *  @return an object of XuniSize.
 */
- (id)initWidth:(double)width height:(double)height;

/**
 *  Clone an object of XuniSize.
 *
 *  @return return an object of XuniSize.
 */
- (id)clone;

/**
 *  Judge whether the two sizes are equal.
 *
 *  @param other the other size.
 *
 *  @return return a boolean value.
 */
- (BOOL)isEqual:(XuniSize *)other;
@end

/**
 *  Class XuniRect.
 */
@interface XuniRect : NSObject
/**
 *  Gets or sets the left of an XuniRect.
 */
@property double left;
/**
 *  Gets or sets the top of an XuniRect.
 */
@property double top;
/**
 *  Gets or sets the width of an XuniRect.
 */
@property double width;
/**
 *  Gets or sets the height of an XuniRect.
 */
@property double height;
/**
 *  Gets or sets the right of an XuniRect.
 */
@property (readonly) double right;
/**
 *  Gets or sets the bottom of an XuniRect.
 */
@property (readonly) double bottom;

/**
 *  Initialize an object for XuniRect.
 *
 *  @return return an object of XuniRect.
 */
- (id)init;

/**
 *  Initialize an object for XuniRect with left and top and width and height.
 *
 *  @param left   the left of an XuniRect.
 *  @param top    the top of an XuniRect.
 *  @param width  the width of an XuniRect.
 *  @param height the height of an XuniRect.
 *
 *  @return return an object for XuniRect.
 */
- (id)initLeft:(double)left top:(double)top width:(double)width height:(double)height;

/**
 *  Clone an object of XuniRect.
 *
 *  @return return an object of XuniRect.
 */
- (id)clone;

/**
 *  Judge whether the two rects are equal.
 *
 *  @param other the other rect.
 *
 *  @return return a boolean value.
 */
- (BOOL)isEqual:(XuniRect *)other;

/**
 *  Judge whether the rect contains the point.
 *
 *  @param point the point in control coordinates that this HitTestInfo refers to.
 *
 *  @return return a boolean value.
 */
- (BOOL)containsPoint:(XuniPoint *)point;

/**
 *  Creates a rectangle that results from expanding or shrinking a rectangle by the specified amounts.
 *
 *  @param dx the dx.
 *  @param dy the dy.
 *
 *  @return return an inflated rectangle.
 */
- (XuniRect *)inflate:(double)dx dy:(double)dy;
@end
