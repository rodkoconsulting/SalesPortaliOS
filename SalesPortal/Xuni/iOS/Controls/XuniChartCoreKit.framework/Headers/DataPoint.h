//
//  DataPoint.h
//  XuniChartCore
//
//  Copyright (c) GrapeCity, Inc. All rights reserved.
//

/**
 *  XuniDataPoint Class.
 */
@interface XuniDataPoint : NSObject

/**
 *  Gets the numeric value for this data point.
 */
@property (readonly) double value;

/**
 *  Gets the point index for the data point.
 */
@property (readonly) int pointIndex;

/**
 *  Gets the underlying business object this data point is bound to.
 */
@property (readonly) NSObject *dataObject;

@end