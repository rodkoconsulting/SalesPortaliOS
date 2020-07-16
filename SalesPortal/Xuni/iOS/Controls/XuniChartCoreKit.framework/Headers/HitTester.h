//
//  HitTester.h
//  XuniChartCore
//
//  Copyright (c) GrapeCity, Inc. All rights reserved.
//

/**
 *  protocol IXuniHitArea
 */
@protocol IXuniHitArea

/**
 *  Gets or sets the tag of area.
 */
@property NSObject *tag;

/**
 *  Gets or sets the startAngle of pie segment.
 */
@property double startAngle;

/**
 *  Gets or sets the sweep of pie segment.
 */
@property double sweep;

/**
 *  Judge whether the point is in the area.
 *
 *  @param point the point in control coordinates that this HitTestInfo refers to.
 *
 *  @return return a boolean value.
 */
- (BOOL)contains:(XuniPoint*)point;

/**
 *  Calculate the distance.
 *
 *  @param point  the point in control coordinates that this HitTestInfo refers to.
 *
 *  @return return the distance.
 */
- (double)distance:(XuniPoint*)point;
@end

/**
 *  XuniRectArea Class.
 */
@interface XuniRectArea : NSObject<IXuniHitArea>

/**
 *  Gets or sets the tag of area.
 */
@property NSObject *tag;

/**
*  Gets the rectangle that makes up the area.
*/
@property (readonly) XuniRect* rect;

/**
 *  Initialize an object for XuniRectArea.
 *
 *  @param rect the rect of the area.
 *
 *  @return return an object of XuniRectArea.
 */
- (id)init:(XuniRect*)rect;

/**
 *  Calculate the distance from one point to another.
 *
 *  @param pt1    one point.
 *  @param pt2    another point.
 *  @param option measure option.
 *
 *  @return return the distance between the two points.
 */
- (double)distanceFromPoint:(XuniPoint*)pt1 toPoint:(XuniPoint*)pt2 option:(XuniMeasureOption)option;
@end

/**
 *  XuniCircleArea Class.
 */
@interface XuniCircleArea : NSObject<IXuniHitArea>

/**
 *  Gets or sets the tag of area.
 */
@property NSObject *tag;

/**
 *  Gets the center of circle area.
 */
@property (readonly) XuniPoint* center;

/**
 *  Initialize an object for XuniCircleArea.
 *
 *  @param center the center of the area.
 *  @param radius the radius of the area.
 *
 *  @return return an object for XuniCircleArea.
 */
- (id)init:(XuniPoint*)center radius:(double)radius;
@end

/**
 *  XuniHitResult Class.
 */
@interface XuniHitResult : NSObject

/**
 *  Gets or sets the area about the chart.
 */
@property NSObject<IXuniHitArea> *area;

/**
 *  Gets or sets the distance from the closest data point.
 */
@property double distance;
@end

/**
 *  XuniHitTester.
 */
@interface XuniHitTester : NSObject

/**
 *  Put the area and the index of series together.
 *
 *  @param area        the area about the chart.
 *  @param seriesIndex the index of series.
 */
- (void)add:(NSObject<IXuniHitArea>*)area seriesIndex:(int)seriesIndex;

/**
 *  Clear some objects.
 */
- (void)clear;

/**
 *  Gets the result after hit the area.
 *
 *  @param point  the point in control coordinates that this HitTestInfo refers to.
 *
 *  @return return the result after hit the area.
 */
- (XuniHitResult*) hitTest:(XuniPoint*)point;

/**
 *  Gets the result after hit the series.
 *
 *  @param point       the point in control coordinates that this HitTestInfo refers to.
 *  @param seriesIndex the index of the series.
 *
 *  @return return the result after hit the series.
 */
- (XuniHitResult*) hitTestSeries:(XuniPoint*)point seriesIndex:(int)seriesIndex;

/**
 *  @exclude.
 */
- (NSMutableDictionary *) getHitTesterMap;

@end
