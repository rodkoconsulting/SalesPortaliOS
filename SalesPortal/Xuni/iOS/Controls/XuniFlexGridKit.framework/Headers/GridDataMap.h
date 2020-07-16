//
//  GridDataMap.h
//  FlexGrid
//
//  Copyright (c) GrapeCity, Inc. All rights reserved.
//

#ifndef XUNI_INTERNAL_DYNAMIC_BUILD

#ifndef XuniCoreKit_h
#import "XuniCore/CollectionView.h"
#endif

#else

#import <XuniCoreDynamicKit/XuniCoreDynamicKit.h>

#endif

/**
 * Class GridDataMap.
 */
@interface GridDataMap : NSObject

/**
 *  Initialize an object for GridDataMap with array.
 *
 *  @param array the specified array.
 *
 *  @return an object for GridDataMap
 */
- (id _Nonnull)initWithArray:(NSArray *_Nonnull)array;

/**
 *  Initialize an object for GridDataMap with parameters.
 *
 *  @param array             the specified array.
 *  @param selectedValuePath the specified selectedValuePath.
 *  @param displayMemberPath the specified displayMemberPath.
 *
 *  @return an object for GridDataMap
 */
- (id _Nonnull)initWithArray:(NSArray *_Nonnull)array selectedValuePath:(NSString *_Nonnull)selectedValuePath displayMemberPath:(NSString *_Nonnull)displayMemberPath;

/**
 *  Initialize an object for GridDataMap with parameters.
 *
 *  @param items             the specified items.
 *  @param selectedValuePath the specified selectedValuePath.
 *  @param displayMemberPath the specified displayMemberPath.
 *
 *  @return an object for GridDataMap
 */
- (id _Nonnull)initWithCollectionView:(XuniCollectionView *_Nonnull)items selectedValuePath:(NSString *_Nonnull)selectedValuePath displayMemberPath:(NSString *_Nonnull)displayMemberPath;

/**
 *  Gets the ICollectionView that contains the grid data.
 */
@property (readonly) XuniCollectionView * _Nonnull collectionView;

/**
 *  Gets the name of the property to use as a key for the item (data values).
 */
@property (readonly) NSString * _Nonnull selectedValuePath;

/**
 *  Gets the name of the property to use as the visual
 *  representation of the items.
 */
@property (readonly) NSString * _Nonnull displayMemberPath;

/**
 *  Gets the key that corresponds to a given display value.
 *
 *  @param displayValue the specified displayValue.
 *
 *  @return the key that corresponds to a given display value.
 */
- (NSObject * _Nullable)getKeyValue:( NSString * _Nonnull)displayValue;

/**
 *  Gets the display value that corresponds to a given key.
 *
 *  @param key the specified key.
 *
 *  @return the display value that corresponds to a given key.
 */
- (NSObject * _Nullable)getDisplayValue:( NSObject * _Nonnull)key;

/**
 *  Gets an array with all display values on this map.
 *
 *  @return an array.
 */
- (NSArray * _Nonnull)getDisplayValues;

/**
 *  Gets an array with all keys on this map.
 *
 *  @return an array.
 */
- (NSArray * _Nonnull)getKeyValues;

/**
 *  Gets the zero-based index that corresponds to a given display value.
 *
 *  @param displayValue the specified displayValue.
 *
 *  @return the zero-based index that corresponds to a given display value.
 */
- (int)displayIndexOf:(NSString * _Nonnull)displayValue;

@end
