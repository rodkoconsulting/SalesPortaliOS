//
//  CalendarImageDaySlot.h
//  XuniCalendar
//
//  Copyright (c) GrapeCity, Inc. All rights reserved.
//

#import "CalendarDaySlot.h"

/**
 *  XuniCalendarImageDaySlot Class.
 *  Represents a day slot containing an image.
 */
@interface XuniCalendarImageDaySlot : XuniCalendarDaySlot

/**
 *  Gets or sets the image source displayed in the day slot.
 */
@property (nonatomic) UIImage *imageSource;

/**
 *  Gets or sets the rectangle which display image inside.
 */
@property (nonatomic) CGRect imageRect;

/**
 *  Gets or sets the aspect of the image.
 */
@property (nonatomic) XuniImageAspect imageAspect;

/**
 *  Initializes and returns a newly allocated XuniCalendarImageDaySlot object with the specified calendar and frame rectangle.
 *
 *  @param calendar The XuniCalendar object.
 *  @param frame    The frame rectangle for the XuniCalendarImageDaySlot, measured in points.
 *
 *  @return An initialized XuniCalendarImageDaySlot object or nil if the object couldn't be created.
 */
- (id)initWithCalendar:(XuniCalendar *)calendar frame:(CGRect)frame;

@end
