//
//  ObservableArray.h
//  XuniCore
//
//  Copyright (c) GrapeCity, Inc. All rights reserved.
//

#import "ICollectionView.h"

/**
 *  Class XuniObservableArray.
 */
@interface XuniObservableArray<__covariant ObjectType> : NSObject <IXuniNotifyCollectionChanged, NSFastEnumeration>


/**
 *  Do the enumeration (for for-in cycle)
 *
 *  @param state the enumeration state.
 *  @param buffer the data buffer.
 *  @param len the traversed items count
 *
 *  @return return the data size flag
 */
- (NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState * _Null_unspecified)state objects:(id __unsafe_unretained _Nullable [_Nonnull])buffer count:(NSUInteger)len;

/**
 *  Get the object by subscript index.
 *
 *  @param key the subscript
 *
 *  @return return the object by provided subscript
 */
- (ObjectType _Nonnull)objectAtIndexedSubscript:(int)key;


/**
 *  Set the object by subscript index
 *
 *  @param obj the object.
 *  @param key the subscript
 */
- (void)setObject:(ObjectType _Nonnull)obj atIndexedSubscript:(int)key;

/**
 *  Gets the array of the source.
 */
@property (readonly) NSArray<ObjectType> * _Nonnull sourceArray;

/**
 *  Get the count of an array.
 */
@property (readonly) NSUInteger count;

/**
 *  Get an object of an array.
 *
 *  @param index the object index.
 *
 *  @return return an object.
 */
- (ObjectType _Nonnull)objectAtIndex:(NSUInteger)index;

/**
 *  Get the index of an object.
 *
 *  @param anObject an object.
 *
 *  @return return the object index.
 */
- (NSUInteger)indexOfObject:(ObjectType _Nonnull)anObject;

// NSMutableArray methods
/**
 *  Add an object into the array.
 *
 *  @param anObject an object.
 */
- (void)addObject:(ObjectType _Nonnull)anObject;

/**
 *  Add an array of objects into the array.
 *
 *  @param array an array.
 */
- (void)addObjectsFromArray:(NSArray<ObjectType>* _Nonnull)array;

/**
 *  Insert an object into the array at the index.
 *
 *  @param anObject an object.
 *  @param index    the insert index.
 */
- (void)insertObject:(ObjectType _Nonnull)anObject atIndex:(NSUInteger)index;

/**
 *  Remove all objects from the array.
 */
- (void)removeAllObjects;

/**
 *  Remove an object from the array.
 *
 *  @param anObject an object.
 */
- (void)removeObject:(ObjectType _Nonnull)anObject;

/**
 *  Remove an object from the array at the index.
 *
 *  @param index the index.
 */
- (void)removeObjectAtIndex:(NSUInteger)index;

/**
 *  Replace an object of the array at the index with another object.
 *
 *  @param index    the index.
 *  @param anObject an object.
 */
- (void)replaceObjectAtIndex:(NSUInteger)index withObject:(ObjectType _Nonnull)anObject;

/**
 *  Initialize an instance for XuniObservableArray.
 *
 *  @return return an instance of XuniObservableArray.
 */
- (instancetype _Nonnull)init NS_DESIGNATED_INITIALIZER;

/**
 *  Initialize an instance for XuniObservableArray with capacity.
 *
 *  @param numItems the number of items.
 *
 *  @return an instance for XuniObservableArray.
 */
- (instancetype _Nonnull) initWithCapacity:(NSUInteger)numItems NS_DESIGNATED_INITIALIZER;

/**
 *  Suspends notifications until the next call to endUpdate.
 */
- (void)beginUpdate;

/**
 *  Resumes notifications suspended by a call to beginUpdate.
 */
- (void)endUpdate;

/**
 *  Gets a value that indicates whether notifications are currently suspended.
 *
 *  @return return a boolean value.
 */
- (BOOL)isUpdating;

/**
 *  Executes a function within a beginUpdate/endUpdate block.
 *
 *  @param fn a block.
 */
- (void)deferUpdate:(void (^ _Nonnull)())fn;

/**
 *  Gets or sets collectionChanged.
 */
@property XuniEvent<XuniNotifyCollectionChangedEventArgs*> * _Nonnull collectionChanged;

/**
 *  Raises the collectionChanged event.
 *
 *  @param e an object of XuniNotifyCollectionChangedEventArgs.
 */
- (void)onCollectionChanged:(XuniNotifyCollectionChangedEventArgs * _Nonnull)e;

/**
 *  Raises the collectionChanged event.
 *
 *  @param action           how collection changed.
 *  @param items            the items.
 *  @param startingIndex    start index of the new items in the collection.
 *  @param oldItems         old items removed from the collection.
 *  @param oldStartingIndex start index of the old items removed from the collection.
 */
- (void)raiseCollectionChanged:(XuniNotifyCollectionChangedAction)action items:(NSMutableArray * _Nullable)items startingIndex:(long)startingIndex oldItems:(NSMutableArray * _Nullable)oldItems oldStartingIndex:(long)oldStartingIndex;

@end
