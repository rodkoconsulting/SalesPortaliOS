//
//  CollectionView.h
//  XuniCore
//
//  Copyright (c) GrapeCity, Inc. All rights reserved.
//

#import "ICollectionView.h"
#import "Aggregate.h"
#import "Util.h"

@class XuniCollectionViewGroup <__covariant ObjectType> ;
@class XuniObservableArray <__covariant ObjectType>;

/**
 *  Class XuniCollectionView.
 */
@interface XuniCollectionView <__covariant ObjectType> : NSObject <IXuniEditableCollectionView>

/**
 *  Do something about the XuniCollectionView.
 *
 *  @return return an NSObject type value.
 */

typedef NSObject * (^XuniFunction)();



/**
 *  Gets a value that indicates whether notifications are currently suspended.
 */
@property (readonly) BOOL isUpdating;

/**
 *  Initialize an object for XuniCollectionView.
 *
 *  @return an object of XuniCollectionView.
 */
- (id)init;

/**
 *  Initialize an object for XuniCollectionView with sourceCollection.
 *
 *  @param sourceCollection the source of the collection.
 *
 *  @return return an object of XuniCollectionView with sourceCollection.
 */
- (id)initWithSource:(NSArray<ObjectType> *)sourceCollection;

/**
 *  Implements interface.
 *
 *  @param interfaceName the interface name string.
 *
 *  @return a boolean value.
 */
- (BOOL)implementsInterface:(NSString *)interfaceName;

/**
 *  Gets or sets a function that creates new items for the collection.
 */
@property (nonatomic, copy) XuniFunction newItemCreator;

/**
 *  Gets or sets a function used to convert values when sorting.
 */
@property (nonatomic, copy) IXuniSortConverter sortConverter;

/**
 *  Creates a grouped view of the current page
 *
 *  @param items the items.
 *
 *  @return return a mutable array.
 */
- (NSMutableArray *)createGroups:(NSArray *)items;

/**
 *  Comparison function used in array sort.
 *
 *  @return return the result of comparison.
 */
- (NSComparator)compareItems;

/**
 *  Gets an array that contains all the children for a list of groups.
 *
 *  @param groups the groups.
 *
 *  @return return an array.
 */
- (NSArray *)mergeGroupItems:(NSArray *)groups;

/**
 *  Finds or creates a group
 *
 *  @param gd            group description.
 *  @param groups        the groups array.
 *  @param name          the name.
 *  @param level         the level.
 *  @param isBottomLevel whether is bottom level.
 *
 *  @return return a collectionView group.
 */
- (XuniCollectionViewGroup<ObjectType> *)getGroup:(XuniGroupDescription *)gd groups:(NSArray *)groups name:(NSString *)name level:(NSUInteger)level isBottomLevel:(BOOL)isBottomLevel;

// IXuniCollectionView properties
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
@property (readonly) ObjectType currentItem;

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
@property (readonly) XuniObservableArray<XuniGroupDescription*> *groupDescriptions;

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
@property NSMutableArray<ObjectType> *sourceCollection;

/**
 *  Gets the filtered, sorted, grouped items in the view.
 */
@property (readonly) NSArray<ObjectType> *items;

/**
 *  Occurs after the current item changes.
 */
@property XuniEvent<XuniEventArgs *> *currentChanged;

/**
 *  Occurs before the current item changes.
 */
@property XuniEvent<XuniCancelEventArgs*> *currentChanging;

/**
 *  Raises the currentChanged event.
 *
 *  @param e the arguments of a event.
 */
- (void)onCurrentChanged:(XuniEventArgs *)e;

/**
 *  Raises the currentChanging event.
 *
 *  @param e the arguments of a event.
 *
 *  @return return a boolean value.
 */
- (BOOL)onCurrentChanging:(XuniCancelEventArgs *)e;

// IXuniEditableCollectionView properties

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
@property (readonly) ObjectType currentAddItem;

/**
 *  Gets the item that is being edited during the current edit transaction.
 */
@property (readonly) ObjectType currentEditItem;

/**
 *  Gets a value that indicates whether an add transaction is in progress.
 */
@property (readonly) BOOL isAddingNew;

