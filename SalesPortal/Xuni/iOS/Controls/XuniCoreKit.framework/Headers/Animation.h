//
//  Animation.h
//  XuniCore
//
//  Copyright (c) GrapeCity, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Easing.h"

/**
 *  XuniAnimation.
 */
@interface XuniAnimation : NSObject

/**
 *  Gets or sets the length of entire animation.
 */
@property (nonatomic) double duration;

/**
 *  Gets or sets the delay before the animation starts.
 */
@property (nonatomic) double startDelay;

/**
 *  Gets or sets the easing function to use for animations.
 */
@property (nonatomic) id<IXuniEaseAction> easing;

/**
 *  Initialize an object for XuniAnimation.
 *
 *  @return return an object of XuniAnimation.
 */
- (id)init;

/**
 *  Initialize an object for XuniAnimation.
 *
 *  @return return an object of XuniAnimation.
 */
+ (id)none;

/**
 *  Judge whether the animation is valid.
 *
 *  @return return a boolean value.
 */
- (BOOL)isValid;

@end
