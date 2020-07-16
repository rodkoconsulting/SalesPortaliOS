//
//  IAdjacentDaySlotTemplate.h
//  XuniCalendar
//
//  Copyright (c) GrapeCity, Inc. All rights reserved.
//

#ifndef IAdjacentDaySlotTemplate_h
#define IAdjacentDaySlotTemplate_h

/**
 *  IAdjacentDaySlotTemplate protocol.
 */
@protocol IAdjacentDaySlotTemplate

/**
 *  Get the custom adjacent day slot view.
 *
 *  @param date  The date.
 *  @param frame The frame of the custom adjacent day slot view.
 *
 *  @return The custom adjacent day slot view.
 */
- (UIView *)getView:(NSDate *)date frame:(CGRect)frame;

@end

#endif /* IAdjacentDaySlotTemplate_h */
