//
//  XuniComboBoxEventArgs.h
//  XuniInput
//
//  Copyright (c) GrapeCity, Inc. All rights reserved.
//

#ifndef XUNI_INTERNAL_DYNAMIC_BUILD

#ifndef XuniCoreKit_h

#import "XuniCore/Event.h"

#endif

#else
#import "XuniCoreDynamicKit/XuniCoreDynamicKit.h"
#endif

/**
 *  XuniDropDownItemLoadingEventArgs Class.
 *  Arguments for dropDownItemLoading event.
 */
@interface XuniDropDownItemLoadingEventArgs : XuniEventArgs

/**
 *  Gets the dropdown item data.
 */
@property (readonly) NSObject *itemData;

/**
 *  Gets the dropdown item rectangle.
 */
@property (readonly) CGRect itemRect;

/**
 *  Initializes and returns a newly allocated XuniDropDownItemLoadingEventArgs object.
 *
 *  @param itemData  The dropdown item data.
 *  @param itemRect  The dropdown item rectangle.
 *
 *  @return An initialized XuniDropDownItemLoadingEventArgs object or nil if the object couldn't be created.
 */
- (instancetype)initWithData:(NSObject *)itemData itemRect:(CGRect)itemRect;

@end
