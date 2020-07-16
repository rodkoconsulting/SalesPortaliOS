//
//  IOSXuniValueFormatter.h
//  XuniCore
//
//  Copyright (c) GrapeCity, Inc. All rights reserved.
//

#import "IXuniValueFormatter.h"

/**
 *  iOS native formatter interface.
 */
@interface XuniIOSValueFormatter : NSObject<IXuniValueFormatter>

/**
 *  Initialize an instance for iOS native formatter.
 *
 *  @param locale the locale string.
 *
 *  @return an instance of iOS native formatter.
 */
- (id)initWithLocale:(NSString *)locale;

@end
