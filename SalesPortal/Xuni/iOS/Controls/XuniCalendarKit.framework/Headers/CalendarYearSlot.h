//
//  CalendarYearSlot.h
//  XuniCalendar
//
//  Copyright (c) GrapeCity, Inc. All rights reserved.
//

/**
 * Base class for the year slots with XuniCalendar.
 */
@interface XuniCalendarYearSlotBase : UIView

@end

/**
 *  XuniCalendarYearSlot Class.
 *  Represents a default year slot view.
 */
@interface XuniCalendarYearSlot : XuniCalendarYearSlotBase

/**
 *  Gets or sets the year text displayed in the year slot.
 */
@property (nonatomic) NSString *yearText;

/**
 *  Gets or sets the color of the year text.
 */
@property (nonatomic) UIColor *yearTextColor;

/**
 *  Gets or sets the font for the year text.
 */
@property (nonatomic) UIFont *yearFont;

/**
 *  Gets or sets the padding of the content inside the year slot.
 */
@property (nonatomic) UIEdgeInsets padding;

/**
 *  Gets or sets the year horizontal options.
 */
@property (nonatomic) XuniHorizontalAlignment yearHorizontalAlignment;

/**
 *  Gets or sets the year vertical options.
 */
@property (nonatomic) XuniVerticalAlignment yearVerticalAlignment;

/**
 *  Set year slot frame.
 *
 *  @param frame The frame.
 */
- (void)setYearSlotFrame:(CGRect)frame;

@end
