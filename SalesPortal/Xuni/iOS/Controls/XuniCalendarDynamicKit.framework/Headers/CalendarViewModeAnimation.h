//
//  CalendarViewModeAnimation.h
//  XuniCalendar
//
//  Copyright (c) GrapeCity, Inc. All rights reserved.
//

#ifndef XuniCoreKit_h
#import "XuniCore/Animation.h"
#endif

/**
*  Class that holds information about the calendar view mode animation.
*/
@interface XuniCalendarViewModeAnimation : XuniAnimation

/**
 *  Gets or sets the kind of animation when changing the calendar view mode.
 */
@property (nonatomic) XuniCalendarViewAnimationMode animationMode;

/**
 *  Gets or sets the scale factor used in the animation.
 */
@property (nonatomic) double scaleFactor;

/**
 *  Initializes and returns a newly allocated XuniCalendarViewModeAnimation object.
 *
 *  @return An initialized XuniCalendarViewModeAnimation object or nil if the object couldn't be created.
 */
- (instancetype)init;

@end
