//
//  GridRow.h
//  FlexGrid
//
//  Copyright (c) GrapeCity, Inc. All rights reserved.
//

#import "GridRowCol.h"

/**
 *  FlexRow.
 */
@interface GridRow : GridRowCol


/**
 *  Gets or sets the item in the data collection that this item is bound to.
 */
@property (nonatomic) NSObject *_Nullable dataItem;

/**
 *  Gets or sets the height of this row.
 */
@property (nonatomic) int height;

/**
 *  Gets or sets the minimum height of this row.
 */
@property (nonatomic) int minHeight;

/**
 *  Gets or sets the maximum height of this row.
 */
@property (nonatomic) int maxHeight;

/**
 *  Gets the render height of this row.
 */
@property (readonly) int renderHeight;

/**
 *  Initialize an object for GridRow.
 *
 *  @return an object for GridRow.
 */
- (id _Nonnull)init;

/**
 *  Initialize an object for GridRow with dataItem.
 *
 *  @param dataItem the specified dataItem.
 *
 *  @return an object for GridRow.
 */
- (id _Nonnull)initWithData:(NSObject * _Nonnull)dataItem;

@end
