//
//  GridDetailProvider.h
//  FlexGrid
//
//  Copyright © 2016 C1Marketing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FlexGrid.h"
#import "GridRow.h"

/**
 *  Delegate class for handling FlexGrid detail cell generation
 */
@protocol FlexGridDetailProviderDelegate<NSObject>
@optional

/**
 *  Occurs when the detail cell must be created
 *
 *  @param sender the sender FlexGridDetailProvider object.
 *  @param row the specified row for which detail view is created
 *
 *  @return a UIView for the cell details or null when no details are available
 */
- (UIView *_Nullable)detailCellCreating:(FlexGridDetailProvider * _Nonnull )sender row:(GridRow * _Nonnull)row;

/**
 *  Occurs when the detail expand button must be created
 *
 *  @param sender the sender FlexGridDetailProvider object.
 *  @param row the specified row for which detail expand button is created
 *  @param defaultButton default detail expand button
 *
 *  @return a UIButton for the grid row detail expand button or null when no button
 */
- (UIButton *_Nullable)gridRowHeaderLoading:(FlexGridDetailProvider *_Nonnull)sender row:(GridRow *_Nonnull)row defaultButton:(UIButton *_Nonnull)defaultButton;
@end


/**
 * Class GridDetailProvider.
 */
@interface FlexGridDetailProvider : NSObject
/**
 *   Gets the FlexGrid associated with the GridDetailProvider.
 */
@property (readonly) FlexGrid * _Nonnull grid;

/**
 *   Gets or sets the GridDetailProviderDelegate associated with the details provider.
 */
@property (nonatomic, weak) NSObject<FlexGridDetailProviderDelegate> * _Nullable delegate;

/**
 *   Gets or sets the FlexGrid detail row height.
 */
@property (nonatomic) CGFloat detailHeight;

/**
 *   Defines expand button behavior.
 */
@property (nonatomic) bool showExpandButton;

/**
 *   Gets or sets the details visibility mode.
 */
@property (nonatomic) GridDetailVisibilityMode detailVisibilityMode;

/**
 *  Occurs when the detail cell must be created
 */
@property XuniEvent<GridDetailCellCreatingEventArgs*> * _Nonnull detailCellCreating;

/**
 *  Occurs when the detail expand button must be created
 */
@property XuniEvent<GridRowHeaderLoadingEventArgs*> * _Nonnull gridRowHeaderLoading;

/**
 *  Initialize an object for GridDetailProvider.
 *
 *  @param grid   the sepcified FlexGrid.
 *
 *  @return an object for GridDetailProvider.
 */
- (id _Nonnull)initWithGrid:(FlexGrid *_Nonnull)grid;

/**
 *   Show detail for row.
 *
 *  @param row the row to show details for.
 */
- (void)showDetail:(GridRow* _Nonnull)row;

/**
 *   Show details for row with hiding details for other rows.
 *
 *  @param row the row to show details for.
 *  @param hideOthers whether to hide details for other rows.
 */
- (void)showDetail:(GridRow*_Nonnull )row hideOthers:(bool)hideOthers;

/**
 *   Hide details for row.
 *
 *  @param row the row to hide details for.
 */
- (void)hideDetail:(GridRow* _Nullable)row;
@end
