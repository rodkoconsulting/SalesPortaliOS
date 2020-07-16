//
//  CalendarRange.h
//  XuniCalendar
//
//  Copyright (c) GrapeCity, Inc. All rights reserved.
//

@class XuniCalendar;

/**
 *  XuniCalendarRange Class.
 */
@interface XuniCalendarRange : NSObject

/**
 *  Gets or sets the start date of range.
 */
@property (nonatomic) NSDate *startDate;

/**
 *  Gets or sets the end date of range.
 */
@property (nonatomic) NSDate *endDate;

/**
 *  Initializes and returns a newly allocated XuniCalendarRange object.
 *
 *  @param start The start date.
 *  @param end   The end date.
 *  @param calendar the XuniCalendar we need a range for.
 *
 *  @return An initialized XuniCalendarRange object or nil if the object couldn't be created.
 */
- (instancetype)initWithStartDate:(NSDate *)start endDay:(NSDate *)end calendar:(XuniCalendar *)calendar;

/**
 *  Returns whether a day falls within the range.
 *
 *  @param day The day for which to perform the calculation.
 *
 *  @return YES if the given day is within the range, otherwise NO.
 */
- (BOOL)containsDay:(NSDateComponents *)day;

/**
 *  Returns whether a date falls within the range.
 *
 *  @param date The date for which to perform the calculation.
 *
 *  @return YES if the given date is within the range, otherwise NO.
 */
- (BOOL)containsDate:(NSDate *)date;

/**
 *  Returns whether a date's year and month falls within the range.
 *
 *  @param date The date for which to perform the calculation.
 *
 *  @return YES if the given date is within the range, otherwise NO.
 */
- (BOOL)containsDateYM:(NSDate *)date;

/**
 *  Returns whether a date's year falls within the range.
 *
 *  @param date The date for which to perform the calculation.
 *
 *  @return YES if the given date is within the range, otherwise NO.
 */
- (BOOL)containsDateY:(NSDate *)date;

/**
 *  Add date to excluded dates array.
 *
 *  @param date The added date.
 */
- (void)addExcludedDates:(NSDate *)date;

/**
 *  Reset excluded dates array.
 */
- (void)resetExcludedDates;

@end
