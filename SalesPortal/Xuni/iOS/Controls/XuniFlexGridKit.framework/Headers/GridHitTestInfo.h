//
//  GridHitTestInfo.h
//  FlexGrid
//
//  Copyright (c) GrapeCity, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GridPanel.h"
#import "GridCellRange.h"

/**
 *  Class GridHitTestInfo.
 */
@interface GridHitTestInfo : NSObject

/**
 *  Initialize an object for GridHitTestInfo.
 *
 *  @param grid  the specified grid.
 *  @param point the specified point.
 *
 *  @return an object for GridHitTestInfo.
 */
- (id _Nonnull)initWithGrid:(FlexGrid * _Nonnull)grid atPoint:(CGPoint)point;

/**
 *  Initialize an object for GridHitTestInfo.
 *
 *  @param panel the specified panel.
 *  @param point the specified point.
 *
 *  @return an object for GridHitTestInfo.
 */
- (id _Nonnull)initWithPanel:(GridPanel * _Nonnull)panel atPoint:(CGPoint)point;

/**
 *  Gets the point in control coordinates that this HitTestInfo refers to.
 */
@property (readonly) CGPoint point;

/**
 *  Gets the cell type at the specified position.
 */
@property (readonly) GridCellType cellType;

/**
 *  Gets the grid panel at the specified position.
 */
@property (readonly) GridPanel * _Nonnull gridPanel;

/**
 *  Gets the row index of the cell at the specified position.
 */
@property (readonly) int row;

/**
 *  Gets the column index of the cell at the specified position.
 */
@property (readonly) int column;

/**
 *  Gets the cell range at the specified position.
 */
@property (readonly) GridCellRange * _Nullable cellRange;

/**
 *  Gets whether the specified position is near the left edge of the cell.
 */
@property (readonly) BOOL edgeLeft;

/**
 *  Gets whether the specified position is near the top edge of the cell.
 */
@property (readonly) BOOL edgeTop;

/**
 *  Gets whether the specified position is near the right edge of the cell.
 */
@property (readonly) BOOL edgeRight;

/**
 *  Gets whether the specified position is near the bottom edge of the cell.
 */
@property (readonly) BOOL edgeBottom;

@end
