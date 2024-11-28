//
//  DropDownEventArgs.h
//  DropDown
//
//  Copyright (c) GrapeCity, Inc. All rights reserved.
//

#ifndef XUNI_INTERNAL_DYNAMIC_BUILD

#ifndef XuniCoreKit_h
#import "XuniCore/Event.h"
#endif

#else

#import <XuniCoreDynamicKit/XuniCoreDynamicKit.h>

#endif

@class XuniDropDownHeaderView;
@class XuniDropDown;
@class XuniDropDownView;

/**
 *  XuniDropDownOpenChangingEventArgs Class.
 *  Arguments for DropDownOpenChanging event.
 */
@interface XuniDropDownOpenChangingEventArgs : XuniEventArgs

/**
 *  Gets or sets the drop down.
 */
@property(nonatomic) XuniDropDown *dropDown;

/**
 *  Initializes and returns a newly allocated XuniDropDownOpenChangingEventArgs object.
 *
 *  @param dropDown  The dropDown control.
 *
 *  @return An initialized XuniDropDownOpenChangingEventArgs object or nil if the object couldn't be created.
 */
- (instancetype)initWithDropDown:(XuniDropDown *)dropDown;

@end

/**
 *  XuniDropDownOpenChangedEventArgs Class.
 *  Arguments for DropDownOpenChanged event.
 */
@interface XuniDropDownOpenChangedEventArgs : XuniEventArgs

/**
 *  Gets or sets the drop down.
 */
@property(nonatomic) XuniDropDown *dropDown;

/**
 *  Initializes and returns a newly allocated XuniDropDownOpenChangedEventArgs object.
 *
 *  @param dropDown  The dropDown control.
 *
 *  @return An initialized XuniDropDownOpenChangedEventArgs object or nil if the object couldn't be created.
 */
- (instancetype)initWithDropDown:(XuniDropDown *)dropDown;

@end
