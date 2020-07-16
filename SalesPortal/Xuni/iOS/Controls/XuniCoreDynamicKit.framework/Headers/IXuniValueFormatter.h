//
//  IXuniValueFormatter.h
//  XuniCore
//
//  Copyright (c) GrapeCity, Inc. All rights reserved.
//

#import "Util.h"

/**
 *  Formatter protocol.
 */
@protocol IXuniValueFormatter

/**
 *  Format the value using the format string.
 *
 *  @param value the value to format.
 *  @param format the format string.
 *
 *  @return the formatted string.
 */
- (NSString *)format:(NSObject *)value format:(NSString *)format;


/**
 *  Format the value using the format string.
 *
 *  @param value the value to format.
 *  @param format the format string.
 *  @param dataType the dataType of value.
 *
 *  @return the formatted string.
 */
- (NSString *)format:(NSObject *)value format:(NSString *)format dataType:(XuniDataType)dataType;

@end
