//
//  GridCellRange.h
//  FlexGrid
//
//  Copyright (c) GrapeCity, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GridPanel.h"

/**
 * Class GridCellRange.
 */
@interface GridCellRange : NSObject

/**
 *  Initialize an object for GridCellRange.
 *
 *  @return an object for GridCellRange.
 */
- (id _Nonnull)init;

/**
 *  Initialize an object for GridCellRange.
 *
 *  @param row the row.
 *  @param col the column.
 *
 *  @return an object for GridCellRange.
 */
- (id _Nonnull)initWithRow:(int)row col:(int)col;

/**
 *  Initialize an object for GridCellRange.
 *
 *  @param row  the row.
 *  @param col  the column.
 *  @param row2 the row2.
 *  @param col2 the column2.
 *
 *  @return an object for GridCellRange.
 */
- (id _Nonnull)initWithRow:(int)row col:(int)col row2:(int)row2 col2:(int)col2;

/**
 *  Clone an object for GridCellRange.
 *
 *  @return an object for GridCellRange.
 */
- (GridCellRange * _Nonnull)clone;

/**
 *  Judge whether the two objects of GridCellRange is equal.
 *
 *  @param other the other object of GridCellRange.
 *
 *  @return a boolean value.
 */
- (BOOL)isEqual:(GridCellRange * _Nonnull)other;

/**
 *  Judge whether the two objects are intersect.
 *
 *  @param other the other object of GridCellRange.
 *
 *  @return a boolean value.
 */
- (BOOL)intersects:(GridCellRange * _Nonnull)other;

/**
 *  Gets or sets the index of the first row in this range.
 */
@property int row;

/**
 *  Gets or sets the index of the first column in this range.
 */
@property int col;

/**
 *  Gets or sets the index of the second row in this range.
 */
@property int row2;

/**
 *  Gets or sets the index of the second column in this range.
 */
@property int col2;

/**
 *  Gets the number of rows in this range.
 */
@property (readonly) int rowSpan;

/**
 *  Gets the number of columns in this range.
 */
@property (readonly) int columnSpan;

/**
 *  Gets the index of the top row in this range.
 */
@property (readonly) int topRow;

/**
 *  Gets the index of the bottom row in this range.
 */
@property (readonly) int bottomRow;

/**
 *  Gets the index of the leftmost column in this range.
 */
@property (readonly) int leftCol;

/**
 *   Gets the index of the rightmost column in this range.
 */
@property (readonly) int rightCol;

/**
 *  Checks whether this range contains valid row and column indices (> -1).
 */
@property (readonly) BOOL isValid;

/**
 *  Checks whether this range corresponds to a single cell (row == row2 && col == col2).
 */
@property (readonly) BOOL isSingleCell;

/**
 *  Get render size.
 *
 *  @param panel the panel.
 *
 *  @return a render size
 */
- (CGSize)getRenderSize:(GridPanel * _Nonnull)panel;

/**
 *  Judge whether contains the specified row.
 *
 *  @param r the specified row.
 *
 *  @return a boolean value.
 */
- (BOOL)containsRow:(int)r;

/**
 *  Judge whether contains the specified column.
 *
 *  @param c the specified column.
 *
 *  @return a boolean value.
 */
- (BOOL)containsColumn:(int)c;

/**
 *  udge whether contains the specified FlexCellRange object.
 *
 *  @param other the specified FlexCellRange object.
 *
 *  @return a boolean value.
 */
- (BOOL)contains:(GridCellRange *_Nonnull)other;

@end
