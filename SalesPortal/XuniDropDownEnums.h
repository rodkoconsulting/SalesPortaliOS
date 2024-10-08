//
//  XuniDropDownEnums.h
//  DropDown
//
//  Copyright (c) GrapeCity, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#ifndef XuniDropDownEnums_h
#define XuniDropDownEnums_h

@class XuniDropDown;

/**
 *  Specifies the calendar navigation orientation.
 */
typedef NS_ENUM(NSInteger, XuniDropDownDirection) {
    /**
     *  Tries to open the drop-down above the header. If it’s not possible it tries to open below.
     */
    XuniDropDownDirectionAboveOrBelow,
    /**
     *  Tries to open the drop-down below the header. If it’s not possible it tries to open above. (default value)
     */
    XuniDropDownDirectionBelowOrAbove, 
    /**
     *  Forces the drop-down to open above the header.
     */
    XuniDropDownDirectionForceAbove,
    /**
     *  Forces the drop-down to open below the header.
     */
    XuniDropDownDirectionForceBelow
};

/**
 *  Specifies the dropdown behavior
 */
typedef NS_ENUM(NSInteger, XuniDropDownBehavior) {
    /**
     *  The drop-down appears when the user taps the button.
     */
    XuniDropDownBehaviorButtonTap,
    /**
     *  The drop-down appears when the user taps any part of the header.
     */
    XuniDropDownBehaviorHeaderTap
};

/**
 *  Specifies the mode that the DropDown uses to display the DropDownView
 */
typedef NS_ENUM(NSInteger, XuniDropDownMode) {
    /**
     *  DropDownView is displayed directly below DropDown Field.
     */
    XuniDropDownModeDefault,
    /**
     *  DropDownView is displayed in separate FullScreen page (similar to navigationpage) where user can select from list or navigate backwards by hitting back button
     */
    XuniDropDownModeFullScreen
};

#endif /* XuniDropDownEnums_h */
