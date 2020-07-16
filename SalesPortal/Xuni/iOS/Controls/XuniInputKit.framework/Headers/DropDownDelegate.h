//
//  DropDownDelegate.h
//  DropDown
//
//  Copyright (c) GrapeCity, Inc. All rights reserved.
//

#ifndef DropDownDelegate_h
#define DropDownDelegate_h

@class XuniDropDown;
@class XuniDropDownOpenChangedEventArgs;
@class XuniDropDownOpenChangingEventArgs;

/**
 *  protocol XuniDropDownDelegate.
 */
@protocol XuniDropDownDelegate <NSObject>
@optional

/**
 *  Occurs when the isDropDownOpen property changing.
 *
 *  @param sender The dropdown which isDropDownOpen property changing.
 *  @param args   The event args.
 */
- (void)isDropDownOpenChanging:(XuniDropDown *)sender args:(XuniDropDownOpenChangingEventArgs *)args;

/**
 *  Occurs when the isDropDownOpen property changed.
 *
 *  @param sender The dropdown which isDropDownOpen property changed.
 *  @param args   The event args.
 */
- (void)isDropDownOpenChanged:(XuniDropDown *)sender args:(XuniDropDownOpenChangedEventArgs *)args;

/**
 *  Called when the control finished rendering.
 *
 *  @param sender The control which is rendered.
 */
- (void)rendered:(XuniDropDown*)sender;

@end


#endif /* DropDownDelegate_h */
