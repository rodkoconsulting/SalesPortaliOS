//
//  GridCellFactory.h
//  FlexGrid
//
//  Copyright (c) GrapeCity, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "GridPanel.h"
#import "GridCellRange.h"

/**
 *  Class GridCellFactory.
 */
@interface GridCellFactory : NSObject

/**
 *  Update cells with parameters.
 *
 *  @param panel   the specified panel.
 *  @param r       the specified row.
 *  @param c       the specified column.
 *  @param context the specified context.
 *  @param rng     the specified range.
 */
- (void)updateCell:( GridPanel *_Nonnull)panel row:(int)r column:(int)c context:(CGContextRef _Nonnull)context range:(GridCellRange *_Nullable)rng;

/**
 *  Create a custom cell editor.
 *
 *  @param panel   the specified panel.
 *  @param rng     the specified range.
 */
- (UIView * _Nonnull)createCellEditor:(GridPanel *_Nonnull)panel range:(GridCellRange *_Nullable)rng;

@end
