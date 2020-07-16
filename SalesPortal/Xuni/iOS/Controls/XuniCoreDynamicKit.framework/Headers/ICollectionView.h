//
//  ICollectionView.h
//  XuniCore
//
//  Copyright (c) GrapeCity, Inc. All rights reserved.
//

#import "Event.h"

@class XuniObservableArray;


/**
 *  Identifies the collectionChanged action type
 */
typedef NS_ENUM (NSInteger, XuniNotifyCollectionChangedAction){
    /**
     *  XuniNotifyCollectionChangedActionAdd.
     */
    XuniNotifyCollectionChangedActionAdd,
    /**
     *  XuniNotifyCollectionChangedActionRemove.
     */
    XuniNotifyCollectionChangedActionRemove,
    /**
     *  XuniNotifyCollectionChangedActionReplace.
     */
    XuniNotifyCollectionChangedActionReplace,
    /**
     *  XuniNotifyCollectionChangedActionReset.
     */
    XuniNotifyCollectionChangedActionReset
};

/**
 *  Provides data for the collectionChanged event
 */
@interface XuniNotifyCollectionChangedEventArgs : XuniEventArgs

/**
 *  Reset the arguments.
 *
 *  @return the reset object.
 */
+ (XuniNotifyCollectionChangedEventArgs *)reset;

/**
 *  Gets the action that caused the event.
 */
@property XuniNotifyCollectionChangedAction action;

/**
 *  New items added to the collection.
 */
@property NSMutableArray *items;

/**
 *  Start index of the new items in the collection.
 */
@property long startingIndex;

/**
 *  Old items removed from the collection.
 */
@property NSMutableArray *oldItems;

/**
 *  Start index of the old items removed from the collection.
 */
@property long oldStartingIndex;

/**
 *  Initialize an object for XuniNotifyCollectionChangedEventArgs.
 *
 *  @param action the specified action.
 *
 *  @return an object for XuniNotifyCollectionChangedEventArgs.
 */
- (id)initWithAction:(XuniNotifyCollectionChangedAction)action;

/**
 *  Initialize an object for XuniNotifyCollectionChangedEventArgs with arguments.
 *
 *  @param action           the specified action.
 *  @param items            the specified items.
 *  @param startingIndex    the specified startingIndex.
 *  @param oldItems         the specified oldItems.
 *  @param oldStartingIndex the specified oldStartingIndex.
 *
 *  @return an object for XuniNotifyCollectionChangedEventArgs。
 */
- (id)initWithAction:(XuniNotifyCollectionChangedAction)action forItems:(NSMutableArray *)items atStartingIndex:(long)startingIndex forOldItems:(NSMutableArray *)oldItems atOldStartingIndex:(long)oldStartingIndex;
@end

/**
 *  Represents a method that takes an item of any type and returns a
 *
 *  @param item the item.
 *
 *  @return boolean that indicates whether the object meets a set of criteria.
 */
typedef BOOL (^IXuniPredicate)(NSObject *item);

/**
 *  Represents a method that compares two objects.
 *
 *  @param x object x.
 *  @param y object y.
 *
 *  @return return a boolean value.
 */
typedef int (^IXuniComparer)(NSObject *x, NSObject *y);

/**
 *  Describes a sorting criterion.
 */
@interface XuniSortDescription : NSObject

/**
 *  Gets the name of the property used to sort.
 */
@property NSString *property;

/**
 *  Gets a value that determines whether to sort the values in ascending order.
 */
@property BOOL ascending;

/**
 *  Gets the name of the binding used to sort.
 */
@property NSString *binding;

/**
 *  Initialize an object for XuniSortDescription.
 *
 *  @param property  the specified property.
 *  @param ascending the specified ascending.
 *
 *  @return an object for XuniSortDescription.
 */
- (id)initWithProperty:(NSString *)property ascending:(BOOL)ascending;
@end


/**
 *  Notifies listeners of dynamic changes.
 */
@protocol IXuniNotifyCollectionChanged

/**
 *  Gets the event of collection changed.
 */
@property XuniEvent<XuniNotifyCollectionChangedEventArgs*> *collectionChanged;
@end

/**
 *  Represents a function used to convert values when sorting.
 *
 *  @param sd    the sort description.
 *  @param item  the item.
 *  @param value the raw value.
 *
 *  @return return the value to use for sorting.
 */
