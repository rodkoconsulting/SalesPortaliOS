//
//  LicenseManager.h
//  XuniCore
//
//  Copyright (c) GrapeCity, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/**
 *  Class XuniLicenseManager.
 */
@interface XuniLicenseManager : NSObject

/**
 *  Get a key string.
 *
 *  @return a key string.
 */
+ (NSString *)getKey;

/**
 *  Set the key.
 *
 *  @param key the key.
 */
+ (void)setKey:(NSString *)key;

/**
 *  Check license.
 */
+ (void)checkLicense;

/**
 *  Show dialog when throws exception.
 *
 *  @param withMessage    the message.
 *  @param throwException whether throws exception.
 */
+ (void)showDialog:(NSString *)withMessage throwException:(Boolean)throwException;
@end