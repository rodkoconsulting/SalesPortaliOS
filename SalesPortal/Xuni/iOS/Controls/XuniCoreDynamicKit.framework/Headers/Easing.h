//
//  Easing.h
//  XuniCore
//
//  Copyright (c) GrapeCity, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIView.h>

/**
 *  XuniDirection
 */
typedef NS_ENUM (NSInteger, XuniDirection){
    /**
     *  XuniDirectionHorizontal
     */
    XuniDirectionHorizontal,
    /**
     *  XuniDirectionVertical
     */
    XuniDirectionVertical
};


/**
 *  Generic action protocol.
 */
@protocol IXuniEaseAction <NSObject>

/**
 *  Get a value for ease animation with parameters.
 *
 *  @param t the time.
 *  @param b the specified beginning value.
 *  @param c the specified change value.
 *  @param d the duration.
 *
 *  @return a value for ease animation.
 */
- (double)ease:(double)t beginning:(double)b change:(double)c duration:(double)d;

/**
 *  Get a view animation curve.
 *
 *  @return a view animation curve.
 */
- (UIViewAnimationCurve)viewAnimationCurve;
@end

/**
 *  Generic action class.
 */
@interface XuniEaseAction : NSObject<IXuniEaseAction>

/**
 *  Get a value for ease animation with parameters.
 *
 *  @param t the time.
 *  @param b the specified beginning value.
 *  @param c the specified change value.
 *  @param d the duration.
 *
 *  @return a value for ease animation.
 */
- (double)ease:(double)t beginning:(double)b change:(double)c duration:(double)d;

/**
 *  Get a view animation curve.
 *
 *  @return a view animation curve.
 */
- (UIViewAnimationCurve)viewAnimationCurve;
@end

/**
 *  Linear easing.
 */
@interface XuniEaseLinearAction : XuniEaseAction

@end

/**
 *  Class XuniEaseInAction.
 */
@interface XuniEaseInAction : XuniEaseAction

@end

/**
 *  Class XuniEaseOutAction.
 */
@interface XuniEaseOutAction : XuniEaseAction

@end

/**
 *  Class XuniEaseInOutAction.
 */
@interface XuniEaseInOutAction : XuniEaseAction

@end

/**
 *  BackIn easing.
 */
@interface XuniBackIn : XuniEaseInAction
@end

/**
 *  BackOut easing.
 */
@interface XuniBackOut : XuniEaseOutAction
@end

/**
 *  BackInOut easing.
 */
@interface XuniBackInOut : XuniEaseInOutAction
@end

/**
 *  BounceIn easing.
 */
@interface XuniBounceIn : XuniEaseInAction
@end

/**
 *  BounceOut easing.
 */
@interface XuniBounceOut : XuniEaseOutAction
@end

/**
 *  BounceInOut easing.
 */
@interface XuniBounceInOut : XuniEaseInOutAction
@end

/**
 *  CircIn easing.
 */
@interface XuniCircIn : XuniEaseInAction
@end

/**
 *  CircOut easing.
 */
@interface XuniCircOut : XuniEaseOutAction
@end

/**
 *  CircInOut easing.
 */
@interface XuniCircInOut : XuniEaseInOutAction
@end

/**
 *  CubicIn easing.
 */
@interface XuniCubicIn : XuniEaseInAction
@end

/**
 *  Cubicout easing.
 */
@interface XuniCubicOut : XuniEaseOutAction
@end

/**
 *  CubicInOut  easing.
 */
@interface XuniCubicInOut : XuniEaseInOutAction
@end

/**
 *  ElasticIn  easing.
 */
@interface XuniElasticIn : XuniEaseInAction
@end

/**
 *  ElasticOut  easing.
 */
@interface XuniElasticOut : XuniEaseOutAction
@end

/**
 *  ElasticInOut easing.
 */
@interface XuniElasticInOut : XuniEaseInOutAction
@end

/**
 *  ExpoIn easing.
 */
@interface XuniExpoIn : XuniEaseInAction
@end

/**
 *  ExpoOut easing.
 */
@interface XuniExpoOut : XuniEaseOutAction
@end

/**
 *  ExpoInOut  easing.
 */
@interface XuniExpoInOut : XuniEaseInOutAction
@end

/**
 *  LinearIn  easing.
 */
@interface XuniLinearIn : XuniEaseLinearAction
@end

/**
 *  LinearOut  easing.
 */
@interface XuniLinearOut : XuniEaseLinearAction
@end

/**
 *  LinearInOut  easing.
 */
