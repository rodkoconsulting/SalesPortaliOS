//
//  BaseDataLabel.h
//  XuniChartCore
//
//  Copyright (c) GrapeCity, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifndef XuniChartCoreKit_h
#import "FlexChartBase.h"
#endif

/**
 *  XuniBaseDataLabel.
 */
@interface XuniBaseDataLabel : NSObject
{
    FlexChartBase* _chart;
}

/**
 *  Gets or sets the content of datalabel.
 */
@property(nonatomic) NSString* content;

/**
 *  Gets or sets the background color of datalabel.
 */
@property(nonatomic) UIColor* dataLabelBackgroundColor;

/**
 *  Gets or sets the border color of datalabel.
 */
@property(nonatomic) UIColor* dataLabelBorderColor;

/**
 *  Gets or sets the border width of datalabel.
 */
@property(nonatomic) double dataLabelBorderWidth;

/**
 *  Gets or sets the font of datalabel.
 */
@property(nonatomic) UIFont* dataLabelFont;

/**
 *  Gets or sets the font color of datalabel.
 */
@property(nonatomic) UIColor* dataLabelFontColor;

/**
 *  Gets or sets the number format string of datalabel.
 */
@property(nonatomic) NSString* dataLabelFormat;

@end