typedef NSObject * (^IXuniSortConverter)(XuniSortDescription *sd, NSObject *item, NSObject *value);

/**
 *  Enables collections to have the functionalities of current record management, custom sorting, filtering, and grouping.
 */
@protocol IXuniCollectionView<IXuniNotifyCollectionChanged>

/**
 *  Gets a value that indicates whether this view supports filtering.
 */
@property (readonly) BOOL canFilter;

/**
 *  Gets a value that indicates whether this view supports grouping.
 */
@property (readonly) BOOL canGroup;

/**
 *  Gets a value that indicates whether this view supports sorting.
 */
@property (readonly) BOOL canSort;

/**
 *  Gets the current item in the view.
 */
@property (readonly) NSObject *currentItem;

/**
 *  Gets the ordinal position of the current item in the view.
 */
@property (readonly) int currentPosition;

/**
 *  Gets or sets a callback used to determine if an item is suitable for inclusion in the view.
 */
@property (nonatomic, copy) IXuniPredicate filter;

/**
 *  Gets a collection of objects that describe how the items in the collection are grouped in the view.
 */
@property (readonly) XuniObservableArray *groupDescriptions;

/**
 *  Gets the top-level groups.
 */
@property (readonly) NSArray *groups;

/**
 *  Gets a value that indicates whether this view contains no items.
 */
@property (readonly) BOOL isEmpty;

/**
 *  Gets a collection of @see:SortDescription objects that describe how the items in the collection are sorted in the view.
 */
@property (readonly) XuniObservableArray *sortDescriptions;

/**
 *  Gets or sets the collection object from which to create this view.
 */
@property NSMutableArray *sourceCollection;

/**
 *  Returns a value that indicates whether a given item belongs to this view.
 *
 *  @param item the item.
 *
 *  @return return a boolean value of whether a given item belongs to this view..
 */
- (BOOL)contains:(NSObject *)item;

/**
 *  Sets the specified item to be the current item in the view.
 *
 *  @param item the item.
 *
 *  @return return a boolean value.
 */
- (BOOL)moveCurrentTo:(NSObject *)item;

/**
 *  Sets the first item in the view as the current item.
 *
 *  @return return a boolean value.
 */
- (BOOL)moveCurrentToFirst;

/**
 *  Sets the last item in the view as the current item.
 *
 *  @return return a boolean value.
 */
- (BOOL)moveCurrentToLast;

/**
 *  Sets the item after the current item in the view as the current item.
 *
 *  @return return a boolean value.
 */
- (BOOL)moveCurrentToNext;

/**
 *  Sets the item at the specified index in the view as the current item.
 *
 *  @param index the index.
 *
 *  @return return a boolean value.
 */
- (BOOL)moveCurrentToPosition:(int)index;

/**
 *  Sets the item before the current item in the view as the current item.
 *
 *  @return return a boolean value.
 */
- (BOOL)moveCurrentToPrevious;

/**
 *  Re-creates the view using the current sort, filter, and group parameters.
 */
- (void)refresh;

/**
 *  Re-creates the view using the current sort, filter, and group parameters.
 *
 *  @param isNotifyCollectionChanged YES means to trigger collectionChanged event, NO means do not trigger.
 */
- (void)refresh:(BOOL)isNotifyCollectionChanged;

/**
 *  Occurs after the current item changes.
 */
@property XuniEvent *currentChanged;

/**
 *  Occurs before the current item changes.
 */
@property XuniEvent *currentChanging;

/**
 *  Suspend refreshes until the next call to endUpdate.
 */
- (void)beginUpdate;

/**
 *  Resume refreshes suspended by a call to beginUpdate.
 */
- (void)endUpdate;

/**
 *  Executes a function within a beginUpdate/endUpdate block.
 *
 *  @param fn a block.
 */
- (void)deferUpdate:(void (^)())fn;

/**
 *  Gets the filtered, sorted, grouped items in the view.
 */
@property (readonly) NSArray *items;

@end // IXuniCollectionView

/**
 *  Defines methods and properties that extend ICollectionView to provide editing capabilities.
 */
@protocol IXuniEditableCollectionView <IXuniCollectionView>

/**
 *  Gets a value that indicates whether a new item can be added to the collection.
 */
@property (readonly) BOOL canAddNew;