@interface XuniLinearInOut : XuniEaseLinearAction
@end

/**
 *  QuadIn  easing.
 */
@interface XuniQuadIn : XuniEaseInAction
@end

/**
 *  QuadOut  easing.
 */
@interface XuniQuadOut : XuniEaseOutAction
@end

/**
 *  QuadInOut  easing.
 */
@interface XuniQuadInOut : XuniEaseInOutAction
@end

/**
 *  QuartIn   easing.
 */
@interface XuniQuartIn : XuniEaseInAction
@end

/**
 *  QuartOut  easing.
 */
@interface XuniQuartOut : XuniEaseOutAction
@end

/**
 *  QuartInOut  easing.
 */
@interface XuniQuartInOut : XuniEaseInOutAction
@end

/**
 *  QuintIn  easing.
 */
@interface XuniQuintIn : XuniEaseInAction
@end

/**
 *  QuintOut  easing.
 */
@interface XuniQuintOut : XuniEaseOutAction
@end

/**
 *  QuintInOut  easing.
 */
@interface XuniQuintInOut : XuniEaseInOutAction
@end

/**
 *  SineIn  easing.
 */
@interface XuniSineIn : XuniEaseInAction
@end

/**
 *  SineOut  easing.
 */
@interface XuniSineOut : XuniEaseOutAction
@end

/**
 *  SineInOut  easing.
 */
@interface XuniSineInOut : XuniEaseInOutAction
@end


/**
 *  Easing Util.
 */
@interface XuniEasingUtil : NSObject

/**
 *  Get a value for ease animation with parameters.
 *
 *  @param ease the ease.
 *  @param t    the time.
 *  @param b    the specified beginning value.
 *  @param c    the specified change value.
 *  @param d    the duration.
 *
 *  @return a value for ease animation.
 */
+ (double)ease:(id<IXuniEaseAction>)ease time:(double)t beginning:(double)b change:(double)c duration:(double)d;

/**
 *  Get a NSDictionary with parameters.
 *
 *  @param xs     array contains X values of points.
 *  @param ys     array contains Y values of points.
 *  @param bottom the bottom.
 *  @param t      the time.
 *  @param d      the duration.
 *  @param dir    the direction.
 *  @param ease   the ease.
 *
 *  @return a NSDictionary.
 */
+ (NSDictionary *)easePointsListX:(NSArray *)xs Y:(NSArray *)ys bottom:(double)bottom time:(double)t duration:(double)d direction:(XuniDirection)dir ease:(id<IXuniEaseAction>)ease;
@end

//Presets
/**
 *  XuniEasing
 */
@interface XuniEasing : NSObject

/**
 *  Ease by index.
 *
 *  @param index the specified index.
 *
 *  @return a type of ease animation.
 */
+ (id<IXuniEaseAction>)EaseByIndex:(NSInteger)index;

/**
 *  Get the index from ease type.
 *
 *  @param ease the ease type.
 *
 *  @return the index.
 */
+ (NSInteger)IndexFromEase:(id<IXuniEaseAction>)ease;

/**
 *  Get an object for EaseNone.
 *
 *  @return nil.
 */
+ (id<IXuniEaseAction>)EaseNone;

/**
 *  Get an object for XuniBackIn.
 *
 *  @return an object for XuniBackIn.
 */
+ (id<IXuniEaseAction>)EaseInBack;
/**
 *  Get an object for XuniBackOut.
 *
 *  @return an object for XuniBackOut.
 */
+ (id<IXuniEaseAction>)EaseOutBack;
/**
 *  Get an object for XuniBackInOut.
 *
 *  @return an object for XuniBackInOut.
 */
+ (id<IXuniEaseAction>)EaseInOutBack;

/**
 *  Get an object for XuniBounceIn.
 *
 *  @return an object for XuniBounceIn.
 */
+ (id<IXuniEaseAction>)EaseInBounce;
/**
 *  Get an object for XuniBounceOut.
 *
 *  @return an object for XuniBounceOut.
 */
+ (id<IXuniEaseAction>)EaseOutBounce;
/**
 *  Get an object for XuniBounceInOut.
 *
 *  @return an object for XuniBounceInOut.
 */
+ (id<IXuniEaseAction>)EaseInOutBounce;

/**
 *  Get an object for XuniCircIn.
 *
 *  @return an object for XuniCircIn.
 */
+ (id<IXuniEaseAction>)EaseInCirc;
/**
 *  Get an object for XuniCircOut.
 *
 *  @return an object for XuniCircOut.
 */
