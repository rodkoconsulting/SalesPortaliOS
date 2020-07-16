//
//  XuniAutoCompleteEventArgs.h
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
 *  XuniAutoCompleteFilteringEventArgs Class.
 *  Arguments for filtering event.
 */
@interface XuniAutoCompleteFilteringEventArgs : XuniEventArgs

/**
 *  Gets or sets whether to cancel the filtering.
 */
@property (nonatomic) BOOL cancel;

/**
 *  Gets the autocomplete item source.
 */
@property (nonatomic) NSMutableArray *itemSource;

/**
 *  Initializes and returns a newly allocated XuniAutoCompleteFilteringEventArgs object.
 *
 *  @param itemSource  The autocomplete item source.
 *  @param handled  whether to cancel the filtering.
 *
 *  @return An initialized XuniAutoCompleteFilteringEventArgs object or nil if the object couldn't be created.
 */
- (instancetype)initWithItemSource:(NSMutableArray *)itemSource cancel:(BOOL)cancel;

@end
