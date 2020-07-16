//
//  IRenderEngine.h
//  XuniCore
//
//  Copyright (c) GrapeCity, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Drawing.h"

/**
 *  XuniRenderState.
 */
@interface XuniRenderState : NSObject

/**
 *  Gets or sets the fill color.
 */
@property UIColor *fill;

/**
 *  Gets or sets the stroke color.
 */
@property UIColor *stroke;

/**
 *  Gets or sets the stroke thickness.
 */
@property double strokeThickness;

/**
 *  Gets or sets the opacity.
 */
@property double opacity;

/**
 *  Gets or sets the border dashes.
 */
@property NSArray *borderDashes;

/**
 *  Gets or sets the font.
 */
@property UIFont *font;

@end

/**
 *  Use for drawing.
 */
@protocol IXuniRenderEngine

/**
 *  Clear the engine.
 */
- (void)clear;

/**
 *  Gets the color to fill text.
 *
 *  @return return a kind of color.
 */
- (UIColor *)getTextFill;

/**
 *  Set view port size.
 *
 *  @param width  the width of the size.
 *  @param height the height of the size.
 */
- (void)setViewportSize:(double)width height:(double)height;

/**
 *  Clip the rectangle.
 *
 *  @param x left of the rectangle.
 *  @param y top of the rectangle.
 *  @param w width of the rectangle.
 *  @param h height of the rectangle.
 */
- (void)setClipRect:(double)x y:(double)y w:(double)w h:(double)h;

/**
 *  Clear clip rect
 */
- (void)clearClipRect;

/**
 *  Set fill color.
 *
 *  @param color the specified color.
 */
- (void)setFill:(UIColor *)color;

/**
 *  Get fill color.
 *
 *  @return the fill color.
 */
- (UIColor *)getFill;

/**
 *  Set stroke color.
 *
 *  @param color the specified color.
 */
- (void)setStroke:(UIColor *)color;

/**
 *  Set stroke thickness.
 *
 *  @param thickness the specified thickness.
 */
- (void)setStrokeThickness:(double)thickness;

/**
 *  Set text fill color.
 *
 *  @param color the specified color.
 */
- (void)setTextFill:(UIColor *)color;

/**
 *  Set font.
 *
 *  @param font the specified font.
 */
- (void)setFont:(UIFont *)font;

/**
 *  Set opacity.
 *
 *  @param opacity the specified opacity.
 */
- (void)setOpacity:(double)opacity;

/**
 *  Set border dashes.
 *
 *  @param dashes the specified dashes.
 */
- (void)setBorderDashes:(NSArray *)dashes;

/**
 *  Set selected dashes.
 *
 *  @param dashes the specified dashes.
 */
- (void)setSelectedDashes:(NSArray *)dashes;

/**
 *  Set scale.
 *
 *  @param scalex scale x.
 *  @param scaley scale y.
 */
- (void)setScale:(float)scalex scaley:(float)scaley;

/**
 *  Set pan.
 *
 *  @param panX pan x.
 *  @param panY pan y.
 */
- (void)setPan:(float)panX y:(float)panY;

/**
 *  Draw a ellipse.
 *
 *  @param cx the left of the rectangle restraints the ellipse.
 *  @param cy the top of the rectangle restraints the ellipse.
 *  @param rx the width of the rectangle restraints the ellipse.
 *  @param ry the height of the rectangle restraints the ellipse.
 */
- (void)drawEllipse:(double)cx cy:(double)cy rx:(double)rx ry:(double)ry;

/**
 *  Draw a rectangle.
 *
 *  @param x        the left of the rectangle.
 *  @param y        the right of the rectangle.
 *  @param w        the width of the rectangle.
 *  @param h        the height of the rectangle.
 *  @param selected whether is selected.
 */
- (void)drawRect:(double)x y:(double)y w:(double)w h:(double)h isSelected:(BOOL)selected;

/**
 *  Draw a rectangle.
 *
 *  @param x the left of the rectangle.
 *  @param y the right of the rectangle.
 *  @param w the width of the rectangle.
 *  @param h the height of the rectangle.
 */
- (void)drawRect:(double)x y:(double)y w:(double)w h:(double)h;

/**
 *  Draw a line.
 *
 *  @param x1 the x value of the start point of the line.
 *  @param y1 the y value of the start point of the line.
 *  @param x2 the x value of the end point of the line.
 *  @param y2 the y value of the end point of the line.
 */
- (void)drawLine:(double)x1 y1:(double)y1 x2:(double)x2 y2:(double)y2;

/**
 *  Draw lines.
 *
 *  @param xs the x values of the points.
 *  @param ys the y values of the points.
 */
- (void)drawLines:(NSArray *)xs ys:(NSArray *)ys;

/**
 *  Draw splines.
 *
 *  @param xs the x values of the points.
 *  @param ys the y values of the points.
 *  @param isRotated whether the chart is rotated.
 */
