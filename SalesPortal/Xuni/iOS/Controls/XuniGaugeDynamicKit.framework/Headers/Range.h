//
//  Range.h
//  FlexGauge
//
//  Copyright (c) GrapeCity, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class XuniGauge;

/**
 *  XuniGaugeRange
 */
@interface XuniGaugeRange : NSObject

/**
*  Gets or sets the background color of the range.
*/
@property (nonatomic) UIColor* color;

/**
 *  ​Gets or sets the thickness of the range.
 */
@property (nonatomic) double thickness;

/**
 *  Gets or sets the border color of the range.
 */
@property (nonatomic) UIColor* borderColor;

/**
 *  ​Gets or sets the border width of the range.
 */
@property (nonatomic) double borderWidth;

/**
 *  Gets or sets the border dashes of the range.
 */
@property (nonatomic) NSArray<NSNumber*>* borderDashes;

/**
 *  Gets or sets the minimum value for this range.
 */
@property (nonatomic) double min;

/**
 *  Gets or sets the maximun value for this range.
 */
@property (nonatomic) double max;

/**
 *  Gets or sets the name value for this range.
 */
@property (nonatomic) NSString *name;

/**
 *  Initialize an instance for the XuniGaugeRange with the specified gague.
 *
 *  @param gauge the specified gague.
 *
 *  @return an instance for the XuniGaugeRange
 */
- (id)initWithGauge:(XuniGauge*)gauge;

@end
