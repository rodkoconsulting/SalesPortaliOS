
//
//  RuntimeLicenseHandler.h
//  XuniCore
//
//  Copyright (c) GrapeCity, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RuntimeLicenseMessages.h"
#import "RuntimeLicenseCodes.h"

/**
 *  Class LicenseChecker.
 */
@interface LicenseChecker : NSObject

/**
 *  Verify license.
 *
 *  @param LicenseString the specified LicenseString.
 *
 *  @return a verify result.
 */
+ (int)VerifyLicense:(NSString *)LicenseString;

/**
 *  Get days remaining.
 *
 *  @return remaining days.
 */
+ (int)GetDaysRemaining;

/**
 *  Get a boolean value of previousCheck.
 *
 *  @return a boolean value of previousCheck.
 */
+ (Boolean)PreviousLicenseCheck;

/**
 *  Get status message.
 *
 *  @return status message.
 */
+ (NSString *)GetStatusMessage;

/**
 *  Reset something.
 */
+ (void)Reset;

@end

/**
 * Class CertParser.
 */
@interface CertParser : NSObject

/**
 *  Initialize an object of CertParser.
 *
 *  @param certRef the specified certRef.
 *
 *  @return an object of CertParser.
 */
- (id)init:(SecCertificateRef)certRef;

/**
 *  Get a boolean result.
 *
 *  @return a boolean result.
 */
- (Boolean)Evaluate;

/**
 *  Get a number string of serial.
 *
 *  @return a number string of serial.
 */
- (NSString *)SerialNumberString;

/**
 *  Get a issuer name.
 *
 *  @return a issuer name.
 */
- (NSString *)IssuerName;

/**
 *  Get a subject name.
 *
 *  @return a subject name.
 */
- (NSString *)SubjectName;

/**
 *  Get a string of thumbprint.
 *
 *  @return a string of thumbprint.
 */
- (NSString *)Thumbprint;

/**
 *  Get a NSDate value with string notBefore.
 *
 *  @return a NSDate value.
 */
- (NSDate *)NotBefore;

/**
 *   Get a NSDate value with string notAfter.
 *
 *  @return a NSDate value.
 */
- (NSDate *)NotAfter;

@end

/**
 *  Class RuntimeLicenseHandler.
 */
@interface RuntimeLicenseHandler : NSObject

/**
 *  Gets or sets the remaining days.
 */
@property(readonly) int daysRemaining;

/**
 *  Initialize an object for RuntimeLicenseHandler.
 *
 *  @return an object for RuntimeLicenseHandler.
 */
- (id)init;

/**
 *  Verify runtime license.
 *
 *  @param appName       the specified app name.
 *  @param licenseData   the specified license data.
 *  @param validCodes    the specified validCodes.
 *  @param versionString the specified version string.
 *
 *  @return a checking result.
 */
- (int)VerifyRuntimeLicense:(NSString *)appName base64LicenseData:(NSString *)licenseData validCodes:(NSString *)validCodes versionString:(NSString *)versionString;

@end
