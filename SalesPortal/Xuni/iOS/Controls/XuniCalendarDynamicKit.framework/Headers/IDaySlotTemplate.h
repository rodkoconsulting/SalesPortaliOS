//
//  IDaySlotTemplate.h
//  XuniCalendar
//
//  Copyright (c) GrapeCity, Inc. All rights reserved.
//

#ifndef IDaySlotTemplate_h
#define IDaySlotTemplate_h

/**
 *  IDaySlotTemplate protocol.
 */
@protocol IDaySlotTemplate

/**
 *  Get the custom day slot view.
 *
 *  @param date  The date.
 *  @param frame The frame of the custom day slot view.
 *
 *  @return The custom day slot view.
 */
- (UIView *)getView:(NSDate *)date frame:(CGRect)frame;

@end

#endif /* IDaySlotTemplate_h */
