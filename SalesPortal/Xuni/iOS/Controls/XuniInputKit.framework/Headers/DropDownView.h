//
//  DropDownView.h
//  DropDown
//
//  Copyright (c) GrapeCity, Inc. All rights reserved.
//

#import "XuniDropDownEnums.h"

@interface XuniDropDownView : UIView

/**
 *  Gets or sets the dropDown.
 */
@property (nonatomic) XuniDropDown *xuniDropDown;

/**
 *  Gets or sets the width of the drop-down box.
 */
@property(nonatomic) double width;

/**
 *  Gets or sets auto closes the drop when the user hits outside it.
 */
@property(nonatomic) BOOL autoClose;

/**
 *  Gets or sets a value that indicates whether the dropdown is currently visible.
 */
@property(nonatomic) BOOL isDropDownOpen;

/**
 *  Get or sets the expand direction of the control drop-down box.
 */
@property(nonatomic) XuniDropDownDirection dropDownDirection;

/**
 *  Gets or sets the maximum length constraint of the drop-down box.
 */
@property(nonatomic) double maxHeight;

/**
 *  Gets or sets the minimum height constraint of the drop-down box.
 */
@property(nonatomic) double minHeight;

/**
 *  Gets or sets the maximum width constraint of the drop-down box.
 */
@property(nonatomic) double maxWidth;

/**
 *  Gets or sets the minimum width constraint of the drop-down box.
 */
@property(nonatomic) double minWidth;

/**
 *  Sets the drop-down view height.
 *
 *  @param height the dropdown height.
 *
 */
- (void)setDropDownHeight:(double)height;

/**
 *  Sets the drop-down view width.
 *
 *  @param height the dropdown width.
 *
 */
- (void)setDropDownWidth:(double)width;

/**
 *  Refresh the drop down view.
 */
- (void)refresh;

@end
