//
//  XuniCalendarEnums.h
//  XuniCalendar
//
//  Copyright (c) GrapeCity, Inc. All rights reserved.
//

#ifndef XuniCalendarEnums_h
#define XuniCalendarEnums_h

/**
 *  Specifies the display format of day of week.
 */
typedef NS_ENUM(NSInteger, XuniDayOfWeekFormat) {
    /**
     *  XuniDayOfWeekFormatD
     */
    XuniDayOfWeekFormatD,
    /**
     *  XuniDayOfWeekFormatDDD
     */
    XuniDayOfWeekFormatDDD,
    /**
     *  XuniDayOfWeekFormatDDDD
     */
    XuniDayOfWeekFormatDDDD
};

/**
 *  Specifies the different display modes.
 */
typedef NS_ENUM(NSInteger, XuniCalendarViewMode) {
    /**
     *  XuniCalendarViewModeMonth
     */
    XuniCalendarViewModeMonth,
    /**
     *  XuniCalendarViewModeYear
     */
    XuniCalendarViewModeYear,
    /**
     *  XuniCalendarViewModeDecade
     */
    XuniCalendarViewModeDecade
};

/**
 *  Specifies the day of the week.
 */
typedef NS_ENUM(NSInteger, XuniDayOfWeek) {
    /**
     *  XuniDayOfWeekNone
     */
    XuniDayOfWeekNone,
    /**
     *  XuniDayOfWeekSunday
     */
    XuniDayOfWeekSunday,
    /**
     *  XuniDayOfWeekMonday
     */
    XuniDayOfWeekMonday,
    /**
     *  XuniDayOfWeekTuesday
     */
    XuniDayOfWeekTuesday,
    /**
     *  XuniDayOfWeekTuesday
     */
    XuniDayOfWeekWednesday,
    /**
     *  XuniDayOfWeekThursday
     */
    XuniDayOfWeekThursday,
    /**
     *  XuniDayOfWeekFriday
     */
    XuniDayOfWeekFriday,
    /**
     *  XuniDayOfWeekSaturday
     */
    XuniDayOfWeekSaturday
};

/**
 *  Specifies the calendar navigation orientation.
 */
typedef NS_ENUM(NSInteger, XuniCalendarOrientation) {
    /**
     *  XuniCalendarOrientationHorizontal
     */
    XuniCalendarOrientationHorizontal,
    /**
     *  XuniCalendarOrientationVertical
     */
    XuniCalendarOrientationVertical
};

/**
 *  Specifies the animation mode when changing the calendar view mode.
 */
typedef NS_ENUM(NSInteger, XuniCalendarViewAnimationMode) {
    /**
     *  The animation will bring the view backwards or forwards depending on which view is being set.
     */
    XuniCalendarViewAnimationModeZoom,
    /**
     *  The animation will zoom out the current view and zoom in the new one.
     */
    XuniCalendarViewAnimationModeZoomOutIn
};

/**
 *  Specifies the different display modes.
 */
typedef NS_ENUM(NSInteger, XuniDaySlotState) {
    /**
     *  XuniDaySlotStateNormal
     */
    XuniDaySlotStateNormal,
    /**
     *  XuniDaySlotStateToday
     */
    XuniDaySlotStateToday,
    /**
     *  XuniDaySlotStateAdjacent
     */
    XuniDaySlotStateAdjacent,
    /**
     *  XuniDaySlotStateSelected
     */
    XuniDaySlotStateSelected,
    /**
     *  XuniDaySlotStateDisabled
     */
    XuniDaySlotStateDisabled
};

/**
 *  Specifies the image aspect.
 */
typedef NS_ENUM(NSInteger, XuniImageAspect) {
    /**
     *  XuniImageAspectFit
     */
    XuniImageAspectFit,
    /**
     *  XuniImageAspectFill
     */
    XuniImageAspectFill,
    /**
     *  XuniImageFill
     */
    XuniImageFill
};

#endif /* XuniCalendarEnums_h */
