//
//  GridPanel.h
//  FlexGrid
//
//  Copyright (c) GrapeCity, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "GridRowCollection.h"
#import "GridColumnCollection.h"

@class FlexGrid;
@class GridCellRange;
@class GridRowCol;

/**
 *  Identifies the type of cell in a grid panel.
 */
typedef NS_ENUM (NSInteger, GridCellType){
    /**
     *  GridCellTypeNone
     */
    GridCellTypeNone,
    /**
     *  GridCellTypeCell
     */
    GridCellTypeCell,
    /**
     *  GridCellTypeColumnHeader
     */
    GridCellTypeColumnHeader,
    /**
     *  GridCellTypeRowHeader
     */
    GridCellTypeRowHeader,
    /**
     *  GridCellTypeTopLeft
     */
    GridCellTypeTopLeft
};

/**
 *  Class GridRowAccessor.
 */
@interface GridRowAccessor: NSObject

/**
 *  Gets the panel that is being indexed.
 */
@property (readonly) GridPanel* _Nonnull panel;

/**
 *  Gets the index for the row being accessed
 */
@property (readonly) int rowIndex;

/**
 *  Initialize an object for GridRowAccessor.
 *
 *  @param panel     the specified GridPanel.
 *  @param index the specified index.
 *
 *  @return an object for GridRowAccessor.
 */
-(id _Nonnull)initWithPanel:(GridPanel*_Nonnull)panel andIndex:(int)index;

/**
 *  Get cell data for provided column index.
 *
 *  @param key the specified column.
 *
 *  @return a NSObject value.
 */
- (NSObject* _Nullable)objectAtIndexedSubscript:(int)key;

/**
 *  Set data of cell with provided object and column index.
 *
 *  @param obj the specified value.
 *  @param key     the specified column.
 */
- (void)setObject:(NSObject* _Nullable)obj atIndexedSubscript:(int)key;
@end

/**
 *  Class GridPanel.
 */
@interface GridPanel : NSObject

/**
 *  Get row accessor for provided row index
 *
 *  @param key     the specified row.
 *
 *  @return a GridRowAccessor value.
 */
- (nonnull GridRowAccessor*)objectAtIndexedSubscript:(int)key;

/**
 *  Initialize an object for GridPanel.
 *
 *  @param grid     the specified grid.
 *  @param cellType the specified cellType.
 *  @param rows     the specified rows.
 *  @param cols     the specified columns.
 *
 *  @return an object for GridPanel.
 */
- (id _Nonnull)initWithGrid:(FlexGrid * _Nonnull)grid cellType:(GridCellType)cellType rows:(GridRowCollection * _Nonnull)rows cols:(GridColumnCollection * _Nonnull)cols;


/**
 *  Gets the FlexGrid that owns this panel.
 */
@property (readonly) FlexGrid * _Nonnull grid;

/**
 *  Gets the type of cell contained in this panel.
 */
@property (readonly) GridCellType cellType;

/**
 *  Gets the total width of the content in this panel.
 */
@property (readonly) int width;

/**
 *  Gets the total height of the content in this panel.
 */
@property (readonly) int height;

/**
 *  Gets the X offset of the content in this panel.
 */
@property (readonly) int offsetX;

/**
 *  Gets the Y offset of the content in this panel.
 */
@property (readonly) int offsetY;

/**
 *  Gets the grid's rows collection.
 */
@property (readonly) GridRowCollection * _Nonnull rows;

/**
 *  Gets the grid's columns collection.
 */
@property (readonly) GridColumnCollection * _Nonnull columns;

/**
 *  Gets the range of cells currently in view.
 */
@property (readonly) GridCellRange *_Nonnull viewRange;

/**
 *  Gets the font.
 */
@property (readonly) UIFont *_Nonnull font;

/**
 *  Gets the fillColor.
 */
@property (readonly) UIColor *_Nonnull fillColor;
/**
 *  Gets the textColor.
 */
@property (readonly) UIColor *_Nonnull textColor;
/**
 *  Gets the lineColor.
 */
@property (readonly) UIColor *_Nonnull lineColor;
/**
 *  Gets the lineWidth.
 */
@property (readonly) double lineWidth;
/**
 *  Gets the textAttributes.
 */
@property (readonly) NSMutableDictionary *_Nonnull textAttributes;

