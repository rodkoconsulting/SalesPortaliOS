//
//  FlexGrid.h
//  FlexGrid
//
//  Copyright (c) GrapeCity, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

#ifndef XUNI_INTERNAL_DYNAMIC_BUILD

#ifndef XuniCoreKit_h
#import "XuniCore/CollectionView.h"
#import "XuniCore/Drawing.h"
#import "XuniCore/IXuniValueFormatter.h"
#import "XuniCore/XuniCheckBox.h"
#import "XuniCore/XuniView.h"
#endif

#else

#import <XuniCoreDynamicKit/XuniCoreDynamicKit.h>

#endif

#import "GridRowCollection.h"
#import "GridColumnCollection.h"
#import "GridPanel.h"
#import "GridCellRange.h"
#import "GridCellFactory.h"
#import "GridEventArgs.h"
#import "GridMergeManager.h"
#import "GridHitTestInfo.h"

@class GridMergeManager;
@class FlexGridDetailProvider;
@class GridColumn;

/**
 *  Delegate class for handling FlexGrid notifications.
 */
@protocol FlexGridDelegate <XuniViewDelegate>
@optional

/**
 *  Occurs when auto generating a column
 *
 *  @param sender the sender FlexGrid object.
 *  @param propertyInfo the specified property.
 *  @param column the specified column.
 *
 *  @return a boolean value that determines the cancelling of the column generation
 */
- (BOOL)autoGeneratingColumn:(FlexGrid * _Nonnull)sender withPropertyInfo:(XuniPropertyInfo *_Nonnull)propertyInfo column:(GridColumn *_Nonnull)column;

/**
 *  Occurs after resizing a column
 *
 *  @param sender the sender FlexGrid object.
 *  @param column the specified column.
 *
 *  @return a boolean value that determines the cancelling of the column generation
 */
- (void)resizedColumn:(FlexGrid *_Nonnull)sender column:(GridColumn *_Nonnull)column;

/**
 * Occurs before the FlexGrid caches were dropped.
 *
 * @param sender the FlexGrid whose caches are dropped.
 */
- (void)droppedCaches:(FlexGrid *_Nonnull)sender;

/**
 * Occurs before the FlexGrid is being invalidated.
 *
 * @param sender the object invalidated.
 */
- (void)invalidated:(FlexGrid *_Nonnull)sender;

/**
 *  Occurs when an element representing a cell has been created.
 *
 *  @param sender the FlexGrid sender object.
 *  @param panel the FlexGridPanel event appears on.
 *  @param range the specified cell range.
 *  @param context graphics context to perform painting.
 *
 *  @return true to cancel further processing, false to proceed by default
 */
- (bool)formatItem:(FlexGrid *_Nonnull)sender panel:(GridPanel *_Nonnull)panel forRange:(GridCellRange *_Nonnull)range inContext:(CGContextRef _Nonnull)context;

/**
 *  Occurs when cell overlay must be processed
 *
 *  @param sender the FlexGrid sender object.
 *  @param panel the FlexGridPanel event appears on.
 *  @param range the specified cell range.
 *  @param context graphics context to perform painting.
 *
 *  @return true to cancel further processing, false to proceed by default
 */
- (bool)processItemOverlay:(FlexGrid *_Nonnull)sender panel:(GridPanel *_Nonnull)panel forRange:(GridCellRange *_Nonnull)range inContext:(CGContextRef _Nonnull)context;


/**
 *  Occurs when FlexGrid cell being tapped
 *
 *  @param sender the FlexGrid sender object.
 *  @param panel the FlexGridPanel event appears on.
 *  @param range the specified cell range.
 *
 *  @return true to cancel further processing, false to proceed by default
 */
- (bool)cellTapped:(FlexGrid * _Nonnull)sender panel:(GridPanel * _Nonnull)panel forRange:(GridCellRange * _Nullable)range;

/**
 *  Occurs when FlexGrid cell being double tapped
 *
 *  @param sender the FlexGrid sender object.
 *  @param panel the FlexGridPanel event appears on.
 *  @param range the specified cell range.
 *
 *  @return true to cancel further processing, false to proceed by default
 */
- (bool)cellDoubleTapped:(FlexGrid * _Nonnull)sender panel:(GridPanel * _Nonnull)panel forRange:(GridCellRange * _Nullable)range;

/**
 *  Occurs before a cell enters edit mode.
 *
 *  @param sender the FlexGrid sender object.
 *  @param panel the FlexGridPanel event appears on.
 *  @param range the specified cell range.
 *
 *  @return true to cancel further processing, false to proceed by default
 */
- (bool)beginningEdit:(FlexGrid * _Nonnull)sender panel:(GridPanel *_Nonnull)panel forRange:(GridCellRange *_Nonnull)range;

