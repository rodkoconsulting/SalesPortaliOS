//
//  DataInfo.h
//  FlexChart
//
//  Copyright (c) GrapeCity, Inc. All rights reserved.
//

//#import "FlexChartBaseEnums.h"

/**
 *  XuniDataInfo.
 */
@interface XuniDataInfo : NSObject

/**
 *  Gets or sets the minimun X value.
 */
@property double minX;

/**
 *  Gets or sets the maximun X value.
 */
@property double maxX;

/**
 *  Gets or sets the minimun Y value.
 */
@property double minY;

/**
 *  Gets or sets the maximun Y value.
 */
@property double maxY;

/**
 *  Gets or sets the value of delta X.
 */
@property double deltaX;

/**
 *  Gets or sets the data type of X.
 */
@property enum XuniDataType dataTypeX;

/**
 *  Gets or sets the data type of Y.
 */
@property enum XuniDataType dataTypeY;

/**
 *  Gets or sets the maximun number of items refers to the series.
 */
@property NSUInteger maxItems;

/**
 *  Initialize an object for XuniDataInfo.
 *
 *  @return return an object of XuniDataInfo.
 */
- (id)init;

/**
 *  Caculate something use for stacking.
 *
 *  @param seriesList the list array of series.
 *  @param stacking   how the chart series are stacked.
 *  @param xvals      values about axis X.
 */
- (void)analyse:(NSArray*)seriesList stacking:(XuniStacking)stacking values:(NSArray*)xvals;

/**
 *  Gets the minimun X value.
 *
 *  @return the minimun X value.
 */
- (double)getMinX;

/**
 *  Gets the maximun X value.
 *
 *  @return the maximun X value.
 */
- (double)getMaxX;

/**
 *  Gets the minimun Y value.
 *
 *  @return the minimun Y value.
 */
- (double)getMinY;

/**
 *  Gets the maximun Y value.
 *
 *  @return the maximun Y value.
 */
- (double)getMaxY;

/**
 *  Gets the data type of X.
 *
 *  @return the data type of X.
 */
- (XuniDataType)getDataTypeX;

/**
 *  Gets the data type of Y.
 *
 *  @return the data type of Y.
 */
- (XuniDataType)getDataTypeY;

/**
 *  Gets stacked absolute sum value.
 *
 *  @param key the key for value.
 *
 *  @return return the stacked absolute sum value.
 */
- (double)getStackedAbsSum:(double)key;

/**
 *  @exclude.
 */
- (NSMutableDictionary*)getStackAbs;

/**
 *  Gets array of X vals.
 *
 *  @return return the array of X vals.
 */
- (NSArray*)getXVals;

/**
 *  Judge whether has more items.
 *
 *  @return return a boolean value.
 */
- (BOOL)hasMore;

/**
 *  Judge whether the number of orgin items is less than zero.
 *
 *  @return return a boolean value.
 */
- (BOOL)hasLess;

/**
 *  Judge whether shows more items.
 */
- (void)showMore;

/**
 *  Judge whether shows less items.
 */
- (void)showLess;

/**
 *  Gets the number of origin items.
 *
 *  @return a unsigned long value.
 */
- (NSUInteger)getOrigin;

/**
 *  Gets the number of items at the end.
 *
 *  @return return a unsigned long value.
 */
- (NSUInteger)getEnd;

/**
 *  Gets page size.
 *
 *  @return return a unsigned long value.
 */
- (NSUInteger)getPageSize;

/**
 *  Judge whether a number is finite.
 *
 *  @param value the value.
 *
 *  @return a boolean value.
 */
+ (BOOL)isValid:(double)value;

@end
