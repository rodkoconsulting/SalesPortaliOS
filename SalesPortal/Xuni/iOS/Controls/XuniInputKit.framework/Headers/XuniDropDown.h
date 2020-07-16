//
//  XuniDropDown.h
//  DropDown
//
//  Copyright (c) GrapeCity, Inc. All rights reserved.
//

#import "XuniDropDownEnums.h"
#import "DropDownDelegate.h"

@class XuniEvent;
@class XuniDropDownButton;
@class XuniDropDownHeaderView;
@class XuniDropDownButton;
@class XuniDropDownView;
@class XuniDropDownOpenChangedEventArgs;

IB_DESIGNABLE
@interface XuniDropDown : UIView

/**
 *  Gets or sets the delegate for handling notifications(test comment).
 */
@property (nonatomic, weak) id<XuniDropDownDelegate> delegate;

/**
 *  Gets or sets whether is Xamarin Forms.
 */
@property(nonatomic) BOOL isXf;

/**
 *  Gets or sets dropdown background view.
 */
@property(nonatomic) UIView *dropDownBackView;

/**
 *  Gets or sets the header of this control.
 */
@property(nonatomic) UIView *header;

/**
 *  Gets or sets the header text of this control.
 */
@property(nonatomic) IBInspectable NSString *headerText;

/**
 *  Gets or sets the width of this control.
 */
@property(nonatomic) double width;

/**
 *  Gets or sets the height of this control.
 */
@property(nonatomic) double height;

/***********************************DropDownHeader************************/
/**
 *  Gets or sets the header of this control.
 */
@property(nonatomic) XuniDropDownBehavior dropDownBehavior;

/**
 *  Gets or sets the background color for the header.
 */
@property(nonatomic) IBInspectable UIColor *headerBackgroundColor;

/**
 *  Gets or sets the border color for the header.
 */
@property(nonatomic) IBInspectable UIColor *headerBorderColor;

/**
 *  Gets or sets the border thickness for the header.
 */
@property(nonatomic) IBInspectable double headerBorderWidth;

/***********************************DropDownView************************/
/**
 *  Gets or sets a value that indicates whether the dropdown is currently visible.
 */
@property(nonatomic) UIView *dropDownView;

/**
 *  Gets or sets the height of the drop-down box.
 */
@property(nonatomic) IBInspectable double dropDownHeight;

/**
 *  Gets or sets the width of the drop-down box.
 */
@property(nonatomic) IBInspectable double dropDownWidth;

/**
 *  Gets or sets the color of the drop-down.
 */
@property(nonatomic) IBInspectable UIColor *dropDownBackgroundColor;

/**
 *  Gets or sets the color of the drop-down border.
 */
@property(nonatomic) IBInspectable UIColor *dropDownBorderColor;

/**
 *  Gets or sets the width of the drop-down border.
 */
@property(nonatomic) IBInspectable double dropDownBorderWidth;

/**
 *  Gets or sets auto closes the drop when the user hits outside it.
 */
@property(nonatomic) IBInspectable BOOL autoClose;

/**
 *  Gets or sets a value that indicates whether the dropdown is currently visible.
 */
@property(nonatomic) BOOL isDropDownOpen;

/**
 *  Gets or sets whether the control is animated.
 */
@property(nonatomic) IBInspectable BOOL isAnimated;

/**
 *  Gets or sets the animation duration.
 */
@property(nonatomic) IBInspectable double duration;

/**
 *  Get or sets the expand direction of the control drop-down box.
 */
@property(nonatomic) XuniDropDownDirection dropDownDirection;

/**
 *  Gets or sets the maximum length constraint of the drop-down box.
 */
@property(nonatomic) IBInspectable double maxDropDownHeight;

/**
 *  Gets or sets the minimum height constraint of the drop-down box.
 */
@property(nonatomic) IBInspectable double minDropDownHeight;

/**
 *  Gets or sets the maximum width constraint of the drop-down box.
 */
//@property(nonatomic) double maxDropDownWidth;

/**
 *  Gets or sets the minimum width constraint of the drop-down box.
 */
//@property(nonatomic) double minDropDownWidth;


/**************************DropDownButton*******************************/
/**
 *  Gets or sets the header of this control.
 */
@property(nonatomic) XuniDropDownButton *button;

/**
 *  Gets or sets a value that indicates whether the control should display a dropdown button.
 */
@property(nonatomic) IBInspectable BOOL showButton;

/**
 *  Gets or sets the color of the button content.
 */
@property(nonatomic) IBInspectable UIColor *buttonColor;

/**
 *  Gets or sets event raised when the IsDropDownOpen property has changed.
 */
@property(nonatomic) XuniEvent *isDropDownOpenChanged;

/**
 *  Gets or sets event event raised before the IsDropDownOpen property changes.
 */
@property(nonatomic) XuniEvent *isDropDownOpenChanging;

/**
 *  Gets or sets event event raised before the IsDropDownOpen property changes.
 */
@property(nonatomic) XuniDropDownMode dropDownMode;

/**
 *  Refresh the drop down.
 */
- (void)refresh;

// Internal methods
/**
 *  Initialize some properties of XuniDropDown.
 */
- (void)initInternals;

/**
 *  Initializes and returns a newly allocated XuniDropDown object with the specified frame rectangle.
 *
 *  @param frame The frame rectangle for the XuniDropDown, measured in points.
 *
 *  @return An initialized XuniDropDown object or nil if the object couldn't be created.
 */
- (instancetype)initWithFrame:(CGRect)frame;

/**
 *  For XF clear.
 */
-(void)clearDropDownView;

/**
 *  For XF clear.
 */
-(void)clearDropDownHeader;

@end
