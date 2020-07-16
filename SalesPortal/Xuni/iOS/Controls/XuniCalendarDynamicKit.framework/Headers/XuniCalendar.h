//
//  XuniCalendar.h
//  XuniCalendar
//
//  Copyright (c) GrapeCity, Inc. All rights reserved.
//

#import "XuniCalendarEnums.h"
#import <CoreText/CoreText.h>

#ifndef XUNI_INTERNAL_DYNAMIC_BUILD

#ifndef XuniCoreKit_h
#import "XuniCore/XuniView.h"
#endif

#else
#import "XuniCoreDynamicKit/XuniCoreDynamicKit.h"

#endif

@class XuniEvent;
@protocol IXuniValueFormatter;
@protocol XuniCalendarDelegate;
@protocol IDaySlotTemplate;
@protocol IDayOfWeekSlotTemplate;
@protocol IAdjacentDaySlotTemplate;
@class XuniCalendarDaySlot;
@class XuniCalendarRange;
@class XuniAnimation;
@class XuniCalendarViewModeAnimation;


/**
 *  XuniCalendar Class.
 */
IB_DESIGNABLE
@interface XuniCalendar : XuniView

// Properties about calendar.
//*******************************

/**
 *  Gets or sets the delegate for handling notifications.
 */
@property (nonatomic, weak) id<XuniCalendarDelegate> delegate;

/**
 *  Gets or sets the size of the calendar on Xamarin Form.
 */
@property (nonatomic) CGSize xfCalendarSize;

/**
 *  Gets or sets the color of the text within the calendar(test only).
 */
@property (nonatomic) IBInspectable UIColor *textColor;

/**
 *  Gets or sets the background color of the calendar.
 */
@property (nonatomic) IBInspectable UIColor *backgroundColor;

/**
 *  Gets or sets the color of the calendar's border.
 */
@property (nonatomic) IBInspectable UIColor *borderColor;

/**
 *  Gets or sets the width of the calendar's border.
 */
@property (nonatomic) IBInspectable double borderWidth;

/**
 *  Gets or sets a value indicating whether the calendar displays a month, year or decade view.
 */
@property (nonatomic) XuniCalendarViewMode viewMode;

/**
 *  Gets or sets a value specifying the currently displayed date of the year.
 */
@property (nonatomic) NSDate *displayDate;

/**
 *  Gets or sets the latest date that the user can select in the calendar.
 */
@property (nonatomic) NSDate *maxDate;

/**
 *  Gets or sets the earliest date that the user can select in the calendar.
 */
@property (nonatomic) NSDate *minDate;

/**
 *  Gets or sets a value that represents the first day of the week, the one displayed in the first column of the calendar.
 */
@property (nonatomic) XuniDayOfWeek firstDayOfWeek;

/**
 *  Gets or sets the font for the calendar.
 */
@property (nonatomic) UIFont *calendarFont;

/**
 *  Gets or sets whether the control is animated during navigation.
 */
@property (nonatomic) IBInspectable BOOL isAnimated;

/**
 *  Gets or sets whether the control is enabled.
 */
@property (nonatomic) IBInspectable BOOL isEnabled;

/**
 *  Gets or sets the maximum number of days that can be selected.
 */
@property (nonatomic) IBInspectable int maxSelectionCount;

/**
 *  Gets or sets an object containing the animation settings that will be applied when navigating backwards or forward.
 */
@property (nonatomic) XuniAnimation *navigateAnimation;

/**
 *  Gets or sets an object containing the animation settings that will be applied when changing the viewMode.
 */
@property (nonatomic) XuniCalendarViewModeAnimation *viewModeAnimation;

/**
 *  Gets or sets a value indicating which orientation the calendar navigates.
 */
@property (nonatomic) XuniCalendarOrientation orientation;

/**
 *  Gets or sets a value indicating whether the control displays the default navigation buttons.
 */
@property (nonatomic) IBInspectable BOOL showNavigationButtons;

/**
 *  Gets or sets a value indicating whether the control displays the header area with the current month and navigation buttons.
 */
@property (nonatomic) IBInspectable BOOL showHeader;

/**
 *  Gets or sets the color of the disabled text in the calendar.
 */
@property (nonatomic) IBInspectable UIColor *disabledTextColor;


// Properties about adjacent day.
//*******************************

