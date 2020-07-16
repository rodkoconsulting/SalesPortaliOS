//
//  ChartPolygonAnnotation.h
//  FlexChart
//
//  Copyright (c) GrapeCity, Inc. All rights reserved.
//

#import "ChartShapeAnnotation.h"

/**
 *  The polygon annotation class.
 */
@interface XuniChartPolygonAnnotation : XuniChartShapeAnnotation

/**
 *  Gets or sets the collection of points for the polygon annotation.
 */
@property (nonatomic) NSMutableArray *points;

@end
