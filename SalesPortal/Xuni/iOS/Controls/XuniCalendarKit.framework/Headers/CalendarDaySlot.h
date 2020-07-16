//
//  CalendarDaySlot.h
//  XuniCalendar
//
//  Copyright (c) GrapeCity, Inc. All rights reserved.
//

#ifndef XUNI_INTERNAL_DYNAMIC_BUILD

#ifndef XuniCoreKit_h
#import "XuniCore/Drawing.h"
#endif

#else
#import "XuniCoreDynamicKit/XuniCoreDynamicKit.h"
#endif

#import "CalendarDaySlotBase.h"

@class XuniCalendar;

/**
 *  XuniCalendarDaySlot Class.
 *  Represents a default day slot view.
 */
@interface XuniCalendarDaySlot : XuniCalendarDaySlotBase

/**
 *  Gets or sets the day text displayed in the day slot.
 */
@property (nonatomic) NSString *dayText;

/**
 *  Gets or sets the rectangle which display day text inside.
 */
@property (nonatomic) CGRect dayTextRect;

/**
 *  Gets or sets the color of the day text.
 */
@property (nonatomic) UIColor *dayTextColor;

/**
 *  Gets or sets the font for the day text.
 */
@property (nonatomic) UIFont *dayFont;

/**
 *  Gets or sets the padding of the content inside the day slot.
 */
@property (nonatomic) double padding;

/**
 *  Gets or sets the day horizontal options.
 */
@property (nonatomic) XuniHorizontalAlignment dayHorizontalAlignment;

/**
 *  Gets or sets the day vertical options.
 */
@property (nonatomic) XuniVerticalAlignment dayVerticalAlignment;

/**
 *  Initializes and returns a newly allocated XuniCalendarDaySlot object with the specified calendar and frame rectangle.
 *
 *  @param calendar The XuniCalendar object.
 *  @param frame    The frame rectangle for the XuniCalendarDaySlot, measured in points.
 *
 *  @return An initialized XuniCalendarDaySlot object or nil if the object couldn't be created.
 */
- (id)initWithCalendar:(XuniCalendar *)calendar frame:(CGRect)frame;

@end
