//
//  XuniComboBox.h
//  XuniInput
//
//  Copyright (c) GrapeCity, Inc. All rights reserved.
//

#import "XuniDropDown.h"

@protocol XuniComboBoxDelegate;
@class XuniCollectionView;

/**
 *  XuniComboBox Class.
 */
IB_DESIGNABLE
@interface XuniComboBox : XuniDropDown

///**
// *  Gets or sets the delegate for handling notifications.
// */
//@property (nonatomic, weak) id<XuniComboBoxDelegate> delegate;

/**
 *  Gets or sets the source collection that contains the items to select from.
 */
@property (nonatomic) NSMutableArray *itemsSource;

/**
 *  Gets or sets the XuniCollectionView object used as the items source.
 */
@property (nonatomic) XuniCollectionView *collectionView;

/**
 *  Gets or sets whether the control should try to automatically complete entries using the list of items.
 */
@property (nonatomic) IBInspectable BOOL autoComplete;

/**
 *  Gets or sets the name of the property to use as the visual representation of the items.
 */
@property (nonatomic) IBInspectable NSString *displayMemberPath;

/**
 *  Gets or sets the value that enables or disables editing of the text in the control.
 */
@property (nonatomic) IBInspectable BOOL isEditable;

/**
 *  Gets or sets the string shown as a hint when the control is empty.
 */
@property (nonatomic) IBInspectable NSString *placeholder;

/**
 *  Gets or sets the selected background color.
 */
@property (nonatomic) IBInspectable UIColor *selectedBackgroundColor;

/**
 *  Gets or sets the index of the selected item.
 *  It returns -1 if there is no selection, or the selection doesn’t match any item in the source collection.
 */
@property (nonatomic) NSUInteger selectedIndex;

/**
 *  Gets or sets the current selected item.
 */
@property (nonatomic) NSObject *selectedItem;

/**
 *  Gets or sets the value of the currently selected item using SelectedValuePath.
 */
@property (nonatomic) NSObject *selectedValue;

/**
 *  Gets or sets the path that is used to get the value from the selected item.
 */
@property (nonatomic) IBInspectable NSString *selectedValuePath;

/**
 *  Gets or sets the text of the control.
 */
@property (nonatomic) IBInspectable NSString *text;

/**
 *  Gets or sets the dropdown table view.
 */
@property (nonatomic, readonly) UITableView *tableView;

/**
 *  Gets or sets the text color.
 */
@property (nonatomic) UIColor *textColor;

/**
 *  Gets or sets the text font.
 */
@property (nonatomic) UIFont *textFont;

/**
 *  Gets or sets the alignment of input text.
 */
@property(nonatomic) NSTextAlignment textAlignment;

/**
 *  Occurs when the value of selectedIndex changes.
 */
@property XuniEvent *selectedIndexChanged;

/**
 *  Occurs when the text value changes.
 */
@property XuniEvent *textChanged;

/**
 *  Occurs when the dropdown item is loading.
 */
@property XuniEvent *dropDownItemLoading;

/**
 *  Gets the display text for the item at the given index.
 *
 *  @param index The item index.
 *
 *  @return The display text.
 */
- (NSString *)getDisplayText:(NSUInteger)index;

/**
 *  Gets the index of the first item that matches the given string.
 *
 *  @param text      The given string.
 *  @param fullMatch Is need full match when searching.
 *
 */
- (NSUInteger)indexOf:(NSString *)text fullMatch:(BOOL)fullMatch;

/**
 *  Sets the focus to the control and selects all of its contents.
 */
- (void)selectAll;

/**
 *  Get a descriptor of font.
 *
 *  @param attributes the font attributes.
 *
 *  @return a descriptor.
 */
- (UIFontDescriptor*)getDescriptor:(NSMutableDictionary*)attributes;

@end
