//
//  XuniMaskedTextField.h
//  XuniInput
//
//  Copyright (c) GrapeCity, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreText/CoreText.h>
#import "XuniMaskedTextFieldDelegate.h"

@class XuniEvent;

IB_DESIGNABLE
@interface XuniMaskedTextField : UITextField

/**
 *  Gets or sets the delegate for handling notifications.
 */
@property (nonatomic, weak) id<XuniMaskedTextFieldDelegate> maskDelegate;

/**
 *  Gets or sets the mask used to validate input as the user types. 
 *  The mask must be a string composed of one or more of the masking elements.
 */
@property (nonatomic) IBInspectable NSString *mask;

/**
 *  Gets a boolean value that indicates whether the mask has been completely filled
 */
@property (nonatomic, readonly) IBInspectable BOOL maskFull;

/**
 *  Gets or sets the symbol used to show input positions in the control.
 */
@property (nonatomic) IBInspectable NSString *promptChar;

/**
 *  Gets or sets the raw value of the control (excluding prompt and mask literals).
 */
@property (nonatomic) IBInspectable NSString *value;

/**
 *  Gets or sets the padding of the control.
 */
@property (nonatomic) UIEdgeInsets padding;

/**
 *  Occurs when the text value changes.
 */
@property XuniEvent *textChanged;

/**
 *  Gets or sets the font of the placeHolder.
 */
@property UIFont *placeHolderFont;

/**
 *  Gets or sets the Color of the placeHolder.
 */
@property UIColor *placeHolderColor;

/**
 *  Get descriptor of the font.
 *
 *  @param attributes The font attributes.
 *
 *  @return Font descriptor.
 */
- (UIFontDescriptor *)getDecriptor:(NSMutableDictionary *)attributes;

@end