/**
 *  Gets a value that indicates whether an edit transaction is in progress.
 */
@property (readonly) BOOL isEditingItem;

/**
 *  Gets the number of items in the view.
 */
@property (readonly) int itemCount;

// IXuniNotifyCollectionChanged properties

/**
 *  Occurs after the collection changes.
 */
@property XuniEvent<XuniNotifyCollectionChangedEventArgs*> *collectionChanged;

/**
 *  Raises the collectionChanged event.
 *
 *  @param e the arguments of a event.
 */
- (void)onCollectionChanged:(XuniNotifyCollectionChangedEventArgs *)e;

/**
 *  Creates event args and calls onCollectionChanged.
 */
- (void)raiseCollectionChanged;

/**
 *  Called when the collection has changed to push necessary notifications to listeners.
 *
 *  @param action           The type of collection change.
 *  @param items            The list of new items added.
 *  @param startingIndex    The index of the new items in the updated collection.
 *  @param oldItems         The list of items removed or changed.
 *  @param oldStartingIndex The start index of the old items removed from the collection.
 */
- (void)raiseCollectionChangedParams:(XuniNotifyCollectionChangedAction)action items:(NSMutableArray<ObjectType> *)items startingIndex:(long)startingIndex oldItems:(NSMutableArray<ObjectType> *)oldItems oldStartingIndex:(long)oldStartingIndex;

@end


/**
 *  Represents a group created by a XuniCollectionView object based on its groupDescriptions property.
 */
@interface XuniCollectionViewGroup<__covariant ObjectType> : NSObject {
    @private
    NSString             *_name;
    NSUInteger           _level;
    BOOL                 _isBottomLevel;
    NSMutableArray       *_items;
    NSArray              *_groups;
    XuniGroupDescription *_groupDescription;
    NSArray              *_agg;
}

/**
 *  Gets the name of this group.
 */
@property (readonly) NSString *name;
/**
 *  Gets the level of this group.
 */
@property (readonly) NSUInteger level;
/**
 *  Gets a value that indicates whether this group has any subgroups.
 */
@property (readonly) BOOL isBottomLevel;
/**
 *  Gets an array containing the items included in this group (including all subgroups).
 */
@property (readonly) NSMutableArray *items;
/**
 *  Gets an array containing the this group's subgroups.
 */
@property (readonly) NSArray<XuniCollectionViewGroup<ObjectType>*> *groups;
/**
 *  Gets the GroupDescription that owns this group.
 */
@property (readonly) XuniGroupDescription *groupDescription;

/**
 *  Gets the GroupDescription that owns this group.
 */
@property (nonatomic, readonly) NSUInteger totalItemCount;


/**
 *  Initialize an object for XuniCollectionViewGroup.
 *
 *  @param groupDescription the groupDescription.
 *  @param name             the name.
 *  @param level            the level.
 *  @param isBottomLevel    whether is bottom level.
 *
 *  @return return an object for XuniCollectionViewGroup.
 */
- (id)initWithGroup:(XuniGroupDescription *)groupDescription name:(NSString *)name level:(NSUInteger)level isBottomLevel:(BOOL)isBottomLevel;

/**
 *   Calculates an aggregate value for the items in this group.
 *
 *  @param aggType the aggregate type.
 *  @param binding the binding.
 *
 *  @return return an object.
 */
- (NSObject *)getAggregate:(XuniAggregate)aggType binding:(NSString *)binding;

@end

/**
 *  Represents XuniCollectionView that can load additional items on demand.
 */
@interface XuniCursorCollectionView<__covariant ObjectType> : XuniCollectionView<ObjectType>

/**
 *  Return true if there are more items to load.
 *
 *  @return return a boolean value.
 */
- (bool)hasMoreItems;

/**
 *   Load additional items.
 *
 *  @param desiredNumber the number of items to load.
 *
 *  @return return array of items loaded.
 */
- (NSMutableArray<ObjectType> *)itemGetter:(NSNumber *)desiredNumber;

/**
 *   Load additional items.
 *
 *  @param desiredNumber the number of items to load.
 *  @param completion function to execute when completed.
 */
- (void)loadMoreItems:(NSNumber *)desiredNumber completion:(void (^)())completion;

@end
