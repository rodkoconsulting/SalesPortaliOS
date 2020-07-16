//
//  RuntimeLicenseCodes.h
//  XuniCore
//
//  Copyright (c) GrapeCity, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/**
 *  Class RuntimeLicenseCodes.
 */
@interface RuntimeLicenseCodes : NSObject

/**
 *  Get an string of license codes.
 *
 *  @return an string of license codes.
 */
+ (NSString *)getCodes;

/**
 *  Get an string of license codes.
 *
 *  @param isXamarinLicense is Xamarin license or not.
 *
 *  @return an string of license codes.
 */
+ (NSString *)getCodes:(BOOL)isXamarinLicense;

@end