/**
 *  Occurs when a cell edit is ending.
 *
 *  @param sender the FlexGrid sender object.
 *  @param panel the FlexGridPanel event appears on.
 *  @param range the specified cell range.
 *  @param cancel is the event processing cancelled on previous step
 *
 *  @return true to cancel further processing, false to proceed by default
 */
- (bool)cellEditEnding:(FlexGrid *_Nonnull)sender panel:(GridPanel *_Nonnull)panel forRange:(GridCellRange *_Nonnull)range cancel:(BOOL)cancel;

/**
 *  Occurs when a cell has been commmitted or canceled.
 *
 *  @param sender the FlexGrid sender object.
 *  @param panel the FlexGridPanel event appears on.
 *  @param range the specified cell range.
 */
- (void)cellEditEnded:(FlexGrid *_Nonnull)sender panel:(GridPanel *_Nonnull)panel forRange:(GridCellRange *_Nonnull)range;

/**
 *  Occurs when an editor cell is created and before it becomes active.
 *
 *  @param sender the FlexGrid sender object.
 *  @param panel the FlexGridPanel event appears on.
 *  @param range the specified cell range.
 *
 *  @return true to cancel further processing, false to proceed by default
 */
- (bool)prepareCellForEdit:(FlexGrid *_Nonnull)sender panel:(GridPanel *_Nonnull)panel forRange:(GridCellRange *_Nonnull)range;

/**
 *  Occurs after the grid has been bound to a new items source.
 *
 *  @param sender the sender object.
 */
- (void)itemsSourceChanged:(FlexGrid *_Nonnull)sender;

/**
 *  Occurs before the grid rows are bound to items in the data source.
 *
 *  @param sender the sender object.
 */
- (bool)loadingRows:(FlexGrid *_Nonnull)sender;

/**
 *  Occurs after the grid rows have been bound to items in the data source.
 *
 *  @param sender the sender object.
 */
- (void)loadedRows:(FlexGrid *_Nonnull)sender;

/**
 *   Occurs when a group is about to be expanded or collapsed.
 *
 *  @param sender the FlexGrid sender object.
 *  @param panel the FlexGridPanel event appears on.
 *  @param range the specified cell range.
 *
 *  @return true to cancel further processing, false to proceed by default
 */
- (bool)groupCollapsedChanging:(FlexGrid *_Nonnull)sender panel:(GridPanel *_Nonnull)panel forRange:(GridCellRange *_Nonnull)range;

/**
 *  Occurs after a group has been expanded or collapsed.
 *
 *  @param sender the FlexGrid sender object.
 *  @param panel the FlexGridPanel event appears on.
 *  @param range the specified cell range.
 */
- (void)groupCollapsedChanged:(FlexGrid *_Nonnull)sender panel:(GridPanel *_Nonnull)panel forRange:(GridCellRange *_Nonnull)range;

/**
 *  Occurs after the control has scrolled.
 *
 *  @param sender the sender object.
 */
- (void)scrollPositionChanged:(FlexGrid *_Nonnull)sender;

/**
 *  Occurs before selection changes.
 *
 *  @param sender the FlexGrid sender object.
 *  @param panel the FlexGridPanel event appears on.
 *  @param range the specified cell range.
 *
 *  @return true to cancel further processing, false to proceed by default
 */
- (bool)selectionChanging:(FlexGrid *_Nonnull)sender panel:(GridPanel *_Nonnull)panel forRange:(GridCellRange * _Nullable)range;

/**
 *  Occurs after selection changes.
 *
 *  @param sender the FlexGrid sender object.
 *  @param panel the FlexGridPanel event appears on.
 *  @param range the specified cell range.
 */
- (void)selectionChanged:(FlexGrid *_Nonnull)sender panel:(GridPanel *_Nonnull)panel forRange:(GridCellRange * _Nullable)range;

/**
 *  Occurs before the user applies a sort by tapping a column header.
 *
 *  @param sender the FlexGrid sender object.
 *  @param panel the FlexGridPanel event appears on.
 *  @param range the specified cell range.
 *
 *  @return true to cancel further processing, false to proceed by default
 */
- (bool)sortingColumn:(FlexGrid * _Nonnull)sender panel:(GridPanel *_Nonnull)panel forRange:(GridCellRange *_Nonnull)range;

/**
 *   Occurs after the user applies a sort by tapping a column header.
 *
 *  @param sender the FlexGrid sender object.
 *  @param panel the FlexGridPanel event appears on.
 *  @param range the specified cell range.
 */
- (void)sortedColumn:(FlexGrid *_Nonnull)sender panel:(GridPanel *_Nonnull)panel forRange:(GridCellRange *_Nonnull)range;

/**
 *  Occurs after the user performs a long press gesture
 *
 *  @param sender the FlexGrid sender object.
 *  @param panel the FlexGridPanel event appears on.
 *  @param range the specified cell range.
 */