+ (id<IXuniEaseAction>)EaseOutCirc;
/**
 *  Get an object for XuniCircInOut.
 *
 *  @return an object for XuniCircInOut.
 */
+ (id<IXuniEaseAction>)EaseInOutCirc;

/**
 *  Get an object for XuniCubicIn.
 *
 *  @return an object for XuniCubicIn.
 */
+ (id<IXuniEaseAction>)EaseInCubic;
/**
 *  Get an object for XuniCubicOut.
 *
 *  @return an object for XuniCubicOut.
 */
+ (id<IXuniEaseAction>)EaseOutCubic;
/**
 *  Get an object for XuniCubicInOut.
 *
 *  @return an object for XuniCubicInOut.
 */
+ (id<IXuniEaseAction>)EaseInOutCubic;

/**
 *  Get an object for XuniElasticIn.
 *
 *  @return an object for XuniElasticIn.
 */
+ (id<IXuniEaseAction>)EaseInElastic;
/**
 *  Get an object for XuniElasticOut.
 *
 *  @return an object for XuniElasticOut.
 */
+ (id<IXuniEaseAction>)EaseOutElastic;
/**
 *  Get an object for XuniElasticInOut.
 *
 *  @return an object for XuniElasticInOut.
 */
+ (id<IXuniEaseAction>)EaseInOutElastic;

/**
 *  Get an object for XuniExpoIn.
 *
 *  @return an object for XuniExpoIn.
 */
+ (id<IXuniEaseAction>)EaseInExpo;
/**
 *  Get an object for XuniExpoOut.
 *
 *  @return an object for XuniExpoOut.
 */
+ (id<IXuniEaseAction>)EaseOutExpo;
/**
 *  Get an object for XuniExpoInOut.
 *
 *  @return an object for XuniExpoInOut.
 */
+ (id<IXuniEaseAction>)EaseInOutExpo;

/**
 *  Get an object for XuniLinearIn.
 *
 *  @return an object for XuniLinearIn.
 */
+ (id<IXuniEaseAction>)EaseInLinear;
/**
 *  Get an object for XuniLinearOut.
 *
 *  @return an object for XuniLinearOut.
 */
+ (id<IXuniEaseAction>)EaseOutLinear;
/**
 *  Get an object for XuniLinearInOut.
 *
 *  @return an object for XuniLinearInOut.
 */
+ (id<IXuniEaseAction>)EaseInOutLinear;

/**
 *  Get an object for XuniQuadIn.
 *
 *  @return an object for XuniQuadIn.
 */
+ (id<IXuniEaseAction>)EaseInQuad;
/**
 *  Get an object for XuniQuadOut.
 *
 *  @return an object for XuniQuadOut.
 */
+ (id<IXuniEaseAction>)EaseOutQuad;
/**
 *  Get an object for XuniQuadInOut.
 *
 *  @return an object for XuniQuadInOut.
 */
+ (id<IXuniEaseAction>)EaseInOutQuad;

/**
 *  Get an object for XuniQuartIn.
 *
 *  @return an object for XuniQuartIn.
 */
+ (id<IXuniEaseAction>)EaseInQuart;
/**
 *  Get an object for XuniQuartOut.
 *
 *  @return an object for XuniQuartOut.
 */
+ (id<IXuniEaseAction>)EaseOutQuart;
/**
 *  Get an object for XuniQuartInOut.
 *
 *  @return an object for XuniQuartInOut.
 */
+ (id<IXuniEaseAction>)EaseInOutQuart;

/**
 *  Get an object for XuniQuintIn.
 *
 *  @return an object for XuniQuintIn.
 */
+ (id<IXuniEaseAction>)EaseInQuint;
/**
 *  Get an object for XuniQuintOut.
 *
 *  @return an object for XuniQuintOut.
 */
+ (id<IXuniEaseAction>)EaseOutQuint;
/**
 *  Get an object for XuniQuintInOut.
 *
 *  @return an object for XuniQuintInOut.
 */
+ (id<IXuniEaseAction>)EaseInOutQuint;

/**
 *  Get an object for XuniSineIn.
 *
 *  @return an object for XuniSineIn.
 */
+ (id<IXuniEaseAction>)EaseInSine;
/**
 *  Get an object for XuniSineOut.
 *
 *  @return an object for XuniSineOut.
 */
+ (id<IXuniEaseAction>)EaseOutSine;
/**
 *  Get an object for XuniSineInOut.
 *
 *  @return an object for XuniSineInOut.
 */
+ (id<IXuniEaseAction>)EaseInOutSine;

@end