- (void)drawSplines:(NSArray *)xs ys:(NSArray *)ys isRotated:(BOOL)isRotated;

/**
 *  Draw areas generates by splines.
 *
 *  @param xs      the x values of the points.
 *  @param ys      the y values of the points.
 *  @param stacked whether is stacked.
 *  @param isRotated whether the chart is rotated.
 */
- (void)drawSplineAreas:(NSArray *)xs ys:(NSArray *)ys stacked:(BOOL)stacked isRotated:(BOOL)isRotated;

/**
 *  Draw polygon.
 *
 *  @param xs the x values of the points.
 *  @param ys the y values of the points.
 */
- (void)drawPolygon:(NSArray *)xs ys:(NSArray *)ys;

/**
 *  Draw polygon with mode.
 *
 *  @param points the array of XuniPoint.
 *  @param mode   the CGPathDrawingMode.
 */
- (void)drawPolygonWithMode:(NSArray *)points mode:(CGPathDrawingMode)mode;

/**
 *  Draw radial gauge.
 *
 *  @param x          x.
 *  @param y          y.
 *  @param startX     x value of start point.
 *  @param startY     y value of start point.
 *  @param radiusOut  the external radius.
 *  @param radiusIn   the inner radius.
 *  @param startAngle the start angle.
 *  @param endAngle   the end angle.
 */
- (void)drawRadialGauge:(double)x y:(double)y startX:(double)startX startY:(double)startY radiusOut:(double)radiusOut radiusIn:(double)radiusIn startAngle:(double)startAngle endAngle:(double)endAngle;

/**
 *  Draw the segments of pie.
 *
 *  @param cx         the x value of the center point of the circle.
 *  @param cy         the y value of the center point of the circle.
 *  @param radius     the radius of the circle.
 *  @param startAngle the start angle.
 *  @param sweepAngle the sweep angle.
 *  @param selected   whether is selected.
 *
 *  @return return a path of the pie segment.
 */
- (CGMutablePathRef)drawPieSegment:(double)cx cy:(double)cy radius:(double)radius startAngle:(double)startAngle sweepAngle:(double)sweepAngle selected:(BOOL)selected;

/**
 *  Draw the donut of pie.
 *
 *  @param cx          the x value of the center point of the circle.
 *  @param cy          the y value of the center point of the circle.
 *  @param radius      the radius of the circle.
 *  @param innerRadius the inner radius of the circle.
 *  @param startAngle  the start angle.
 *  @param sweepAngle  the sweep angle.
 *  @param selected    whether is selected.
 *
 *  @return a path of the pie donut.
 */
- (CGMutablePathRef)drawDonutSegment:(double)cx cy:(double)cy radius:(double)radius innerRadius:(double)innerRadius startAngle:(double)startAngle sweepAngle:(double)sweepAngle selected:(BOOL)selected;

/**
 *  Draw string.
 *
 *  @param s  the specified string.
 *  @param pt the specified point at which to draw the string.
 */
- (void)drawString:(NSString *)s pt:(XuniPoint *)pt;

/**
 *  Draw string in rectangle.
 *
 *  @param s  the specified string.
 *  @param rect the specified rectangle which to draw the string in.
 */
- (void)drawStringInRect:(NSString *)s rect:(CGRect)rect;

/**
 *  Draw rotated string.
 *
 *  @param label  the string.
 *  @param pt     the specified point at which to draw the string.
 *  @param center the specified point at which the string is turned around.
 *  @param angle  the angle.
 */
- (void)drawStringRotated:(NSString *)label pt:(XuniPoint *)pt center:(XuniPoint *)center angle:(double)angle;

/**
 *  Draw image.
 *
 *  @param image  the image.
 *  @param rect   the specified rectangle at which to draw the image.
 */
- (void)drawImage:(CGImageRef)image rect:(CGRect)rect;

/**
 *  Measure the size of the string.
 *
 *  @param s the specified string.
 *
 *  @return return the size of the string.
 */
- (XuniSize *)measureString:(NSString *)s;

/**
 *  Measure the size of the rotated string.
 *
 *  @param s     the specified string.
 *  @param angle the rotated angle of the string.
 *
 *  @return return the size of the rotated string.
 */
- (XuniSize *)measureString:(NSString *)s rotated:(double)angle;

/**
 *  Start group
 *
 *  @param groupName the group name.
 */
- (void)startGroup:(NSString *)groupName;
/**
 *  End group.
 */
- (void)endGroup;

/**
 *  Save the state for render.
 *
 *  @return return the render state.
 */
- (XuniRenderState *)saveState;

/**
 *  Restore the render state.
 *
 *  @param state the render state.
 */
- (void)restoreState:(XuniRenderState *)state;

/**
 *  Get stroke color.
 *
 *  @return stroke color.
 */
- (UIColor *)getStroke;

/**
 *  Get stroke thickness.
 *
 *  @return stroke thickness.
 */
- (double)getStrokeThickness;
@end
