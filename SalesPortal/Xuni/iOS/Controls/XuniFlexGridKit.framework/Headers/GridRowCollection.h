//
//  GridRowCollection.h
//  FlexGrid
//
//  Copyright (c) GrapeCity, Inc. All rights reserved.
//

#import "GridRowColCollection.h"

@class FlexGrid;
@class GridRow;

/**
 *  Class GridRowCollection.
 */
@interface GridRowCollection : GridRowColCollection<GridRow*>

/**
 *  Initialize an object for GridRowCollection.
 *
 *  @param grid the specified grid.
 *  @param size the specified size.
 *
 *  @return an object for GridRowCollection.
 */
- (id _Nonnull)initWithGrid:(FlexGrid *_Nonnull)grid defaultSize:(int)size;

/**
 *  Gets or sets the default size of group rows in this collection.
 */
@property (nonatomic) int defaultGroupSize;

@end