- (void)cellLongPressed:(FlexGrid *_Nonnull)sender panel:(GridPanel *_Nonnull)panel forRange:(GridCellRange *_Nullable)range;

@end

/**
 *  Specifies the visibility of row and column headers.
 */
typedef NS_ENUM (NSInteger, GridHeadersVisibility){
    /**
     *  GridHeadersVisibilityNone
     */
    GridHeadersVisibilityNone = 0,
    /**
     *  GridHeadersVisibilityColumn
     */
    GridHeadersVisibilityColumn = 1,
    /**
     *  GridHeadersVisibilityRow
     */
    GridHeadersVisibilityRow = 1 << 1,
    /**
     *  GridHeadersVisibilityAll
     */
    GridHeadersVisibilityAll = GridHeadersVisibilityColumn|GridHeadersVisibilityRow
};

/**
 *  Specifies the visibility of grid lines.
 */
typedef NS_ENUM (NSInteger, GridLinesVisibility){
    /**
     *  GridLinesVisibilityNone
     */
    GridLinesVisibilityNone = 0,
    /**
     *  GridLinesVisibilityHorizontal
     */
    GridLinesVisibilityHorizontal = 1,
    /**
     *  GridLinesVisibilityVertical
     */
    GridLinesVisibilityVertical = 1 << 1,
    /**
     *  GridLinesVisibilityAll
     */
    GridLinesVisibilityAll = GridLinesVisibilityVertical | GridLinesVisibilityHorizontal
};


/**
 *  Specifies constants that define the flex grid detail provider behavior.
 */
typedef NS_ENUM (NSInteger, GridDetailVisibilityMode){
    /**
     *  GridDetailVisibilityModeNone
     */
    GridDetailVisibilityModeNone,
    /**
     *  GridDetailVisibilityModeExpandSingle
     */
    GridDetailVisibilityModeExpandSingle,
    /**
     *  GridDetailVisibilityModeExpandMultiple
     */
    GridDetailVisibilityModeExpandMultiple,
    /**
     *  GridDetailVisibilityModeSelection
     */
    GridDetailVisibilityModeSelection
};

/**
 *  Specifies constants that define the selection behavior.
 */
typedef NS_ENUM (NSInteger, GridAllowMerging){
    /**
     *  GridAllowMergingNone
     */
    GridAllowMergingNone = 0,
    
    /**
     *  GridAllowMergingCells
     */
    GridAllowMergingCells = 1 << 1,
    
    /**
     *  GridAllowMergingColumnHeaders
     */
    GridAllowMergingColumnHeaders = 1 << 2,
    
    /**
     *  GridAllowMergingRowHeaders
     */
    GridAllowMergingRowHeaders = 1 << 3,
    
    /**
     *  GridAllowMergingAllHeaders
     */
    GridAllowMergingAllHeaders = GridAllowMergingColumnHeaders | GridAllowMergingRowHeaders,
    
    /**
     *  GridAllowMergingAll
     */
    GridAllowMergingAll = GridAllowMergingCells | GridAllowMergingAllHeaders
};

/**
 *  Specifies constants that define the selection behavior.
 */
typedef NS_ENUM (NSInteger, GridSelectionMode){
    /**
     *  GridSelectionModeNone
     */
    GridSelectionModeNone,
    /**
     *  GridSelectionModeCell
     */
    GridSelectionModeCell,
    /**
     *  GridSelectionModeCellRange
     */
    GridSelectionModeCellRange,
    /**
     *  GridSelectionModeRow
     */
    GridSelectionModeRow,
    /**
     *  GridSelectionModeRowRange
     */
    GridSelectionModeRowRange
};

/**
 *  Specifies the selected state of a cell.
 */
typedef NS_ENUM (NSInteger, GridSelectedState){
    /**
     *  GridSelectedStateNone
     */
    GridSelectedStateNone,
    /**
     *  GridSelectedStateSelected
     */
    GridSelectedStateSelected,
    /**
     *  GridSelectedStateCursor
     */
    GridSelectedStateCursor
};

/**
 *  Specifies the grid auto size mode
 */
typedef NS_ENUM (NSInteger, GridAutoSizeMode){
    /**
     *  GridAutoSizeModeNone
     */
    GridAutoSizeModeNone = 0,
    /**
     *  GridAutoSizeModeCells
     */
    GridAutoSizeModeCells = 1 << 1,
    /**
     *  GridAutoSizeModeHeaders
     */
    GridAutoSizeModeHeaders = 1 << 2,
    /**
     *  GridAutoSizeModeBoth
     */
    GridAutoSizeModeBoth = GridAutoSizeModeCells | GridAutoSizeModeHeaders
};


@class GridRowAccessor;

/**
 *  The FlexGrid control provides a powerful and flexible way to display and edit data in a tabular format.
 */
