//
//  IDayOfWeekSlotTemplate.h
//  XuniCalendar
//
//  Copyright (c) GrapeCity, Inc. All rights reserved.
//

#ifndef IDayOfWeekSlotTemplate_h
#define IDayOfWeekSlotTemplate_h

/**
 *  IDayOfWeekSlotTemplate protocol.
 */
@protocol IDayOfWeekSlotTemplate

/**
 *  Get the custom day of week slot view.
 *
 *  @param dayOfWeek The day of week.
 *  @param frame     The frame of the custom day of week slot view.
 *
 *  @return The custom day of week slot view.
 */
- (UIView *)getView:(XuniDayOfWeek)dayOfWeek frame:(CGRect)frame;

@end

#endif /* IDayOfWeekSlotTemplate_h */
