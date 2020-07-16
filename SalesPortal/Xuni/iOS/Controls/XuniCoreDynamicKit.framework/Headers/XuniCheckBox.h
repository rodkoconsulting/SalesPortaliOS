//
//  XuniCheckbox.h
//  XuniCore
//
//  Copyright © 2016 C1Marketing. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  The XuniCheckBox control provides standard check box functionality for iOS
 */
IB_DESIGNABLE
@interface XuniCheckBox : UIButton <UIGestureRecognizerDelegate>

/**
 *  Gets or sets the state of the checkbox
 */
@property (nonatomic) IBInspectable BOOL isChecked;

/**
 *  Enables or disables user interaction
 */
@property IBInspectable BOOL isReadOnly;

/**
 *  Gets or sets the size of checkBox
 */
@property (nonatomic) IBInspectable int intrinsicSize;

@end