IB_DESIGNABLE
@interface FlexGrid : XuniView<UIGestureRecognizerDelegate, UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate>
;

/**
 *  Get row accessor for provided row index
 *
 *  @param key     the specified row.
 *
 *  @return a GridRowAccessor value.
 */
- (nonnull GridRowAccessor*)objectAtIndexedSubscript:(int)key;

/**
 *  Occurs when the user taps the control. Event invoked with XuniPointEventArgs
 */
@property XuniEvent<XuniPointEventArgs*>  * _Nonnull flexGridTapped;

/**
 *  Occurs before the FlexGrid is being rendered. Event invoked with XuniEventArgs
 */
@property XuniEvent<XuniEventArgs*> * _Nonnull flexGridRendering;

/**
 *  Occurs when the FlexGrid has been rendered. Event invoked with XuniEventArgs
 */
@property XuniEvent<XuniEventArgs*> * _Nonnull flexGridRendered;

/**
 *  Occurs when the FlexGrid has been invalidated. Event invoked with XuniEventArgs
 */
@property XuniEvent<XuniEventArgs*> * _Nonnull flexGridInvalidated;

/**
 *  Occurs after the user applies a sort by tapping a column header. Event invoked with XuniEventArgs
 */
@property XuniEvent<XuniEventArgs*> * _Nonnull flexGridDroppedCaches;

/**
 *  Occurs when an element representing a cell has been created. Event invoked with GridFormatItemEventArgs
 */
@property XuniEvent<GridFormatItemEventArgs*> * _Nonnull flexGridFormatItem;

/**
 *  Occurs when cell overlay must be processed
 */
@property XuniEvent<GridFormatItemEventArgs*> *_Nonnull flexGridProcessItemOverlay;

/**
 *  Occurs when FlexGrid cell being tapped. Event invoked with FlexCellRangeEventArgs
 */
@property XuniEvent<GridCellRangeEventArgs*> *_Nonnull flexGridCellTapped;

/**
 *  Occurs when FlexGrid cell being double tapped. Event invoked with FlexCellRangeEventArgs
 */
@property XuniEvent<GridCellRangeEventArgs*> *_Nonnull flexGridCellDoubleTapped;

/**
 *  Occurs before a cell enters edit mode. Event invoked with FlexCellRangeEventArgs
 */
@property XuniEvent<GridCellRangeEventArgs*> *_Nonnull flexGridBeginningEdit;

/**
 *  Occurs when a cell edit is ending. Event invoked with FlexCellRangeEventArgs
 */
@property XuniEvent<GridCellRangeEventArgs*> *_Nonnull flexGridCellEditEnding;

/**
 *  Occurs after a cell edit has ended. Event invoked with FlexCellRangeEventArgs
 */
@property XuniEvent<GridCellRangeEventArgs*> *_Nonnull flexGridCellEditEnded;

/**
 *  Occurs when an editor cell is created and before it becomes active. Event invoked with FlexCellRangeEventArgs
 */
@property XuniEvent<GridCellRangeEventArgs*> *_Nonnull flexGridPrepareCellForEdit;

/**
 *  Occurs after the grid has been bound to a new items source. Event invoked with XuniEventArgs
 */
@property XuniEvent<XuniEventArgs*> *_Nonnull flexGridItemsSourceChanged;

/**
 *  Occurs before the grid rows are bound to items in the data source. Event invoked with XuniEventArgs
 */
@property XuniEvent<XuniEventArgs*> *_Nonnull flexGridLoadingRows;

/**
 *  Occurs after the grid rows have been bound to items in the data source. Event invoked with XuniEventArgs
 */
@property XuniEvent<XuniEventArgs*> *_Nonnull flexGridLoadedRows;

/**
 *  Occurs when a group is about to be expanded or collapsed. Event invoked with FlexCellRangeEventArgs
 */
@property XuniEvent<GridCellRangeEventArgs*> *_Nonnull flexGridGroupCollapsedChanging;

/**
 *  Occurs after a group has been expanded or collapsed. Event invoked with FlexCellRangeEventArgs
 */
@property XuniEvent<GridCellRangeEventArgs*> *_Nonnull flexGridGroupCollapsedChanged;

/**
 *  Occurs after the control has scrolled. Event invoked with XuniEventArgs
 */
@property XuniEvent<XuniEventArgs*> *_Nonnull flexGridScrollPositionChanged;

/**
 *  Occurs before selection changes. Event invoked with FlexCellRangeEventArgs
 */
@property XuniEvent<GridCellRangeEventArgs*> *_Nonnull flexGridSelectionChanging;

/**
 *  Occurs after selection changes. Event invoked with FlexCellRangeEventArgs
 */
@property XuniEvent<GridCellRangeEventArgs*> *_Nonnull flexGridSelectionChanged;

