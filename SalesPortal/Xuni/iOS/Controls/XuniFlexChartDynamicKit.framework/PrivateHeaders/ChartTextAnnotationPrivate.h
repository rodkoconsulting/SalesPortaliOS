//
//  ChartTextAnnotationPrivate.h
//  FlexChart
//
//  Copyright (c) GrapeCity, Inc. All rights reserved.
//

#ifndef ChartTextAnnotationPrivate_h
#define ChartTextAnnotationPrivate_h

#import "ChartTextAnnotation.h"

/**
 *  XuniChartTextAnnotation Class.
 */
@interface XuniChartTextAnnotation ()

/**
 *  Render the annotation text.
 *
 *  @param engine the render engine.
 *  @param rect   the rectangle to draw string.
 */
- (void)renderText:(XuniRenderEngine *)engine rect:(CGRect)rect;

@end

#endif
