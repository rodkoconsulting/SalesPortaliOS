//
//  XuniView.h
//  XuniCore
//
//  Copyright (c) GrapeCity, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XuniView;
@class XuniPoint;

/**
 *  protocol XuniCalendarDelegate.
 */
@protocol XuniViewDelegate <NSObject>
@optional

/**
 *  Called when the control is rendering.
 *
 *  @param sender The control which is rendering.
 */
- (void)rendering:(XuniView *)sender;

/**
 *  Called when the control finished rendering.
 *
 *  @param sender The control which is rendered.
 */
- (void)rendered:(XuniView *)sender;

/**
 *  Called when the control is tapped.
 *
 *  @param sender The control which is tapped.
 *  @param point  The tapped point.
 *
 *  @return Return a boolean value.
 */
- (BOOL)tapped:(XuniView *)sender point:(XuniPoint *)point;

@end


/**
 *  Class XuniCalendar.
 */
@interface XuniView : UIView

/**
 *  Responded when the user changes the preferred content size setting.
 */
- (void)respondToSizeChanged;

/**
 *  Responded when the orientation of the device changes.
 */
- (void)respondToOrientationChanged;

/**
 *  Get the current control view as a image.
 *
 *  @return Data of the image.
 */
- (NSData *)getImage;

@end
