//
//  CalendarMonthSlot.h
//  XuniCalendar
//
//  Copyright (c) GrapeCity, Inc. All rights reserved.
//

#ifndef XuniCoreKit_h
#import "XuniCore/Drawing.h"
#endif

@class XuniCalendar;

/**
 * Base class for the month slots with XuniCalendar.
 */
@interface XuniCalendarMonthSlotBase : UIView

@end

/**
 *  XuniCalendarMonthSlot Class.
 *  Represents a default month slot view.
 */
@interface XuniCalendarMonthSlot : XuniCalendarMonthSlotBase

/**
 *  Gets or sets the month text displayed in the month slot.
 */
@property (nonatomic) NSString *monthText;

/**
 *  Gets or sets the color of the month text.
 */
@property (nonatomic) UIColor *monthTextColor;

/**
 *  Gets or sets the font for the month text.
 */
@property (nonatomic) UIFont *monthFont;

/**
 *  Gets or sets the padding of the content inside the month slot.
 */
@property (nonatomic) UIEdgeInsets padding;

/**
 *  Gets or sets the month horizontal options.
 */
@property (nonatomic) XuniHorizontalAlignment monthHorizontalAlignment;

/**
 *  Gets or sets the month vertical options.
 */
@property (nonatomic) XuniVerticalAlignment monthVerticalAlignment;

/**
 *  Set month slot frame.
 *
 *  @param frame The frame.
 */
- (void)setMonthSlotFrame:(CGRect)frame;

@end
