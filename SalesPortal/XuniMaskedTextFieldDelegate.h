//
//  XuniMaskedTextFieldDelegate.h
//  XuniInput
//
//  Created by administrator on 16/7/12.
//  Copyright © 2016年 ComponentOne. All rights reserved.
//

#ifndef XuniMaskedTextFieldDelegate_h
#define XuniMaskedTextFieldDelegate_h

@class XuniMaskedTextField;


/**
 *  protocol XuniMaskedTextFieldDelegate.
 */
@protocol XuniMaskedTextFieldDelegate <NSObject>
@optional

/**
 *  Called when the control finished rendering.
 *
 *  @param sender The control which is rendered.
 */
- (void)rendered:(XuniMaskedTextField*)sender;

/**
 *  Occurs when the text value changes.
 *
 *  @param sender  The XuniMaskedTextField which the text value changes.
 *  @param oldText The old text value.
 *  @param newText The new text value.
 */
- (void)textChanged:(XuniMaskedTextField *)sender oldText:(NSString *)oldText newText:(NSString *)newText;

@end

#endif /* XuniMaskedTextFieldDelegate_h */
