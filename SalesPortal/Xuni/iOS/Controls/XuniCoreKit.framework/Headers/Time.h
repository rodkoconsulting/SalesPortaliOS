//
//  Time.h
//  XuniCore
//
//  Copyright (c) GrapeCity, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  XuniSecondsPer
 */
typedef NS_ENUM (NSInteger, XuniSecondsPer){
    /**
     *  XuniSecondsPerSecond.
     */
    XuniSecondsPerSecond = 1,
    /**
     *  Set 60 seconds per minute.
     */
    XuniSecondsPerMinute = 60,
    /**
     *  Set 3600 seconds per hour.
     */
    XuniSecondsPerHour = 3600,
    /**
     *  Set 86400 seconds per day.
     */
    XuniSecondsPerDay = 86400,
    /**
     *  Set 604800 seconds per week.
     */
    XuniSecondsPerWeek = 604800,
    /**
     *  Set 2678400 seconds per month.
     */
    XuniSecondsPerMonth = 2678400,
    /**
     *  Set 31536000 seconds per year.
     */
    XuniSecondsPerYear = 31536000
};

/**
 *  XuniTimeSpan.
 */
@interface XuniTimeSpan : NSObject

/**
 *  Gets the total seconds.
 */
@property (readonly) double totalSeconds;

/**
 *  Get the total days.
 */
@property (readonly) double totalDays;

/**
 *  Initialize an object for XuniTimeSpan.
 *
 *  @param seconds the seconds.
 *
 *  @return an object for XuniTimeSpan.
 */
- (id)initSeconds:(double)seconds;

/**
 *  Get an XuniTimeSpan object from seconds.
 *
 *  @param seconds the seconds.
 *
 *  @return an XuniTimeSpan object.
 */
+ (XuniTimeSpan *)fromSeconds:(double)seconds;

/**
 *  Get an XuniTimeSpan object from days.
 *
 *  @param days the days.
 *
 *  @return an XuniTimeSpan object.
 */
+ (XuniTimeSpan *)fromDays:(double)days;
@end

/**
 * XuniTimeHelper.
 */
@interface XuniTimeHelper : NSObject

/**
 *  Initialize an object for XuniTimeHelper.
 *
 *  @param date the date.
 *
 *  @return return an object of XuniTimeHelper.
 */
- (id)initDate:(NSDate *)date;

/**
 *  Initialize an object for XuniTimeHelper.
 *
 *  @param seconds the seconds.
 *
 *  @return an object of XuniTimeHelper.
 */
- (id)initTimeIntervalSince1970:(NSTimeInterval)seconds;

/**
 *  Get time as date time.
 *
 *  @return return a date.
 */
- (NSDate *)getTimeAsDateTime;

/**
 *  Get time as double.
 *
 *  @return return a double value.
 */
- (double)getTimeAsDouble;

/**
 *  Get a NSInteger type value.
 *
 *  @param tval    the tval.
 *  @param tunit   the tunit.
 *  @param roundup whether is roundup.
 *
 *  @return a NSInteger type value.
 */
+ (NSInteger)tround:(NSInteger)tval tunit:(NSInteger)tunit roundup:(BOOL)roundup;

/**
 *  Get a double value.
 *
 *  @param timevalue the timevalue.
 *  @param unit      the unit.
 *  @param roundup   whether is roundup.
 *
 *  @return a double value.
 */
+ (double)roundTime:(double)timevalue unit:(NSInteger)unit roundup:(BOOL)roundup;

/**
 *  Get an object of XuniTimeSpan.
 *
 *  @param ti the ti value.
 *
 *  @return an object of XuniTimeSpan.
 */
+ (XuniTimeSpan *)timeSpanFromTmInc:(NSInteger)ti;
/**
 *  @exclude
 */
/**
 *   Get a NSInteger type value.
 *
 *  @param manualformat the manualformat string.
 *
 *  @return a NSInteger type value.
 */
+ (NSInteger)manualTimeInc:(NSString *)manualformat;

/**
 *  Get a double value.
 *
 *  @param tik  the tik value.
 *  @param ts   the ts value.
 *  @param mult the mult value.
 *
 *  @return a double value.
 */
+ (double)getNiceInc:(NSArray *)tik ts:(double)ts mult:(double)mult;

/**
 *  Get an object of XuniTimeSpan.
 *
 *  @param ts           the ts object of XuniTimeSpan.
 *  @param manualformat  the manualformat string.
 *
 *  @return an object of XuniTimeSpan.
 */
+ (XuniTimeSpan *)niceTimeSpan:(XuniTimeSpan *)ts manualformat:(NSString *)manualformat;
@end
