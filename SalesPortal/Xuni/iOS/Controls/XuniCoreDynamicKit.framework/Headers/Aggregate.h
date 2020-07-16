//
//  Aggregate.h
//  XuniCore
//
//  Copyright (c) GrapeCity, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  Specifies the type of aggregate to calculate over a group of values.
 */
typedef NS_ENUM (NSInteger, XuniAggregate){
    /**
     * No aggregate.
     */
    XuniAggregateNone,
    /**
     * Returns the sum of the numeric values in the group.
     */
    XuniAggregateSum,
    /**
     * Returns the count of non-null values in the group.
     */
    XuniAggregateCnt,
    /**
     * Returns the average value of the numeric values in the group.
     */
    XuniAggregateAvg,
    /**
     * Returns the maximum value in the group.
     */
    XuniAggregateMax,
    /**
     * Returns the minimum value in the group.
     */
    XuniAggregateMin,
    /**
     * Returns the difference between the maximum and minimum numeric values in the group.
     */
    XuniAggregateRng,
    /**
     * Returns the sample standard deviation of the numeric values in the group
     * (uses the formula based on n-1).
     */
    XuniAggregateStd,
    /**
     * Returns the sample variance of the numeric values in the group
     * (uses the formula based on n-1).
     */
    XuniAggregateVar,
    /**
     * Returns the population standard deviation of the values in the group
     * (uses the formula based on n).
     */
    XuniAggregateStdPop,
    /**
     * Returns the population variance of the values in the group
     * (uses the formula based on n).
     */
    XuniAggregateVarPop
};

/**
 *  Calculates an aggregate value from the values in an array.
 *
 *  @param aggType the XuniAggregate type.
 *  @param items   the list of objects that contain the property name passed in from binding.
 *  @param binding the property to pull from each item inside items to generate the aggregate from.
 *
 *  @return the calculated aggregate.
 */
double XuniGetAggregate(XuniAggregate aggType,  NSArray * _Nonnull items, NSString  * _Nonnull binding);