/**
 *  Occurs before the user applies a sort by tapping a column header. Event invoked with FlexCellRangeEventArgs
 */
@property XuniEvent<GridCellRangeEventArgs*> *_Nonnull flexGridSortingColumn;

/**
 *  Occurs after the user applies a sort by tapping a column header. Event invoked with FlexCellRangeEventArgs
 */
@property XuniEvent<GridCellRangeEventArgs*> *_Nonnull flexGridSortedColumn;

/**
 *  Occurs after the user applies a sort by tapping a column header. Event invoked with GridAutoGeneratingColumnEventArgs
 */
@property XuniEvent<GridAutoGeneratingColumnEventArgs*> *_Nonnull flexGridAutoGeneratingColumn;

/**
 *  Occurs after the user applies a sort by tapping a column header. Event invoked with GridResizedColumnEventArgs
 */
@property XuniEvent<GridResizedColumnEventArgs*> *_Nonnull flexGridResizedColumn;

/**
 *  Occurs after the user performs a long press gesture. Event invoked with GridCellRangeEventArgs
 */
@property XuniEvent<GridCellRangeEventArgs*> * _Nonnull flexGridCellLongPressed;

/**
 *  Drop the FlexGrid caches
 */
- (void)dropCaches;


/**
 *  Set the value stored in a cell in the scrollable area of the grid for unbound mode
 *
 *  @param data      the value should be stored in a cell in the scrollable area of the grid.
 *  @param r         the specified row.
 *  @param c         the specified column.
 */
- (void)setCellData:(NSObject * _Nullable)data forRow:(int)r inColumn:(int)c;


/**
 *  Return true if the FlexGrid is scroll to the bottom.
 *
 *  @return return a boolean value.
 */
- (bool)isScrolledToBottom;

/**
 *  Gets or sets a value that defines the grid's auto size mode
 */
@property (nonatomic) GridAutoSizeMode autoSizeMode;

/**
 *  Gets or sets a value that indicates which parts of the grid support cell merging
 */
@property (nonatomic) GridAllowMerging allowMerging;

/**
 *  Gets or sets the grid's merge manager
 */
@property (nonatomic) GridMergeManager * _Nullable mergeManager;

/**
 *  Gets or sets the grid's row detail provider
 */
@property (nonatomic) FlexGridDetailProvider * _Nullable detailProvider;

/**
 *  Enables or disables Touch Feedback capability
 */
@property IBInspectable BOOL touchFeedback;

/**
 *  Gets or sets whether the user can resize the grid's columns
 */
@property (nonatomic) IBInspectable BOOL allowResizing;

/**
 *  Get the column index of the column currently being resized.
 */
@property (readonly) int columnBeingSized;

/**
 *  Gets or sets the delegate for handling notifications.
 */
@property (nonatomic, weak) id<FlexGridDelegate> _Nullable delegate;

/**
 *  Gets or sets the grid data source for all series.
 */
@property (nonatomic) NSMutableArray * _Nullable itemsSource;

/**
 *  Gets the ICollectionView that contains the grid data.
 */
@property (nonatomic) XuniCollectionView * _Nullable collectionView;




/**
 *  Gets or sets a value that determines whether the row and column headers are visible.
 */
@property (nonatomic) GridHeadersVisibility headersVisibility;

/**
 *  Gets or sets the current selection mode.
 */
@property (nonatomic) GridSelectionMode selectionMode;

/**
 *  Gets or sets whether the grid should generate columns automatically based on the itemsSource.
 */
@property (nonatomic) IBInspectable BOOL autoGenerateColumns;

/**
 *  Gets or sets whether interaction is enabled for the user.
 */
@property (nonatomic) IBInspectable  BOOL isEnabled;

/**
 *  Gets or sets whether the user can edit the grid cells by double tapping them.
 */
@property (nonatomic) IBInspectable BOOL isReadOnly;

/**
 *  Gets or sets whether users are allowed to sort columns by clicking the column header cells.
 */
@property (nonatomic) IBInspectable BOOL allowSorting;

/**
 *  Gets or sets whether the grid should display sort indicators in the column headers.
 */
@property (nonatomic) IBInspectable BOOL showSort;

/**
 *  Gets or sets whether the grid should insert group rows to delimit data groups.
 */
@property (nonatomic) IBInspectable BOOL showGroups;

/**
 *  Gets the grid panel that contains the data cells.
 */
@property (readonly) GridPanel * _Nonnull cells;

/**
 *  Gets the grid panel that contains the column header cells.
 */
@property (readonly) GridPanel * _Nonnull columnHeaders;

/**
 *  Gets the grid panel that contains the row header cells.
 */
@property (readonly) GridPanel * _Nonnull rowHeaders;

/**
 *  Gets the grid panel that contains the top left cells.
 */
@property (readonly) GridPanel * _Nonnull topLeftCells;

