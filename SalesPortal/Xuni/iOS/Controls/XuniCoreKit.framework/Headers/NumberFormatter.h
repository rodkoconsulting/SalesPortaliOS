//
//  NumberFormatter.h
//  XuniCore
//
//  Copyright (c) GrapeCity, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  XuniNumberFormatter.
 */
@interface XuniNumberFormatter : NSObject

/**
 *  Gets formatted number with pattern.
 *
 *  @param number  the number.
 *  @param pattern the pattern.
 *
 *  @return return a string of formatted number.
 */
+ (NSString *)numberToStringWithParameters:(NSNumber *)number andPattern:(NSString *)pattern;

/**
 *  Gets formatted number with pattern and language locale.
 *
 *  @param number  the number.
 *  @param pattern the pattern.
 *  @param locale  the language locale.
 *
 *  @return return a string of formatted number.
 */
+ (NSString *)numberToStringWithParameters:(NSNumber *)number andPattern:(NSString *)pattern andLanguageLocale:(NSString *)locale;

@end
