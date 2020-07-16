//
//  CalendarDelegate.h
//  XuniCalendar
//
//  Copyright (c) GrapeCity, Inc. All rights reserved.
//

#ifndef CalendarDelegate_h
#define CalendarDelegate_h

#import "XuniCalendarEnums.h"
#import "CalendarRange.h"

@class XuniCalendar;
@class XuniCalendarDaySlotLoadingEventArgs;
@class XuniCalendarDayOfWeekSlotLoadingEventArgs;
@class XuniCalendarSelectionChangedEventArgs;
@class XuniCalendarHeaderLoadingEventArgs;
@class XuniCalendarMonthSlotLoadingEventArgs;
@class XuniCalendarYearSlotLoadingEventArgs;
@class XuniCalendarDaySlotBase;
@class XuniCalendarMonthSlotBase;
@class XuniCalendarYearSlotBase;

/**
 *  protocol XuniCalendarDelegate.
 */
@protocol XuniCalendarDelegate <NSObject>
@optional

/**
 *  Occurs when calendar view mode changed, such as when the user taps the month header.
 *
 *  @param sender The calendar which view mode changed.
 */
- (void)viewModeChanged:(XuniCalendar *)sender;

/**
 *  Occurs when the displayDate property has changed.
 *
 *  @param sender The calendar which displayDate property changed.
 */
- (void)displayDateChanged:(XuniCalendar *)sender;

/**
 *  Occurs before the displayDate property changes.
 *
 *  @param sender The calendar which displayDate property changed.
 */
- (void)displayDateChanging:(XuniCalendar *)sender;

/**
 *  Occurs when an element representing a day of week is about to be created.
 *
 *  @param sender        The calendar which day of week added to.
 *  @param dayOfWeek     The day of week.
 *  @param isWeekend     Is weekend or not.
 *  @param dayOfWeekSlot The day of week slot.
 */
- (void)dayOfWeekSlotLoading:(XuniCalendar *)sender dayOfWeek:(XuniDayOfWeek)dayOfWeek isWeekend:(BOOL)isWeekend dayOfWeekSlot:(UILabel*)dayOfWeekSlot;

/**
 *  Occurs when an element representing a day in the calendar is about to be created.
 *
 *  @param sender        The calendar which day added to.
 *  @param date          The slot date.
 *  @param isAdjacentDay Is adjacent day or not.
 *  @param daySlot       The day slot.
 *
 *  @return The day slot which added to calendar.
 */
- (XuniCalendarDaySlotBase*)daySlotLoading:(XuniCalendar *)sender date:(NSDate*)date isAdjacentDay:(BOOL)isAdjacentDay daySlot:(XuniCalendarDaySlotBase*)daySlot;

/**
 *  Occurs when an element representing a month in the calendar is about to be created.
 *
 *  @param sender    The calendar which month added to.
 *  @param month     The month number.
 *  @param monthSlot The month slot.
 */
- (void)monthSlotLoading:(XuniCalendar *)sender month:(NSUInteger)month monthSlot:(XuniCalendarMonthSlotBase*)monthSlot;

/**
 *  Occurs when an element representing a year in the calendar is about to be created.
 *
 *  @param sender         The calendar which year added to.
 *  @param year           The year number.
 *  @param isAdjacentYear Is adjacent year or not.
 *  @param yearSlot       The year slot.
 */
- (void)yearSlotLoading:(XuniCalendar *)sender year:(NSUInteger)year isAdjacentYear:(BOOL)isAdjacentYear yearSlot:(XuniCalendarYearSlotBase*)yearSlot;

/**
 *  Occurs when the selectedDate or selectedDates properties changed.
 *
 *  @param sender        The calendar which selectedDate or selectedDates properties changed.
 *  @param selectedDates The selected dates.
 */
- (void)selectionChanged:(XuniCalendar *)sender selectedDates:(XuniCalendarRange*)selectedDates;

/**
 *  Occurs before the selection is completed.
 *
 *  @param sender        The calendar which selectedDate or selectedDates properties changed.
 *  @param selectedDates The selected dates.
 */
- (void)selectionChanging:(XuniCalendar *)sender selectedDates:(XuniCalendarRange*)selectedDates;

/**
 *  Handle header loading event.
 *
 *  @param sender   The calendar sending this event.
 *  @param header   The header text.
 *  @param viewMode The calendar view mode.
 *  @param date     The calendar header date.
 *
 *  @return The header text.
 */
- (NSString *)handleHeaderLoading:(XuniCalendar *)sender header:(NSString *)header viewMode:(XuniCalendarViewMode)viewMode date:(NSDate *)date;

/**
 *  Called when the control finished rendering.
 *
 *  @param sender The control which is rendered.
 */
- (void)rendered:(XuniCalendar *)sender;

@end

#endif /* CalendarDelegate_h */
