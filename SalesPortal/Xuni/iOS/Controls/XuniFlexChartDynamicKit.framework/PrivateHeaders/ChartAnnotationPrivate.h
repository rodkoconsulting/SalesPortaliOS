//
//  ChartAnnotationPrivate.h
//  FlexChart
//
//  Copyright (c) GrapeCity, Inc. All rights reserved.
//

#ifndef ChartAnnotationPrivate_h
#define ChartAnnotationPrivate_h

#import "ChartAnnotation.h"

/**
 *  XuniChartAnnotation Class.
 */
@interface XuniChartAnnotation ()

/**
 *  Gets or sets the path.
 */
@property struct CGPath *path;

/**
 *  Gets or sets the transform.
 */
@property CGAffineTransform annoTransform;

/**
 *  Judge if need to render the annotation.
 *
 *  @param engine the render engine.
 *
 *  @return return whether need to render.
 */
- (BOOL)isNeedRender:(XuniRenderEngine *)engine;

/**
 *  Render the annotation.
 *
 *  @param engine the render engine.
 *
 *  @return return the render result.
 */
- (BOOL)render:(XuniRenderEngine *)engine;

/**
 *  Get the absolute point of the annotation.
 *
 *  @param point      the point of the annotation.
 *  @param position   the position of the annotation relative to the point.
 *  @param attachment the attachment of the annotation.
 *  @param engine the render engine.
 *
 *  @return return the absolute point.
 */
- (XuniPoint *)getAbsolutePoint:(XuniPoint *)point position:(XuniChartAnnotationPosition)position attachment:(XuniChartAnnotationAttachment)attachment engine:(XuniRenderEngine*)engine;

/**
 *  Judge if annotation contain the point.
 *
 *  @param point the point.
 *
 *  @return return a boolean value.
 */
- (BOOL)isContains:(XuniPoint *)point;

/**
 *  Judge if need to set clipped rect.
 *
 *  @return return a boolean value.
 */
- (BOOL)isNeedClipRect;

@end

#endif
