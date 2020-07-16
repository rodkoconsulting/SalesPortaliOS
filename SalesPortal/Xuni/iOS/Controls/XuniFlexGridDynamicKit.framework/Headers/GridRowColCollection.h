//
//  GridRowColCollection.h
//  FlexGrid
//
//  Copyright (c) GrapeCity, Inc. All rights reserved.
//

#ifndef XUNI_INTERNAL_DYNAMIC_BUILD

#ifndef XuniCoreKit_h
#import "XuniCore/ObservableArray.h"
#endif

#else

#import <XuniCoreDynamicKit/XuniCoreDynamicKit.h>

#endif

@class FlexGrid;
@class GridPanel;
@class GridRowCol;

/**
 *  Class GridRowColCollection.
 */
@interface GridRowColCollection<__covariant ObjectType> : XuniObservableArray<ObjectType>

/**
 *  Initialize an object for GridRowColCollection.
 *
 *  @param grid the specified grid.
 *  @param size the specified size.
 *
 *  @return an object for GridRowColCollection.
 */
- (id _Nonnull)initWithGrid:(FlexGrid * _Nonnull)grid defaultSize:(int)size;


/**
 *  Gets or sets the default size of the elements in this collection.
 */
@property (nonatomic) int defaultSize;

/**
 *  Gets the number of frozen rows or columns in this collection (always zero in this version).
 */
@property (nonatomic) int frozen;

/**
 *  Gets or sets the minimum size of the elements in this collection.
 */
@property (nonatomic) int minSize;

/**
 *  Gets or sets the maximum size of the elements in this collection.
 */
@property (nonatomic) int maxSize;

/**
 *  Gets the total size of the elements in this collection.
 */
@property (readonly) int totalSize;

/**
 *  Gets the FlexGrid that owns this collection.
 */
@property (readonly) FlexGrid * _Nonnull grid;

/**
 *  Gets the GridPanel that owns this collection.
 */
@property (readonly) GridPanel * _Nonnull gridPanel;


/**
 *  Get a index at the specified position.
 *
 *  @param position the specified position.
 *
 *  @return a index.
 */
- (int)getIndexAt:(int)position;

/**
 *  Add a item.
 *
 *  @param item the specified item.
 */
- (void)push:(id _Nonnull)item;



@end