/**
 *  Gets the grid's rows collection.
 */
@property (readonly) GridRowCollection * _Nonnull rows;

/**
 *  Gets the grid's columns collection.
 */
@property (readonly) GridColumnCollection * _Nonnull columns;

/**
 *  Gets the grid's client rectangle.
 */
@property (readonly) CGRect clientRect;

/**
 *  Gets or sets the current selection.
 */
@property (nonatomic) GridCellRange * _Nonnull selection;

/**
 *  Gets the UIView that represents the currently active cell editor.
 */
@property (nonatomic) UIView *_Nullable activeEditor;

/**
 *  Gets the underlying value of the currently active cell editor.
 */
@property (readonly) NSObject *_Nullable activeEditorValue;

/**
 *  Gets a cell range that identifies the cell currently being edited.
 */
@property (readonly) GridCellRange *_Nullable editRange;

/**
 *  Gets the range of cells currently in view.
 */
@property (readonly) GridCellRange *_Nonnull viewRange;

/**
 *  Gets the cell factory that creates and updates cells for this grid.
 */
@property (nonatomic) GridCellFactory *_Nonnull cellFactory;

/**
 *  Gets or sets the border stroke color of the control.
 */
@property (nonatomic) IBInspectable UIColor *_Nonnull frozenCellsBorderColor;

/**
 *  Gets or sets the foreground color for text and symbols on the control.
 */
@property (nonatomic) IBInspectable UIColor *_Nonnull textColor;

/**
 *  Gets or sets the font for the control.
 */
@property (nonatomic) UIFont * _Nonnull font;

/**
 *  Gets or sets the color that is used for the background of odd-numbered rows.
 */
@property (nonatomic) IBInspectable UIColor *_Nonnull alternatingRowBackgroundColor;

/**
 *  Gets or sets the background color of the column headers.
 */
@property (nonatomic) IBInspectable UIColor * _Nonnull columnHeaderBackgroundColor;

/**
 *  Gets or sets the text color of the column headers.
 */
@property (nonatomic) IBInspectable UIColor * _Nonnull columnHeaderTextColor;

/**
 *  Gets or sets the font for the column headers.
 */
@property (nonatomic) UIFont * _Nonnull columnHeaderFont;

/**
 *  Gets or sets the color that is used to paint the lines between cells.
 */
@property (nonatomic) IBInspectable UIColor * _Nonnull gridLinesColor;

/**
 *  Gets or sets a value that indicates which grid lines are visible.
 */
@property (nonatomic) GridLinesVisibility gridLinesVisibility;

/**
 *  Gets or sets the gridline thickness.
 */
@property (nonatomic) IBInspectable double gridLinesWidth;

/**
 *  Gets or sets the format string used to create the group header content.
 */
@property (nonatomic) IBInspectable NSString *_Nonnull groupHeaderFormat;

/**
 *  Gets or sets the background color of grouped rows.
 */
@property (nonatomic) IBInspectable UIColor *_Nonnull groupRowBackgroundColor;

/**
 *  Gets or sets the text color of grouped rows.
 */
@property (nonatomic) IBInspectable UIColor *_Nonnull groupRowTextColor;

/**
 *  Gets or sets the color that is used to paint the lines between row and column header cells.
 */
@property (nonatomic) IBInspectable UIColor * _Nonnull headerGridLinesColor;

/**
 *  Gets or sets the background color of the selected column and row headers.
 */
@property (nonatomic) IBInspectable UIColor *_Nonnull headerSelectedBackgroundColor;

/**
 *  Gets or sets the text color for selected column and row headers.
 */
@property (nonatomic) IBInspectable UIColor *_Nonnull headerSelectedTextColor;

/**
 *  Gets or sets the background color of the row headers.
 */
@property (nonatomic) IBInspectable UIColor *_Nonnull rowHeaderBackgroundColor;

/**
 *  Gets or sets the text color of the row headers.
 */
@property (nonatomic) IBInspectable UIColor *_Nonnull rowHeaderTextColor;

/**
 *  Gets or sets the font for the row headers.
 */
@property (nonatomic) UIFont *_Nonnull rowHeaderFont;

/**
 *  Gets or sets the color used to fill the selection adorners.
 */
@property (nonatomic) IBInspectable UIColor * _Nonnull selectionAdornerColor;

/**
 *  Gets or sets the border color of the selection adorners.
 */
@property (nonatomic) IBInspectable UIColor * _Nonnull selectionAdornerBorderColor;

/**
 *  Gets or sets the background color of selected cells.
 */
@property (nonatomic) IBInspectable UIColor * _Nonnull selectionBackgroundColor;

/**
 *  Gets or sets the text color of selected cells.
 */
@property (nonatomic) IBInspectable UIColor * _Nonnull selectionTextColor;

