//
//  AutoCompleteDelegate.h
//  XuniInput
//
//  Copyright (c) GrapeCity, Inc. All rights reserved.
//

#ifndef AutoCompleteDelegate_h
#define AutoCompleteDelegate_h
#import "XuniComboBoxDelegate.h"

@class XuniAutoComplete;
@class XuniAutoCompleteFilteringEventArgs;
//@protocol XuniComboBoxDelegate;

/**
 *  Protocol XuniAutoCompleteDelegate.
 */
@protocol XuniAutoCompleteDelegate <XuniComboBoxDelegate>
@optional

/**
 *  Occurs when the value of selectedIndex changes
 *
 *  @param sender The XuniAutoComplete which the selectedIndex changes.
 */
//- (void)selectedIndexChanged:(XuniAutoComplete *)sender;

/**
 *  Occurs when the text value changes.
 *
 *  @param sender The XuniAutoComplete which the text value changes.
 */
//- (void)textChanged:(XuniAutoComplete *)sender;

/**
 *  Customize the cells of suggestionList.
 *
 *  @param cell The cell used to add customized views.
 */
- (void)customizeTheCellsOfSuggestionList:(UITableViewCell *)cell;

/**
 *  Occurs when the control is about to apply a filter to the list of items
 *
 *  @param sender The XuniAutoComplete.
 *  @param text   The text.
 */
- (void)filtering:(XuniAutoComplete *)sender eventArgs:(XuniAutoCompleteFilteringEventArgs*)eventArgs;

/**
 *  Get xamarin custom view with index.
 *
 *  @param index The item index.
 */
-(UIView *)getXamarinCustomView:(XuniAutoComplete *)sender WithIndex:(int)index;

@end

#endif /* AutoCompleteDelegate_h */
