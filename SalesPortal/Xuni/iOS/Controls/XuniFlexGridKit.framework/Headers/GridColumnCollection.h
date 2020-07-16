//
//  GridColumnCollection.h
//  FlexGrid
//
//  Copyright (c) GrapeCity, Inc. All rights reserved.
//

#import "GridRowColCollection.h"

@class GridColumn;

/**
 *  Class GridColumnCollection.
 */
@interface GridColumnCollection : GridRowColCollection<GridColumn*>
/**
 *  Get GridColumn for provided binding
 *
 *  @param key     the specified binding.
 *
 *  @return a GridColumn value.
 */
- (GridColumn* _Nonnull)objectForKeyedSubscript:(NSString*_Nonnull)key;
@end