/**
 *  Gets or sets the indent used to offset row groups of different levels.
 */
@property (nonatomic) IBInspectable double treeIndent;

/**
 *  Gets a value that indicates whether the control is currently handling a touch event.
 */
@property (readonly) BOOL isTouching;

/**
 *  Gets a value that indicates whether the control is currently being updated.
 */
@property (readonly) BOOL isUpdating;

/**
 *  Gets or sets a point that represents the grid's scroll position.
 */
@property (nonatomic) CGPoint scrollPosition;

/**
 *  Gets or sets the number of frozen rows
 */
@property (nonatomic) IBInspectable int frozenRows;

/**
 *  Gets or sets the number of frozen columns
 */
@property (nonatomic) IBInspectable int frozenColumns;

/**
 *  Gets or sets the row that displays column headers
 */
@property (nonatomic) GridRow* _Nonnull columnHeaderRow;

/**
 *  Gets the long press gesture recognizer to change its params
 */
@property (nonatomic, readonly) UILongPressGestureRecognizer* _Nonnull longPressRecognizer;

/**
 *  Gets or sets the value formatter
 */
@property (nonatomic) NSObject<IXuniValueFormatter> * _Nullable valueFormatter;

/**
 *  Refreshes the grid display.
 */
- (void)invalidate;

/**
 *  Gets the bounds of a cell in viewport coordinates.
 *
 *  @param r the specified row.
 *  @param c the specified column.
 *
 *  @return the bounds of a cell in viewport coordinates.
 */
- (CGRect)getCellRectForRow:(int)r inColumn:(int)c;

/**
 *  Gets the value stored in a cell in the scrollable area of the grid.
 *
 *  @param r         the specified row.
 *  @param c         the specified column.
 *  @param formatted whether is formatted.
 *
 *  @return the value stored in a cell in the scrollable area of the grid.
 */
- (NSObject * _Nullable)getCellDataForRow:(int)r inColumn:(int)c formatted:(BOOL)formatted;

/**
 *  Gets a FlexSelectedState value that indicates the selected state of a cell.
 *
 *  @param r the specified row.
 *  @param c the specified column.
 *
 *  @return a FlexSelectedState value that indicates the selected state of a cell.
 */
- (GridSelectedState)getSelectedStateForRow:(int)r inColumn:(int)c;

/**
 *  Starts editing a given cell.
 *
 *  @param fullEdit whether is fully edit.
 *  @param row      the specified row.
 *  @param column   the specified column.
 *
 *  @return a boolean value.
 */
- (BOOL)startEditing:(BOOL)fullEdit row:(int)row column:(int)column;

/**
 *  Commits any pending edits and exits edit mode.
 *
 *  @param cancel whether is cancel.
 *
 *  @return a boolean value.
 */
- (BOOL)finishEditing:(BOOL)cancel;

/**
 *  Collapses all the group rows to a given level.
 *
 *  @param level the specified level.
 */
- (void)collapseGroupsToLevel:(int)level;

/**
 *  Gets a FlexHitTestInfo object with information about a given point.
 *
 *  @param point the specified point.
 *
 *  @return a FlexHitTestInfo object with information about a given point.
 */
- (GridHitTestInfo * _Nonnull)hitTest:(CGPoint)point;

/**
 *  Scrolls the grid to bring a specific cell into view.
 *
 *  @param r the specified row.
 *  @param c the specified column.
 *  @return true if the grid was scrolled
 */
- (bool)scrollIntoView:(int)r c:(int)c;

/**
 *  Selects a cell range and optionally scrolls it into view.
 *
 *  @param range the specified range.
 *  @param show  whether shows.
 */
- (void)selectCellRange:(GridCellRange * _Nullable)range show:(BOOL)show;

/**
 *  Selects a cell range and scrolls it into view.
 *
 *  @param range the specified range.
 */
- (void)selectCellRange:(GridCellRange * _Nullable)range;

/**
 *  Resizes a column to fit its contents.
 *
 *  @param column the specified column.
 */
- (void)autoSizeColumn:(int)column;


/**
 *  Resizes a column to fit its contents.
 *
 *  @param column the specified column.
 *  @param header whether the column index refers to a regular or a header row column
 */
- (void)autoSizeColumn:(int)column header:(bool)header;

/**
 *  Resizes a column to fit its contents.
 *
 *  @param column the specified column.
 *  @param header whether the column index refers to a regular or a header row column
 *  @param extra the extra space
 */
- (void)autoSizeColumn:(int)column header:(bool)header extra:(int)extra;

/**
 *  Resizes all columns of a grid to fit their contents.
 *
 */
- (void)autoSizeColumns;

/**
 *  Resizes a range of columns to fit their contents.
 *
 *  @param first the first column.
 *  @param last  the last column.
 */
- (void)autoSizeColumns:(int)first to:(int)last;