/**
 *  Set data of cell with parameters.
 *
 *  @param value the specified value.
 *  @param r     the specified row.
 *  @param c     the specified column.
 */
- (void)setCellData:(NSObject * _Nullable)value forRow:(int)r inColumn:(int)c;

/**
 *  Get cell data for row.
 *
 *  @param r         the specified row.
 *  @param c         the specified column.
 *  @param formatted whether is formatted.
 *
 *  @return a NSObject value.
 */
- (NSObject * _Nullable)getCellDataForRow:(int)r inColumn:(int)c formatted:(BOOL)formatted;

/**
 *  Get cell rect for row.
 *
 *  @param r the specified row.
 *  @param c the specified column.
 *
 *  @return a rect.
 */
- (CGRect)getCellRectForRow:(int)r inColumn:(int)c;

/**
 *  Get cell rect for row.
 *
 *  @param r the specified row.
 *  @param c the specified column.
 *  @param range the specified merge range.
 *
 *  @return a rect.
 */
- (CGRect)getCellRectForRow:(int)r inColumn:(int)c withMergeRange:(GridCellRange* _Nullable)range;


/**
 *  Draw cell for row.
 *
 *  @param r the specified row.
 *  @param c the specified column.
 *  @param b whether is with background.
 */
- (void)drawCellForRow:(int)r inColumn:(int)c withBackground:(BOOL)b;

/**
 *  Draw cell for row.
 *
 *  @param r the specified row.
 *  @param c the specified column.
 *  @param b whether is with background.
 *  @param f whether is with foreground.
 */
- (void)drawCellForRow:(int)r inColumn:(int)c withBackground:(BOOL)b andForeground:(BOOL)f;

/**
 *  Draw cell background for row.
 *
 *  @param r r the specified row.
 *  @param c the specified column.
 *  @param t the specified rect.
 *  @param range the specified merge range.
 */
- (void)drawCellBackgroundForRow:(int)r inColumn:(int)c withRect:(CGRect)t andRange:(GridCellRange * _Nullable)range;

/**
 *  Draw cell background for row.
 *
 *  @param r r the specified row.
 *  @param c the specified column.
 *  @param t the specified rect.
 *  @param range the specified merge range.
 *  @param customBgClr the specified custom background color
 */
- (void)drawCellBackgroundForRow:(int)r inColumn:(int)c withRect:(CGRect)t andRange:(GridCellRange * _Nullable)range assumingCustomBGColor:(UIColor* _Nonnull)customBgClr;


/**
 *  Determine if the left border of the column is visible.
 *
 *  @param c the column index.
 *
 *  @return a boolean value.
 */
- (BOOL)isColLeftVisible:(int)c;

/**
 *  Determine if the right border of the column is visible.
 *
 *  @param c the column index.
 *
 *  @return a boolean value.
 */
- (BOOL)isColRightVisible:(int)c;

/**
 *  Determine if the top border of the row is visible.
 *
 *  @param r the row index.
 *
 *  @return a boolean value.
 */
- (BOOL)isRowTopVisible:(int)r;

/**
 *  Determine if the bottom border of the row is visible.
 *
 *  @param r the row index.
 *
 *  @return a boolean value.
 */
- (BOOL)isRowBottomVisible:(int)r;

/**
 *  Draw cells.
 */
- (void)drawCells;

/**
 *  Reset cache for a particular row or column.
 *
 *  @param rc the FlexRowCol to reset.
 */
- (void)resetCache:(GridRowCol *_Nullable)rc;

/**
 *  Draw selection.
 */
- (void)drawSelection;

/**
 *  Get frozen point.
 *
 *  @return a frozen point.
 */
- (CGPoint)frozenPoint;

/**
 *  Get the panel's clipping rectangle.
 *
 *  @return a rect.
 */
- (CGRect)getClipRect;

/**
 *  Internal, get the adorner.
 *
 *  @param pt the point of the adorner.
 */
- (int)getAdorner:(CGPoint)pt;

/**
 *  Internal, get the first visible column index.
 *
 *  @return the index.
 */
- (int)getFirstVisibleColumn;

/**
 *  Internal, get the first visible row index..
 *
 *  @return the index.
 */
- (int)getFirstVisibleRow;

/**
 *  Internal, get the group row header..
 *
 *  @param row the group row index.
 *
 *  @return the group row header.
 */
-(NSString* _Nullable)getGroupRowHeader:(int)row;

@end
