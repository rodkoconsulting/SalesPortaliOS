//
//  DataPointPrivate.h
//  XuniChartCore
//
//  Copyright (c) GrapeCity, Inc. All rights reserved.
//

#ifndef XuniChartCore_DataPointPrivate_h
#define XuniChartCore_DataPointPrivate_h

#ifdef XUNI_INTERNAL_DYNAMIC_BUILD
#import "XuniChartCoreDynamicKit/DataPoint.h"
#else
#import "DataPoint.h"
#endif

/**
 *  XuniDataPoint Class.
 */
@interface XuniDataPoint ()

/**
 *  Gets or sets numeric value for this data point.
 */
@property double value;

/**
 *  Gets or sets the point index for the data point.
 */
@property int pointIndex;

/**
 *  Gets or sets the underlying business object this data point is bound to.
 */
@property NSObject *dataObject;

@end

#endif
