//
//  GridMergeManager.h
//  FlexGrid
//
//  Copyright © 2016 C1Marketing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FlexGrid.h"


/**
 * Class GridMergeManager.
 */
@interface GridMergeManager : NSObject
/**
 *   Gets the FlexGrid associated with the manager.
 */
@property (readonly) FlexGrid * _Nonnull grid;

/**
 *  Initialize an object for GridMergeManager.
 *
 *  @param grid   the sepcified FlexGrid.
 *
 *  @return an object for GridMergeManager.
 */
- (id _Nonnull) initWithGrid:(FlexGrid *_Nonnull)grid;

/**
 *  Gets the merged cells range for a specified input cell range.
 *
 *  @param range         the input range.
 *  @param type         the type of cells to process.
 *
 *  @return the merged FlexCellRange for the input range
 */
- (GridCellRange *_Nonnull)getMergedRangeForCells:(GridCellRange *_Nonnull)range ofType:(GridCellType)type;

@end
