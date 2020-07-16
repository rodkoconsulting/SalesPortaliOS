//
//  GridColumn.h
//  FlexGrid
//
//  Copyright (c) GrapeCity, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GridRowCol.h"
#import "GridDataMap.h"

#ifndef XUNI_INTERNAL_DYNAMIC_BUILD

#ifndef XuniCoreKit_h
#import "XuniCore/Aggregate.h"
#import "XuniCore/Util.h"
#endif

#else

#import <XuniCoreDynamicKit/XuniCoreDynamicKit.h>

#endif

/**
 *  Specifies how the width property is interpreted for a column.
 */
typedef NS_ENUM (NSInteger, GridColumnWidth){
    /**
     *  GridColumnWidthAuto.
     */
    GridColumnWidthAuto,
    /**
     *  GridColumnWidthPixel.
     */
    GridColumnWidthPixel,
    /**
     *  GridColumnWidthStar.
     */
    GridColumnWidthStar
};

/**
 *  Class GridColumn.
 */
@interface GridColumn : GridRowCol

/**
 *  Initialize an object for GridColumn.
 *
 *  @return an object for GridColumn.
 */
- (id _Nonnull)init;


/**
 *  Gets or sets the text alignment
 */
@property (nonatomic) NSTextAlignment horizontalAlignment;

/**
 *  Gets or sets the header text alignment
 */
@property (nonatomic) NSTextAlignment headerHorizontalAlignment;

/**
 *  Gets or sets the name of this column.
 */
@property (nonatomic) NSString * _Null_unspecified name;

/**
 *  Gets or sets the type of value stored in this column.
 */
@property (nonatomic) XuniDataType dataType;

/**
 *  Gets or sets whether values in this column are required.
 */
@property (nonatomic) BOOL required;

/**
 *  Gets or sets the keyboard type used to edit values in this column.
 */
@property (nonatomic) UIKeyboardType inputType;

/**
 *  Gets or sets a mask to be used while editing values in this column.
 */
@property (nonatomic) NSString * _Nullable mask;

/**
 *  Gets or sets the name of the property this column is bound to.
 */
@property (nonatomic) NSString * _Nullable binding;

/**
 *  Gets or sets the width of this column.
 */
@property (nonatomic) double width;

/**
 *  Gets or sets how the width property is interpreted for this column.
 */
@property (nonatomic) GridColumnWidth widthType;

/**
 *  Gets or sets the minimum width of this column.
 */
@property (nonatomic) int minWidth;

/**
 *  Gets or sets the maximum width of this column.
 */
@property (nonatomic) int maxWidth;

/**
 *  Gets the render width of this column.
 */
@property (readonly) int renderWidth;

/**
 *  Gets or sets the text displayed in the column header.
 */
@property (nonatomic) NSString * _Nullable header;

/**
 *  Gets or sets the data map used to convert raw values into display values for this column.
 */
@property (nonatomic) GridDataMap * _Nullable dataMap;

/**
 *   Gets or sets the format string used to convert raw values into display values for this column.
 */
@property (nonatomic) NSString *  _Nullable format;

/**
 *  Gets or sets the NSFormatter object used to convert raw values into display values for this column.
 */
@property (nonatomic) NSFormatter * _Nullable formatter;

/**
 *  Gets or sets whether the user can sort this column by clicking its header.
 */
@property (nonatomic) BOOL allowSorting;

/**
 *  Gets the current sort direction for this column.
 */
@property (readonly) NSComparisonResult sortDirection;

/**
 *  Gets or sets the aggregate to display in group header rows for this column.
 */
@property (nonatomic) XuniAggregate aggregate;

/**
 *  Gets or sets the name of the property to use when sorting this column.
 */
@property (nonatomic) NSString * _Nullable sortMemberPath;

/**
 *  Gets the name of the property to use when sorting this column.
 */
- (NSString * _Nullable)getSortMemberPath;

/**
 *  Get bound data type.
 *
 *  @param target the target.
 *
 *  @return the data type of the binding.
 */
- (XuniDataType)getBoundDataType:(NSObject * _Nonnull)target;

/**
 *  Get bound value.
 *
 *  @param target the target.
 *
 *  @return a bound value.
 */
- (NSObject * _Nullable)getBoundValue:(NSObject * _Nonnull)target;

/**
 *  Set bound value for the target.
 *
 *  @param value  the specified value.
 *  @param target the target.
 */
- (void)setBoundValue:(NSObject * _Nullable)value forTarget:(NSObject * _Nonnull)target;

/**
 *  Get formatted value.
 *
 *  @param value the value.
 *
 *  @return a formatted value.
 */
- (NSObject * _Nullable)getFormattedValue:(NSObject * _Nullable)value;

/**
 *  Get formatted header.
 *
 *  @return formatted header object.
 */
- (NSObject * _Nullable)getFormattedHeader;

/**
 *  Internal, set the direction to sort this column by.
 *
 *  @param direction the direction to sort by.
 */
- (void)setSortDirection:(NSComparisonResult)direction;

@end
