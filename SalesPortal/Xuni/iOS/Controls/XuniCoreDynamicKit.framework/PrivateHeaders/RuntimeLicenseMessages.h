//
//  RuntimeLicenseMessages.h
//  XuniCore
//
//  Copyright (c) GrapeCity, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/**
 *  Class RuntimeLicenseMessages.
 */
@interface RuntimeLicenseMessages : NSObject

/**
 *  Get an array of license messages.
 *
 *  @return an array of license messages.
 */
+ (NSArray *)getMessages;
@end