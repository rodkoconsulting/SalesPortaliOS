//
//  NativeControlCellFactory.h
//  FlexGrid
//
//  Copyright © 2016 C1Marketing. All rights reserved.
//

#import "GridCellFactory.h"
#import "GridEventArgs.h"

/**
 *  Delegate class for handling NativeControlGridCellFactory cell generation
 */
@protocol NativeControlGridCellFactoryDelegate<NSObject>
@optional
/**
 *  Occurs when an element representing a cell has been created.
 *
 *  @param sender the FlexGrid sender object.
 *  @param panel the FlexGridPanel event appears on.
 *  @param range the specified cell range.
 *
 *  @return UIView for the native cell
 */
- (UIView* _Nonnull)createViewForCell:(FlexGrid *_Nonnull )sender panel:(GridPanel *_Nonnull )panel forRange:(GridCellRange *_Nullable)range;

@end

/**
 * Class GridFormatItemEventArgs.
 */
@interface GridCreateViewForCellEventArgs : GridCellRangeEventArgs

/**
 *  Initialize an object for GridFormatItemEventArgs.
 *
 *  @param panel   the sepcified panel.
 *  @param range   the sepcified range.
 *
 *  @return an object for GridFormatItemEventArgs.
 */
- (id _Nonnull)initWithPanel:(GridPanel *_Nonnull )panel forRange:(GridCellRange *_Nullable)range;

/**
 *   Get or sets the view that will be the resulting grid cell view.
 */
@property UIView *_Nullable view;


@end

/**
 *  Class NativeControlGridCellFactory.
 */
@interface NativeControlGridCellFactory : GridCellFactory
/**
 *  Gets the owning grid for the factory.
 */
@property (readonly) FlexGrid* _Nonnull grid;

/**
 *   Gets or sets the NativeControlGridCellFactoryDelegate associated with the factory.
 */
@property id<NativeControlGridCellFactoryDelegate> _Nullable delegate;

/**
 *  Occurs when the native cell view must be created
 */
@property XuniEvent<GridCreateViewForCellEventArgs*> * _Nonnull createViewForCell;

/**
 *  Initialize an object for NativeControlGridCellFactory.
 *
 *  @param grid     the specified grid that owns the factory.
 *
 *  @return an object for NativeControlGridCellFactory.
 */
-(instancetype _Nonnull)initWithGrid:(FlexGrid* _Nonnull)grid;
@end
