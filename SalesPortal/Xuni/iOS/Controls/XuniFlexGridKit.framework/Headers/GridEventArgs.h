//
//  GridEventArgs.h
//  FlexGrid
//
//  Copyright (c) GrapeCity, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#ifndef XUNI_INTERNAL_DYNAMIC_BUILD

#ifndef XuniCoreKit_h
#import "XuniCore/Event.h"
#endif

#else

#import <XuniCoreDynamicKit/XuniCoreDynamicKit.h>

#endif

#import "GridCellRange.h"
#import "GridRow.h"
#import "GridColumn.h"

/**
 * Class GridCellRangeEventArgs.
 */
@interface GridCellRangeEventArgs : XuniCancelEventArgs

/**
 *  Initialize an object for GridCellRangeEventArgs.
 *
 *  @param panel the sepcified panel.
 *  @param range the sepcified range.
 *
 *  @return an object for GridCellRangeEventArgs.
 */
- (id _Nonnull)initWithPanel:(GridPanel * _Nonnull)panel forRange:(GridCellRange * _Nullable)range;

/**
 *  Gets the index of the row affected by this event.
 */
@property (readonly) int row;

/**
 *  Gets the index of the column affected by this event.
 */
@property (readonly) int col;

/**
 *  Gets the grid panel affected by this event.
 */
@property (readonly) GridPanel * _Nonnull panel;

/**
 *  Gets the cell range affected by this event.
 */
@property (readonly) GridCellRange * _Nullable cellRange;

@end

/**
 * Class GridFormatItemEventArgs.
 */
@interface GridFormatItemEventArgs : GridCellRangeEventArgs

/**
 *  Initialize an object for GridFormatItemEventArgs.
 *
 *  @param panel   the sepcified panel.
 *  @param range   the sepcified range.
 *  @param context the sepcified context.
 *
 *  @return an object for GridFormatItemEventArgs.
 */
- (id _Nonnull)initWithPanel:(GridPanel * _Nonnull)panel forRange:(GridCellRange * _Nonnull)range inContext:(CGContextRef _Nonnull)context;

/**
 *   Gets the graphics context to use for drawing operations.
 */
@property (readonly) CGContextRef _Nonnull context;

@end

/**
 * Class GridDetailCellCreatingEventArgs.
 */
@interface GridDetailCellCreatingEventArgs : XuniCancelEventArgs

/**
 *   Get or sets the view that will be the resulting grid detail view.
 */
@property UIView * _Nullable view;


/**
 *   Gets the FlexRow for each the detail cell view is being generated.
 */
@property (readonly) GridRow * _Nonnull row;

/**
 *  Initialize an object for GridDetailCellCreatingEventArgs.
 *
 *  @param row   the sepcified FlexRow to create details for.
 *
 *  @return an object for GridDetailCellCreatingEventArgs.
 */
- (id _Nonnull)initWithRow:(GridRow *_Nonnull)row;
@end

/**
 * Class GridRowHeaderLoadingEventArgs.
 */
@interface GridRowHeaderLoadingEventArgs : XuniCancelEventArgs
/**
 *   Gets or sets the button generated for grid row header display.
 */
@property UIButton *_Nullable button;

/**
 *   Gets the FlexRow for each the detail cell view is being generated.
 */
@property (readonly) GridRow *_Nonnull row;

/**
 *  Initialize an object for GridRowHeaderLoadingEventArgs.
 *
 *  @param row   the sepcified FlexRow to create details for.
 *  @param button   the initial dummy button for generating the grid row header
 *
 *  @return an object for GridRowHeaderLoadingEventArgs.
 */
- (id _Nonnull)initWithRow:(GridRow * _Nonnull)row withButton:(UIButton * _Nonnull)button;
@end

/**
 * Class GridAutoGeneratingColumnEventArgs.
 */
@interface GridAutoGeneratingColumnEventArgs : XuniCancelEventArgs
/**
 *   Gets the XuniPropertyInfo for each the column is being generated.
 */
@property (readonly) XuniPropertyInfo * _Nonnull propertyInfo;

/**
 *   Gets or sets the FlexColumn being generated.
 */
@property GridColumn *_Nonnull column;

/**
 *  Initialize an object for GridAutoGeneratingColumnEventArgs.
 *
 *  @param column   the sepcified FlexColumn initially generated.
 *  @param propertyInfo   the XuniPropertyInfo object for the property the column is being generated for.
 *
 *  @return an object for GridAutoGeneratingColumnEventArgs.
 */
- (id _Nonnull)initWithColumn:(GridColumn * _Nonnull)column andPropertyInfo:(XuniPropertyInfo * _Nonnull)propertyInfo;
@end

/**
 * Class GridResizedColumnEventArgs.
 */
@interface GridResizedColumnEventArgs : XuniEventArgs
/**
 *   Gets the FlexColumn being resized.
 */
@property (readonly) GridColumn * _Nonnull column;

/**
 *  Initialize an object for GridResizedColumnEventArgs.
 *
 *  @param column   the sepcified FlexColumn being resized.
 *
 *  @return an object for GridResizedColumnEventArgs.
 */
- (id _Nonnull)initWithColumn:(GridColumn * _Nonnull)column;
@end
