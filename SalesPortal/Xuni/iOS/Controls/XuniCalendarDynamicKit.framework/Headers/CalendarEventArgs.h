//
//  CalendarEventArgs.h
//  XuniCalendar
//
//  Copyright (c) GrapeCity, Inc. All rights reserved.
//

#ifndef XUNI_INTERNAL_DYNAMIC_BUILD

#ifndef XuniCoreKit_h
#import "XuniCore/Event.h"
#endif


#else
#import "XuniCoreDynamicKit/XuniCoreDynamicKit.h"
#endif

@class XuniCalendarDaySlotBase;
@class XuniCalendarMonthSlotBase;
@class XuniCalendarYearSlotBase;
@class XuniCalendarRange;

/**
 *  XuniCalendarDayOfWeekSlotLoadingEventArgs Class.
 *  Arguments for dayOfWeekSlotLoading event.
 */
@interface XuniCalendarDayOfWeekSlotLoadingEventArgs : XuniEventArgs

/**
 *  Gets the date information for the corresponding day of week slot.
 */
@property (readonly) XuniDayOfWeek dayOfWeek;

/**
 *  Gets whether the day is in the weekend.
 */
@property (readonly) BOOL isWeekend;

/**
 *  Gets or sets the visual element shown in the day of week slot.
 */
@property (nonatomic) UILabel *dayOfWeekSlot;

/**
 *  Initializes and returns a newly allocated XuniCalendarDayOfWeekSlotLoadingEventArgs object.
 *
 *  @param dayOfWeek        The day of week for the corresponding day of week slot.
 *  @param isWeekend        Specifies whether it is a week end day.
 *  @param dayOfWeekSlot    Visual element that will be displayed in the day of week slot.
 *
 *  @return An initialized XuniCalendarDayOfWeekSlotLoadingEventArgs object or nil if the object couldn't be created.
 */
- (instancetype)initWithDayOfWeek:(XuniDayOfWeek)dayOfWeek isWeekend:(BOOL)isWeekend dayOfWeekSlot:(UILabel *)dayOfWeekSlot;

@end


/**
 *  XuniCalendarDaySlotLoadingEventArgs Class.
 *  Arguments for daySlotLoading event.
 */
@interface XuniCalendarDaySlotLoadingEventArgs : XuniEventArgs

/**
 *  Gets the date information for the current day slot.
 */
@property (readonly) NSDate *date;

/**
 *  Gets whether or not the day is an adjacent day in the calendar.
 */
@property (readonly) BOOL isAdjacentDay;

/**
 *  Gets or sets the visual element shown in the day slot.
 */
@property (nonatomic) XuniCalendarDaySlotBase *daySlot;

/**
 *  Initializes and returns a newly allocated XuniCalendarDaySlotLoadingEventArgs object.
 *
 *  @param date             The date for the current day slot.
 *  @param isAdjacentDay    Specifies whether the day is an adjacent day in the calendar.
 *  @param daySlot          Visual element that will be displayed in the day slot.
 *
 *  @return An initialized XuniCalendarDaySlotLoadingEventArgs object or nil if the object couldn't be created.
 */
- (instancetype)initWithDate:(NSDate *)date isAdjacentDay:(BOOL)isAdjacentDay daySlot:(XuniCalendarDaySlotBase *)daySlot;

@end

/**
 *  XuniCalendarSelectionChangedEventArgs Class.
 *  Arguments for selectionChanged event.
 */
@interface XuniCalendarSelectionChangedEventArgs : XuniEventArgs

/**
 *  Gets the selected date.
 */
@property (readonly) XuniCalendarRange *selectedDates;

/**
 *  Initializes and returns a newly allocated XuniCalendarSelectionChangedEventArgs object.
 *
 *  @param selectedDates    The selected dates.
 *
 *  @return An initialized XuniCalendarSelectionChangedEventArgs object or nil if the object couldn't be created.
 */
- (instancetype)initWithSelectedDates:(XuniCalendarRange *)selectedDates;

@end

/**
 *  XuniCalendarMonthSlotLoadingEventArgs Class.
 *  Arguments for monthSlotLoading event.
 */
@interface XuniCalendarMonthSlotLoadingEventArgs : XuniEventArgs

/**
 *  Gets the month in the calendar.
 */
@property (readonly) NSUInteger month;

/**
 *  Gets or sets the visual element shown in the month slot.
 */
@property (nonatomic) XuniCalendarMonthSlotBase *monthSlot;

/**
 *  Initializes and returns a newly allocated XuniCalendarMonthSlotLoadingEventArgs object.
 *
 *  @param month            The month for the current month slot.
 *  @param monthSlot        Visual element that will be displayed in the month slot.
 *
 *  @return An initialized XuniCalendarMonthSlotLoadingEventArgs object or nil if the object couldn't be created.
 */
- (instancetype)initWithMonth:(NSUInteger)month monthSlot:(XuniCalendarMonthSlotBase *)monthSlot;

@end

/**
 *  XuniCalendarYearSlotLoadingEventArgs Class.
 *  Arguments for yearSlotLoading event.
 */
@interface XuniCalendarYearSlotLoadingEventArgs : XuniEventArgs

/**
 *  Gets the year in the calendar.
 */
@property (readonly) NSUInteger year;

/**
 *  Gets whether or not the year is an adjacent year in the calendar.
 */
@property (readonly) BOOL isAdjacentYear;

/**
 *  Gets or sets the visual element shown in the year slot.
 */
@property (nonatomic) XuniCalendarYearSlotBase *yearSlot;

/**
 *  Initializes and returns a newly allocated XuniCalendarYearSlotLoadingEventArgs object.
 *
 *  @param year                 The year for the current year slot.
 *  @param isAdjacentYear       Adjacent year flag.
 *  @param yearSlot             The visual element for year slot
 *
 *  @return An initialized XuniCalendarYearSlotLoadingEventArgs object or nil if the object couldn't be created.
 */
- (instancetype)initWithYear:(NSUInteger)year isAdjacentYear:(BOOL)isAdjacentYear yearSlot:(XuniCalendarYearSlotBase *)yearSlot;

@end

/**
 *  Arguments for HeaderLoading event.
 */
@interface XuniCalendarHeaderLoadingEventArgs : XuniEventArgs

/**
 *  Gets or sets the header text.
 */
@property (nonatomic) NSString *header;

/**
 *  Gets or sets a value indicating whether the calendar displays a month, year or decade view.
 */
@property (nonatomic) XuniCalendarViewMode viewMode;

/**
 *  Gets or sets the header date.
 */
@property (nonatomic) NSDate *date;

/**
 *  Initialize an instance for XuniCalendarHeaderLoadingEventArgs.
 *
 *  @param headerDate the header date.
 *  @param viewMode   the calendar view mode.
 *  @param headerText the header text.
 *
 *  @return an instance of XuniCalendarHeaderLoadingEventArgs.
 */
- (id)initWithDate:(NSDate *)headerDate viewMode:(XuniCalendarViewMode)viewMode  text:(NSString *)headerText;

@end


