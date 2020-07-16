//
//  XuniAutoComplete.h
//  XuniInput
//
//  Copyright (c) GrapeCity, Inc. All rights reserved.
//

#import "XuniComboBox.h"
#import "XuniAutoCompleteEnums.h"

@class XuniCollectionView;
@class XuniAutoCompleteDropdownView;
@class XuniAutoCompleteFilteringEventArgs;
@protocol XuniAutoCompleteDelegate;

@interface XuniAutoComplete : XuniComboBox

/**
 *  Gets or sets the delegate for handling notifications.
 */
//@property (nonatomic, weak) id<XuniAutoCompleteDelegate> delegate;

@property (nonatomic) XuniAutoCompleteFilteringEventArgs *filteringArgs;

/**
 *  Gets or sets the customized cell for tableView.
 */
@property (nonatomic) NSArray<UIView*> *customViews;

/**
 *  Gets or sets the matched text hightlighted background color.
 */
@property (nonatomic) IBInspectable UIColor *highlightedColor;

/**
 *  Gets or sets the filterString in the text field.
 */
@property (nonatomic) IBInspectable NSString *filterString;

/**
 *  Gets or sets the temporary source collection that contains the items to select from.
 */
@property (nonatomic) NSMutableArray *temporaryItemSource;

/**
 *  Gets or sets the filter of the list.
 */
@property (nonatomic) XuniAutoCompleteOperator operatorType;

/**
 *  Gets or sets the delay, in milliseconds, between when input occurs and when the search is performed.
 */
@property (nonatomic) IBInspectable double delay;

/**
 *  Gets or sets the maximum number of items to display in the drop-down list.
 */
@property (nonatomic) IBInspectable int maxItems;

/**
 *  Gets or sets the minimum input length to trigger autocomplete suggestions.
 */
@property (nonatomic) IBInspectable int minLength;

/**
 *  Gets or sets whether is custom filterig.
 */
@property (nonatomic) IBInspectable BOOL isCustomFiltering;

/**
 *  Refresh tableView itemSource.
 */
- (void)refreshTableViewItemSource;

/**
 *  Normalize cell text.
 *
 *  @param textLabel The textLabel.
 *  @param subString The subString of the textLabel text.
 *
 */
-(void)normalizeCellText:(UILabel *)textLabel WithSubstring:(NSString *)subString;

/**
 *  Hilighted substring.
 *
 *  @param subString The subString of the textLabel text.
 *  @param textLabel The textLabel.
 *
 */
- (void)highlightedSubstring:(NSString*)substring inFilterCellText:(UILabel *)textLabel;

@end