/**
 *  Resizes a range of columns to fit their contents.
 *
 *  @param first the first column.
 *  @param last  the last column.
 *  @param header whether the column index refers to a regular or a header row column
 */
- (void)autoSizeColumns:(int)first to:(int)last header:(bool)header;

/**
 *  Resizes a range of columns to fit their contents.
 *
 *  @param first the first column.
 *  @param last  the last column.
 *  @param header whether the column index refers to a regular or a header row column
 *  @param extra the extra space
 */
- (void)autoSizeColumns:(int)first to:(int)last header:(bool)header extra:(int)extra;


/**
 *  Resizes a row to fit its contents.
 *
 *  @param row the specified row.
 */
- (void)autoSizeRow:(int)row;


/**
 *  Resizes a row to fit its contents.
 *
 *  @param row the specified row.
 *  @param header whether the row index refers to a regular or a header column row
 */
- (void)autoSizeRow:(int)row header:(bool)header;


/**
 *  Resizes a row to fit its contents.
 *
 *  @param row the specified row.
 *  @param header whether the row index refers to a regular or a header column row
 *  @param extra the extra space
 */
- (void)autoSizeRow:(int)row header:(bool)header extra:(int)extra;


/**
 *  Resizes all rows of a grid to fit their contents.
 *
 */
- (void)autoSizeRows;

/**
 *  Resizes a range of rows to fit their contents.
 *
 *  @param first the first row.
 *  @param last  the last row.
 */
- (void)autoSizeRows:(int)first to:(int)last;

/**
 *  Resizes a range of rows to fit their contents.
 *
 *  @param first the first row.
 *  @param last  the last row.
 *  @param header whether the row index refers to a regular or a header column row
 */
- (void)autoSizeRows:(int)first to:(int)last header:(bool)header;


/**
 *  Resizes a range of rows to fit their contents.
 *
 *  @param first the first row.
 *  @param last  the last row.
 *  @param header whether the row index refers to a regular or a header column row
 *  @param extra the extra space
 */
- (void)autoSizeRows:(int)first to:(int)last header:(bool)header extra:(int)extra;

// Internal
/**
 *  Gets or sets the originX of the grid.
 */
@property (readonly) double originX;
/**
 *  Gets or sets the originY of the grid.
 */
@property (readonly) double originY;
/**
 *  Gets or sets the offset of the cell.
 */
@property (readonly) CGPoint offset;
/**
 *  Draw grid in the rect.
 *
 *  @param rect the specified rect.
 */
- (void)drawRect:(CGRect)rect;
/**
 *  Add items to the group.
 *
 *  @param name  the group name.
 *  @param items the specified items.
 */
- (void)addGroup:(NSString * _Nonnull)name withItems:(NSMutableArray * _Nonnull)items;
/**
 *  Remove specified item from the group.
 *
 *  @param name  the group name.
 *  @param index the item index.
 */
- (void)removeFromGroup:(NSString * _Nonnull)name atIndex:(int)index;
/**
 *  Add item to the collectionView.
 *
 *  @param item the specified item.
 */
- (void)addItem:(NSObject * _Nonnull)item;
/**
 *  Get the default row size.
 *
 *  @return the default row size.
 */
- (int)defaultRowSize;



//################## Syntax <candies> for Interface Builder design-time configuration that are bound to FlexGrid API

/**
 *  Gets or sets column header visibility.
 */
@property (nonatomic) IBInspectable BOOL columnHeaderVisible;

/**
 *  Gets or sets row header visibility.
 */
@property (nonatomic) IBInspectable BOOL rowHeaderVisible;

/**
 *  Gets or sets horizontal grid lines visibility.
 */
@property (nonatomic) IBInspectable BOOL horizontalLinesVisible;

/**
 *  Gets or sets vertical grid lines visibility.
 */
@property (nonatomic) IBInspectable BOOL verticalLinesVisible;

/**
 *  Gets or sets cell font name.
 */
@property (nonatomic) IBInspectable NSString* _Nonnull fontName;

/**
 *  Gets or sets cell font size.
 */
@property (nonatomic) IBInspectable CGFloat fontSize;

/**
 *  Gets or sets column header font name.
 */
@property (nonatomic) IBInspectable NSString* _Nonnull columnHeaderFontName;

/**
 *  Gets or sets column header font size.
 */
@property (nonatomic) IBInspectable CGFloat columnHeaderFontSize;

/**
 *  Gets or sets row header font name.
 */
@property (nonatomic) IBInspectable NSString* _Nonnull rowHeaderFontName;

/**
 *  Gets or sets row header font size.
 */
@property (nonatomic) IBInspectable CGFloat rowHeaderFontSize;

/**
 *  Turns context menu on or off
 */
@property (nonatomic) IBInspectable BOOL defaultContextMenu;

@end
