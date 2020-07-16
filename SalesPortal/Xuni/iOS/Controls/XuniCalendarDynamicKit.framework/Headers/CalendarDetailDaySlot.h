//
//  CalendarDetailDaySlot.h
//  XuniCalendar
//
//  Copyright (c) GrapeCity, Inc. All rights reserved.
//

#import "CalendarDaySlot.h"

/**
 *  XuniCalendarDetailDaySlot Class.
 *  Represents a day slot containing secondary text.
 */
@interface XuniCalendarDetailDaySlot : XuniCalendarDaySlot

/**
 *  Gets or sets the detail text displayed in the day slot.
 */
@property (nonatomic) NSString *detailText;

/**
 *  Gets or sets the rectangle which display detail text inside.
 */
@property (nonatomic) CGRect detailTextRect;

/**
 *  Gets or sets the detail text color displayed in the day slot.
 */
@property (nonatomic) UIColor *detailTextColor;

/**
 *  Gets or sets the detail font.
 */
@property (nonatomic) UIFont *detailFont;

/**
 *  Initializes and returns a newly allocated XuniCalendarDetailDaySlot object with the specified calendar and frame rectangle.
 *
 *  @param calendar The XuniCalendar object.
 *  @param frame    The frame rectangle for the XuniCalendarDetailDaySlot, measured in points.
 *
 *  @return An initialized XuniCalendarDetailDaySlot object or nil if the object couldn't be created.
 */
- (id)initWithCalendar:(XuniCalendar *)calendar frame:(CGRect)frame;

@end
