//
//  Util.h
//  XuniCore
//
//  Copyright (c) GrapeCity, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 *  XuniDataType.
 */
typedef NS_ENUM (NSInteger, XuniDataType){
    /**
     *  XuniDataTypeNull.
     */
    XuniDataTypeNull,
    /**
     *  XuniDataTypeObject.
     */
    XuniDataTypeObject,
    /**
     *  XuniDataTypeString.
     */
    XuniDataTypeString,
    /**
     *  XuniDataTypeNumber.
     */
    XuniDataTypeNumber,
    /**
     *  XuniDataTypeBoolean.
     */
    XuniDataTypeBoolean,
    /**
     *  XuniDataTypeDate.
     */
    XuniDataTypeDate,
    /**
     *  XuniDataTypeArray.
     */
    XuniDataTypeArray
};

/**
 *  Protocol IXuniQueryInterface.
 */
@protocol IXuniQueryInterface

/**
 *  Implements interface.
 *
 *  @param interfaceName the interface name string.
 *
 *  @return a boolean value.
 */
- (BOOL)implementsInterface:(NSString *)interfaceName;
@end

/**
 *  Class XuniPropertyInfo.
 */
@interface XuniPropertyInfo : NSObject
/**
 *  @exclude
 */
@property (nonatomic) bool isReadOnly;
/**
 *  @exclude
 */
@property (nonatomic) NSString *name;
/**
 *  @exclude
 */
@property (nonatomic) XuniDataType dataType;

/**
 *  Initialize an object for XuniPropertyInfo.
 *
 *  @param name the specified name.
 *
 *  @return an object for XuniPropertyInfo.
 */
- (id)initWithName:(NSString *)name;

/**
 *  Initialize an object for XuniPropertyInfo.
 *
 *  @param name     the specified name.
 *  @param dataType the specified dataType.
 *
 *  @return an object for XuniPropertyInfo.
 */
- (id)initWithName:(NSString *)name dataType:(XuniDataType)dataType;

/**
 *  Initialize an object for XuniPropertyInfo.
 *
 *  @param name     the specified name.
 *  @param dataType the specified dataType.
 *  @param readOnly true if the property is read only.
 *
 *  @return an object for XuniPropertyInfo.
 */
- (id)initWithName:(NSString *)name dataType:(XuniDataType)dataType andReadOnly:(bool)readOnly;

/**
 *  Parse attributes from the string.
 *
 *  @param attr the string to parse.
 *
 */
- (void)parseAttributes:(NSString *)attr;
@end

/**
 *  Class XuniReflector.
 */
@interface XuniReflector : NSObject

/**
 *  Get value with key.
 *
 *  @param object the specified object.
 *  @param name   the specified key name.
 *
 *  @return an object.
 */
+ (NSObject *)getValue:(NSObject *)object forKey:(NSString *)name;

/**
 *  Get data type.
 *
 *  @param object the specified object.
 *
 *  @return data type.
 */
+ (XuniDataType)getDataType:(NSObject *)object;

/**
 *  Get properties.
 *
 *  @param object  the specified object.
 *
 *  @return an array of properties.
 */
+ (NSArray *)getProperties:(NSObject *)object;

/**
 *  Get property.
 *
 *  @param object  the specified object.
 *  @param name    the specified key name.
 *
 *  @return a XuniPropertyInfo object.
 */
+ (XuniPropertyInfo *)getProperty:(NSObject *)object name:(NSString *)name;

/**
 *  Format value.
 *
 *  @param value the specified value.
 *
 *  @return a format value string.
 */
+ (NSString *)formatValue:(NSObject *)value;

/**
 *  Shallow copy.
 *
 *  @param target   the destination object.
 *  @param value    the source object.
 */
+ (void)shallowCopyTo:(NSObject *)target from:(NSObject *)value;
@end

/**
 *  Class XuniBinding.
 */
@interface XuniBinding : NSObject

/**
 *  Gets or sets the path.
 */
@property (nonatomic) NSString *path;

/**
 *  Initialize an object for XuniBinding.
 *
 *  @param path the path.
 *
 *  @return an object of XuniBinding.
 */
- (id)initWithString:(NSString *)path;

/**
 *  Get data type for target.
 *
 *  @param target the target.
 *
 *  @return return the data type.
 */
- (XuniDataType)getDataTypeForTarget:(NSObject *)target;

/**
 *  Get value for target.
 *
 *  @param target the target.
 *
 *  @return return the target.
 */
- (NSObject *)getValueForTarget:(NSObject *)target;

/**
 *  Set value for the target.
 *
 *  @param value  the value.
 *  @param target the target value.
 */
- (void)setValue:(NSObject *)value forTarget:(NSObject *)target;
@end

/**
 *  Protocol IXamarinXuniObject.
 */
@protocol IXamarinXuniObject <NSObject>

/**
 *  Get property names.
 *
 *  @return an array of property names.
 */
- (NSArray *)getPropertyNames;


/**
 *  Get property value.
 *
 *  @param name   the specified property name.
 *
 *  @return an object.
 */
- (NSObject *)getPropertyValue:(NSString *)name;

/**
 *  Set property value.
 *
 *  @param name   the specified property name.
 *  @param value  the new value for the property.
 */
- (void)setPropertyValue:(NSString *)name to:(NSObject *)value;


@optional

/**
 *  Get property descriptors.
 *
 *  @return an array of property descriptors.
 */
- (NSArray *)getPropertyDescriptors;


@end
