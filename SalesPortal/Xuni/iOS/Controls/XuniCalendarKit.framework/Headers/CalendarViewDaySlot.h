//
//  CalendarViewDaySlot.h
//  XuniCalendar
//
//  Copyright (c) GrapeCity, Inc. All rights reserved.
//

#import "CalendarDaySlotBase.h"

@class XuniCalendar;

/**
 *  XuniCalendarViewDaySlot Class.
 *  Represents a day slot containing a custom view.
 */
@interface XuniCalendarViewDaySlot : XuniCalendarDaySlotBase

/**
 *  Gets or sets the custom view.
 */
@property (nonatomic) UIView *customView;

/**
 *  Gets or sets the calendar.
 */
@property (nonatomic) XuniCalendar *xuniCalendar;

/**
 *  Gets or sets the date of the day slot.
 */
@property (nonatomic) NSDate *date;

/**
 *  Gets or sets the state of day slot.
 */
@property (nonatomic) XuniDaySlotState state;

/**
 *  Initializes and returns a newly allocated XuniCalendarViewDaySlot object with the specified calendar and frame rectangle.
 *
 *  @param calendar The XuniCalendar object.
 *  @param frame    The frame rectangle for the XuniCalendarViewDaySlot, measured in points.
 *
 *  @return An initialized XuniCalendarViewDaySlot object or nil if the object couldn't be created.
 */
- (id)initWithCalendar:(XuniCalendar *)calendar frame:(CGRect)frame;

/**
 *  Returns whether the day slot is selected.
 *
 *  @return YES if the day slot is selected, otherwise NO.
 */
- (BOOL)isSelected;

/**
 *  Returns whether the day slot's date is today.
 *
 *  @return YES if the day slot's date is today, otherwise NO.
 */
- (BOOL)isToday;

/**
 *  Returns whether the day slot is adjacent.
 *
 *  @return YES if the day slot is adjacent, otherwise NO.
 */
- (BOOL)isAdjacent;

@end
