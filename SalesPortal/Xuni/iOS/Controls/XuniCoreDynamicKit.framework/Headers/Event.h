//
//  Event.h
//  XuniCore
//
//  Copyright (c) GrapeCity, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
@class XuniPoint;

/**
 *  Generic function that has an arbitrary number of object and returns an object.
 */
@protocol IXuniFunction

/**
 *  Execute the function.
 *
 *  @param args array of parameters.
 *
 *  @return generic object.
 */
- (NSObject *)execute:(NSArray *)args;

@end

/**
 *  Base class for event arguments.
 */
@interface XuniEventArgs : NSObject

/**
 *  Provides a value to use with events that do not have event data.
 *
 *  @return return event arguments.
 */
+ (XuniEventArgs *)empty;
@end

/**
 *  Provides arguments for cancellable events.
 */
@interface XuniCancelEventArgs : XuniEventArgs

/**
 *  Gets or sets a value that indicates whether the event should be canceled.
 */
@property BOOL cancel;
@end

/**
 *  Provides arguments for cancellable events.
 */
@interface XuniPointEventArgs : XuniCancelEventArgs

/**
 *  Gets or sets a value that indicates whether the event should be canceled.
 */
@property XuniPoint *point;

/**
 *  Initialize a new XuniPointEventArgs with a point.
 *
 *  @param point the XuniPoint for the event.
 */
- (id)initWithPoint:(XuniPoint *)point;

@end

/**
 *  Generic class for supporting covariant/contravariant event handler block parameters.
 */
@interface XuniEventContainer<__covariant EventArgsType:XuniEventArgs *> : NSObject

/**
 *  Gets sender object
 */
@property (readonly, weak) NSObject* sender;

/**
 *  Gets event arguments
 */
@property (readonly) EventArgsType eventArgs;

/**
 *  Initialize a new XuniEventContainer with sender and eventArgs object.
 *
 *  @param sender the sender.
 *  @param args the event arguments.
 */
-(id) initWithSender:(NSObject*)sender andArgs:(EventArgsType)args;
@end

/**
 *  Represents an event handler.
 *
 *  @param sender the sender of the event.
 *  @param args   the arguments.
 */
typedef void(^IXuniEventHandler)(XuniEventContainer* eventContainer);

/**
 *  Base class for event handlers.
 */
@interface XuniEventHandler<__covariant EventArgsType:XuniEventArgs *> : NSObject

/**
 *  Gets or sets the event hander.
 */
@property (nonatomic, copy) void(^handler)(XuniEventContainer<EventArgsType>* eventContainer);
/**
 *  Gets or sets the object of this.
 */
@property (weak) NSObject *this;
/**
 *  Initialize an object for XuniEventHandler.
 *
 *  @param handler the handler.
 *  @param this    this object.
 *
 *  @return an object for XuniEventHandler.
 */
- (id)initWithHandler:(void(^)(XuniEventContainer<EventArgsType>* eventContainer))handler forObject:(NSObject *)this;
@end

/**
 *  Base class for event.
 */
@interface XuniEvent<__covariant EventArgsType:XuniEventArgs *> : NSObject

/**
 *  Gets or sets the mutable array of handlers.
 */
@property NSMutableArray<XuniEventHandler<EventArgsType>* > *handlers;

/**
 *  Add handler with specified object.
 *
 *  @param handler the handler.
 *  @param this    this object.
 */
- (void)addHandler:(void(^)(XuniEventContainer<EventArgsType>* eventContainer))handler forObject:(NSObject *)this;

/**
 *  Remove handler with specified object.
 *
 *  @param handler the handler.
 *  @param this    this object.
 */
- (void)removeHandler:(void(^)(XuniEventContainer<EventArgsType>* eventContainer))handler forObject:(NSObject *)this;

/**
 *  Remove handler with specified object.
 *
 *  @param this    this object.
 */
- (void)removeHandlersForObject:(NSObject *)this;

/**
 *  Remove all handlers.
 */
- (void)removeAllHandlers;

/**
 *  Raise sender with arguments.
 *
 *  @param sender the sender object.
 *  @param args   the arguments.
 */
- (void)raise:(NSObject *)sender withArgs:(EventArgsType)args;
@end