/**
 *  Gets a value that indicates whether the collection view can discard pending changes and restore the original values of an edited object.
 */
@property (readonly) BOOL canCancelEdit;

/**
 *  Gets a value that indicates whether items can be removed from the collection.
 */
@property (readonly) BOOL canRemove;

/**
 *  Gets the item that is being added during the current add transaction.
 */
@property (readonly) NSObject *currentAddItem;

/**
 *  Gets the item that is being edited during the current edit transaction.
 */
@property (readonly) NSObject *currentEditItem;

/**
 *  Gets a value that indicates whether an add transaction is in progress.
 */
@property (readonly) BOOL isAddingNew;

/**
 *  Gets a value that indicates whether an edit transaction is in progress.
 */
@property (readonly) BOOL isEditingItem;

/**
 *  Adds a new item to the collection.
 *
 *  @return return an object.
 */
- (NSObject *)addNew;

/**
 *  Ends the current edit transaction and, if possible, restores the original value to the item.
 */
- (void)cancelEdit;

/**
 *  Ends the current add transaction and discards the pending new item.
 */
- (void)cancelNew;

/**
 *  Ends the current edit transaction and saves the pending changes.
 */
- (void)commitEdit;

/**
 *  Ends the current add transaction and saves the pending new item.
 */
- (void)commitNew;

/**
 *  Begins an edit transaction of the specified item.
 *
 *  @param item the item.
 */
- (void)editItem:(NSObject *)item;

/**
 *  Removes the specified item from the collection.
 *
 *  @param item the item.
 */
- (void)remove:(NSObject *)item;

/**
 *  Removes the item at the specified index from the collection.
 *
 *  @param index the specified index.
 */
- (void)removeAt:(int)index;

/**
 *  Adds a new object to the end of the collection.
 *
 *  @param anObject object to add.
 */
- (void)addObject:(NSObject *)anObject;


/**
 *  Adds an array of objects to the end of the collection.
 *
 *  @param objects objects to add.
 */
- (void)addObjects:(NSArray *)objects;

/**
 *  Inserts a new object at the specified location.
 *
 *  @param anObject object to add.
 *  @param index    location of object.
 */
- (void)insertObject:(NSObject *)anObject atIndex:(NSUInteger)index;

/**
 *  Remove all objects from the collection.
 */
- (void)removeAllObjects;

/**
 *  Replace the object at the current location with a new object.
 *
 *  @param index    location to replace at.
 *  @param anObject the new object.
 */
- (void)replaceObjectAtIndex:(NSUInteger)index withObject:(NSObject *)anObject;

@end // IXuniEditableCollectionView

/**
 *  Represents a base class for types defining grouping conditions.
 */
@interface XuniGroupDescription : NSObject

/**
 *  Returns the group name for the given item.
 *
 *  @param item  the item.
 *  @param level the level.
 *
 *  @return return an object.
 */
- (NSString *)groupNameFromItem:(NSObject *)item atLevel:(NSUInteger)level;

/**
 *  Returns a value that indicates whether the group name and the item name match.
 *
 *  @param groupName the group name.
 *  @param itemName  the item name.
 *
 *  @return return a boolean value.
 */
- (BOOL)namesMatch:(NSString *)groupName itemName:(NSString *)itemName;
@end

/**
 *  Represents a callback function that generates the group name.
 *
 *  @param item         the item.
 *  @param propertyName the property name.
 *
 *  @return return the group name.
 */
typedef NSString * (^IXuniPropertyGroupConverter)(NSObject *item, NSString *propertyName);

/**
 *  Describes the grouping of items using a property name as the criterion.
 */
@interface XuniPropertyGroupDescription : XuniGroupDescription

/**
 *  Gets the name of the property that is used to determine which group an item belongs to.
 */
@property (readonly) NSString *property;

/**
 *  Initialize an object for XuniPropertyGroupDescription.
 *
 *  @param property the specified property.
 *
 *  @return an object for XuniPropertyGroupDescription.
 */
- (id)initWithProperty:(NSString *)property;

/**
 *  Initialize an object for XuniPropertyGroupDescription.
 *
 *  @param property  the specified property.
 *  @param converter the callback function that generates the group name.
 *
 *  @return an object for XuniPropertyGroupDescription.
 */
- (id)initWithProperty:(NSString *)property converter:(IXuniPropertyGroupConverter)converter;
@end



