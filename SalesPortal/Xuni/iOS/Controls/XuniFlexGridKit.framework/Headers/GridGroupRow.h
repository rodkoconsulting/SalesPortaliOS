//
//  GridGroupRow.h
//  FlexGrid
//
//  Copyright (c) GrapeCity, Inc. All rights reserved.
//

#import "GridRow.h"
#import "GridCellRange.h"

/**
 *  Class GridGroupRow.
 */
@interface GridGroupRow : GridRow

/**
 *  Gets or sets the hierarchical level of the group associated with this GridGroupRow.
 */
@property (nonatomic) NSUInteger level;

/**
 *  Gets a value that indicates whether this group row has child rows.
 */
@property (readonly) BOOL hasChildren;

/**
 *  Gets or sets a value that indicates whether this group row is collapsed (child rows are hidden) or expanded (child rows are visible).
 */
@property (nonatomic) BOOL isCollapsed;

/**
 *  Gets a CellRange object that contains all the rows in the group represented by this GridGroupRow and all columns in the grid.
 */
@property (readonly) GridCellRange *_Nonnull cellRange;

/**
 *  Gets the render size of this group row.
 */
@property (readonly) int renderSize;

/**
 *  Initialize an object for GridGroupRow.
 *
 *  @return an object for GridGroupRow.
 */
- (id _Nonnull)init;

@end