/**
 *  Gets or sets a data template that defines the UI representation for a single adjacent day on the calendar.
 */
@property (nonatomic) id<IAdjacentDaySlotTemplate> adjacentDaySlotTemplate;

/**
 *  Gets or sets the color of the adjacent days text.
 */
@property (nonatomic) IBInspectable UIColor *adjacentDayTextColor;


// Properties about day.
//*******************************

/**
 *  Gets or sets the color used for the border between day slots.
 */
@property (nonatomic) IBInspectable UIColor *dayBorderColor;

/**
 *  Gets or sets the border thickness between day slots.
 */
@property (nonatomic) IBInspectable double dayBorderWidth;

/**
 *  Gets or sets a data template that defines the UI representation for a single day of the month.
 */
@property (nonatomic) id<IDaySlotTemplate> daySlotTemplate;


// Properties about today.
//*******************************

/**
 *  Gets or sets the color used to highlight the background of the today day slot.
 */
@property (nonatomic) IBInspectable UIColor *todayBackgroundColor;

/**
 *  Gets or sets the color for the text of the today day slot.
 */
@property (nonatomic) IBInspectable UIColor *todayTextColor;

/**
 *  Gets or sets the font for today.
 */
@property (nonatomic) UIFont *todayFont;


// Properties about week.
//*******************************

/**
 *  Gets or sets the background color for the day of week slots.
 */
@property (nonatomic) IBInspectable UIColor *dayOfWeekBackgroundColor;

/**
 *  Gets or sets the font for the day of weeks.
 */
@property (nonatomic) UIFont *dayOfWeekFont;

/**
 *  Gets or sets the format which is used for representing day of week names.
 */
@property (nonatomic) XuniDayOfWeekFormat dayOfWeekFormat;

/**
 *  Gets or sets a data template that defines the UI representation for a day of the week.
 */
@property (nonatomic) id<IDayOfWeekSlotTemplate> dayOfWeekSlotTemplate;

/**
 *  Gets or sets the color of the text displayed in the day of week slots.
 */
@property (nonatomic) IBInspectable UIColor *dayOfWeekTextColor;


// Properties about header.
//*******************************

/**
 *  Gets or sets the background color for the header.
 */
@property (nonatomic) IBInspectable UIColor *headerBackgroundColor;

/**
 *  Gets or sets the font for the header.
 */
@property (nonatomic) UIFont *headerFont;

/**
 *  Gets or sets the color for the header text.
 */
@property (nonatomic) IBInspectable UIColor *headerTextColor;

/**
 *  Gets or sets the month format for the header text.
 */
@property (nonatomic) IBInspectable NSString * headerMonthFormat;

/**
 *  Gets or sets the value format.
 */
@property (nonatomic) NSObject<IXuniValueFormatter> *valueFormatter;

/**
 *  Gets or sets the headerLoading event.
 */
@property (nonatomic) XuniEvent *headerLoading;

// Properties about selection.
//*******************************

/**
 *  Gets or sets the currently selected date.
 */
@property (nonatomic) NSDate *selectedDate;

/**
 *  Gets or sets the list of selected dates.
 */
@property (nonatomic) XuniCalendarRange *selectedDates;

/**
 *  Gets or sets the color used to highlight selected dates.
 */
@property (nonatomic) IBInspectable UIColor *selectionBackgroundColor;

/**
 *  Gets or sets the color for selected date text.
 */
@property (nonatomic) IBInspectable UIColor *selectionTextColor;

/**
 *  Get descriptor of the font.
 *
 *  @param attributes The font attributes.
 *
 *  @return Font descriptor.
 */
- (UIFontDescriptor *)getDecriptor:(NSMutableDictionary *)attributes;

/**
 *  Get image form url.
 *
 *  @param urlString The url string.
 *
 *  @return UIImage.
 */
- (UIImage *)getImage:(NSString *)urlString;

/**
 *  Refresh the calendar control.
 */
- (void)refresh;

/**
 *  Changes the view mode asynchronously performing an animation.
 *
 *  @param mode The view mode.
 *  @param date The display date.
 *
 */
- (void)changeViewModeAsync:(XuniCalendarViewMode)mode date:(NSDate *)date;

/**
 *  Navigates the calendar control forward.
 */
- (void)goForwardAsync;

/**
 *  Navigates the calendar control backward.
 */
- (void)goBackwardAsync;

@end
