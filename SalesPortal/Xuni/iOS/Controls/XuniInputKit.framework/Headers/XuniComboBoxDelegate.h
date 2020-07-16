//
//  XuniComboBoxDelegate.h
//  XuniInput
//
//  Copyright (c) GrapeCity, Inc. All rights reserved.
//

#ifndef XuniComboBoxDelegate_h
#define XuniComboBoxDelegate_h

@class XuniComboBox;
@class XuniDropDownItemLoadingEventArgs;
@protocol XuniDropDownDelegate;

/**
 *  Protocol XuniComboBoxDelegate.
 */
@protocol XuniComboBoxDelegate <XuniDropDownDelegate>
@optional

/**
 *  Occurs when the value of selectedIndex changes
 *
 *  @param sender The XuniComboBox which the selectedIndex changes.
 */
- (void)selectedIndexChanged:(XuniComboBox *)sender;

/**
 *  Occurs when the text value changes.
 *
 *  @param sender The XuniComboBox which the text value changes.
 */
- (void)textChanged:(XuniComboBox *)sender;

/**
 *  Occurs when the dropdown item is loading.
 *
 *  @param sender The XuniComboBox which the dropdown item is loading.
 *  @param args   The event arguments.
 *
 *  @return Return the customized view which display within the dropdown item.
 */
- (UIView *)dropDownItemLoading:(XuniComboBox *)sender args:(XuniDropDownItemLoadingEventArgs *)args;

@end

#endif /* XuniComboBoxDelegate_h */
