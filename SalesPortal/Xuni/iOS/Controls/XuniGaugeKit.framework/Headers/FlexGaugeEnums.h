//
//  FlexGaugeEnums.h
//  FlexGauge
//
//  Copyright (c) GrapeCity, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifndef FlexGauge_FlexGaugeEnums_h
#define FlexGauge_FlexGaugeEnums_h


/**
 *  Specifies which values should be displayed as text.
 */
typedef NS_ENUM(NSInteger, XuniShowText){
    /**
     *  XuniShowTextNone.
     */
    XuniShowTextNone,
    /**
     *  XuniShowTextValue.
     */
    XuniShowTextValue = 1,
    /**
     *  XuniShowTextMinMax.
     */
    XuniShowTextMinMax = 1 << 1,
    /**
     *  XuniShowTextAll.
     */
    XuniShowTextAll = XuniShowTextValue | XuniShowTextMinMax
};

/**
 *  Represents the direction in which the pointer of a LinearGauge increases.
 */
typedef NS_ENUM(NSInteger, XuniGaugeDirection){
    /**
     *  XuniGaugeDirectionRight.
     */
    XuniGaugeDirectionRight,
    /**
     *  XuniGaugeDirectionLeft.
     */
    XuniGaugeDirectionLeft,
    /**
     *  XuniGaugeDirectionUp.
     */
    XuniGaugeDirectionUp,
    /**
     *  XuniGaugeDirectionDown.
     */
    XuniGaugeDirectionDown
};

/**
 *  Represents the direction of text.
 */
typedef NS_ENUM(NSInteger, XuniTextDirection){
    /**
     *  XuniTextDirectionRight.
     */
    XuniTextDirectionRight,
    /**
     *  XuniTextDirectionLeft.
     */
    XuniTextDirectionLeft,
    /**
     *  XuniTextDirectionTop.
     */
    XuniTextDirectionTop,
    /**
     *  XuniTextDirectionBottom.
     */
    XuniTextDirectionBottom
};

/**
 *  Represents the type of the label.
 */
typedef NS_ENUM(NSInteger, XuniLabelType){
    /**
     *  XuniLabelTypeMin.
     */
    XuniLabelTypeMin,
    /**
     *  XuniLabelTypeMax.
     */
    XuniLabelTypeMax
};

/**
*  Represents the type of an object.
*/
typedef NS_ENUM(NSInteger, DataType) {
	/**
	*  Null object type.
	*/
    DataTypeNull,
	/**
	*  Generic object type.
	*/
    DataTypeObject,
	/**
	*  String object type.
	*/
    DataTypeString,
	/**
	*  Number object type.
	*/
    DataTypeNumber,
	/**
	*  Boolean object type.
	*/
    DataTypeBoolean,
	/**
	*  Date object type.
	*/
    DataTypeDate,
	/**
	*  Array object type.
	*/
    DataTypeArray
};

#endif