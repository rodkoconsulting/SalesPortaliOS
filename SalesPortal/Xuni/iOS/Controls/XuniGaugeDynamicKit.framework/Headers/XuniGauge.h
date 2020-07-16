//
//  XuniGauge.h
//  FlexGauge
//
//  Copyright (c) GrapeCity, Inc. All rights reserved.
//

//#define Animation XuniGaugeAnimation
#import <CoreText/CoreText.h>

#import "FlexGaugeEnums.h"

#ifndef XUNI_INTERNAL_DYNAMIC_BUILD

#ifndef XuniCoreKit_h
#import "XuniCore/CollectionView.h"
#import "XuniCore/Easing.h"
#import "XuniCore/XuniView.h"
#endif

#else
#import "XuniCoreDynamicKit/XuniCoreDynamicKit.h"
#endif

@class XuniObservableArray;
@class XuniGaugeRange;
@class XuniRenderEngine;
@class XuniAnimation;
@class XuniRect;
@protocol IXuniValueFormatter;

@class XuniGauge;

/**
 *  protocol XuniGaugeDelegate.
 */
@protocol XuniGaugeDelegate <XuniViewDelegate>
@optional

/**
 *  Do something when value changed.
 *
 *  @param sender the gauge sender object
 *  @param value the value.
 */
- (void)valueChanged:(XuniGauge*)sender value:(double)value;

@end

@class XuniPointEventArgs;

/**
 *  Base class for the Gauge controls.
 */
@interface XuniGauge : XuniView<UIGestureRecognizerDelegate>

/**
 *  Occurs when gauge tapped
 */
@property XuniEvent<XuniPointEventArgs*> *gaugeTapped;

/**
 *  Creates event args and calls onChartRendering.
 *
 *  @param point the tapped point.
 */
- (void) raiseGaugeTapped: (XuniPoint*) point;

/**
 *  Occurs before gauge rendering
 */
@property XuniEvent<XuniEventArgs*> *gaugeRendering;


/**
 *  Creates event args and calls gaugeRendering.
 */
- (void) raiseGaugeRendering;

/**
 *  Occurs when gauge rendered
 */
@property XuniEvent<XuniEventArgs*> *gaugeRendered;

/**
 *  Creates event args and calls gaugeRendered.
 */
- (void) raiseGaugeRendered;

/**
 *  Occurs when gauge value changed
 */
@property XuniEvent<XuniEventArgs*> *gaugeValueChanged;

/**
 *  Creates event args and calls gaugeValueChanged.
 */
- (void) raiseGaugeValueChanged;



/**
 *  Gets or sets the delegate for handling notifications.
 */
@property (nonatomic, weak) id<XuniGaugeDelegate> delegate;

/**
 *  Gets or sets the color of the face.
 */
@property (nonatomic) IBInspectable UIColor *faceColor;

/**
 *  Gets or sets the border color of the face.
 */
@property (nonatomic) IBInspectable UIColor *faceBorderColor;

/**
 *  Gets or sets the border width of the face.
 */
@property (nonatomic) IBInspectable double faceBorderWidth;

/**
 *  Gets or sets the border dashes of the face.
 */
@property (nonatomic) NSArray<NSNumber*>* faceBorderDashes;

/**
 *  Gets or sets the color of the pointer.
 */
@property (nonatomic) IBInspectable UIColor *pointerColor;

/**
 *  Gets or sets the opacity of the max label.
 */
@property (nonatomic) IBInspectable double maxOpacity;

/**
 *  Gets or sets the font size of the max label.
 */
@property (nonatomic) IBInspectable double maxFontSize;

/**
 *  Gets or sets the font color of the max label.
 */
@property (nonatomic) IBInspectable UIColor *maxFontColor;

/**
 *  Gets or sets the font name of the max label.
 */
@property (nonatomic) IBInspectable NSString* maxFontName;

/**
 *  Gets or sets the font of the max label.
 */
@property (nonatomic) UIFont *maxFont;

/**
 *  Gets or sets the opacity of the min label.
 */
@property (nonatomic) IBInspectable double minOpacity;

/**
 *  Gets or sets the font size of the min label.
 */
@property (nonatomic) IBInspectable double minFontSize;

/**
 *  Gets or sets the font color of the min label.
 */
@property (nonatomic) IBInspectable UIColor *minFontColor;

/**
 *  Gets or sets the font name of the min label.
 */
@property (nonatomic) IBInspectable NSString* minFontName;

/**
 *  Gets or sets the font of the min label.
 */
@property (nonatomic) UIFont *minFont;

/**
 *  Gets or sets the value displayed on the gauge.
 */
@property (nonatomic) IBInspectable double value;

/**
 *  Gets or sets the font size of the value.
 */
@property (nonatomic) IBInspectable double valueFontSize;

/**
 *  Gets or sets the font color of the value.
 */
@property (nonatomic) IBInspectable UIColor *valueFontColor;

/**
 *  Gets or sets the font name of the value.
 */
@property (nonatomic) IBInspectable NSString* valueFontName;

/**
 *  Gets or sets the font of the value label.
 */
@property (nonatomic) UIFont *valueFont;

/**
 *  Gets or sets whether the value can change.
 */
@property (nonatomic) IBInspectable BOOL isReadOnly;

/**
 *  Gets or sets whether animation is enabled on the control.
 */
@property (nonatomic) IBInspectable BOOL isEnabled;

/**
 *  Gets or sets whether animation is enabled on the control.
 */
@property (nonatomic) IBInspectable BOOL isAnimated;

/**
 *  Gets or sets the loading animation that occurs when the control first display.
 */
@property (nonatomic) XuniAnimation *loadAnimation;

/**
 *  Gets or sets the updating animation that occurs when the control's value is updated.
 */
@property (nonatomic) XuniAnimation *updateAnimation;

/**
 *  Gets or sets the minimun value of the gague.
 */
@property (nonatomic) IBInspectable double min;

/**
 *  Gets or sets the maximun value of the gague.
 */
@property (nonatomic) IBInspectable double max;

/**
 *  Gets or sets the origin value of the gague.
 */
@property (nonatomic) IBInspectable double origin;

/**
 *  Gets or sets the step.
 */
@property (nonatomic) IBInspectable double step;

/**
 *  Gets or sets the format string used for displaying the gauge values as text.
 */
@property (nonatomic) IBInspectable NSString* format;

/**
 *  Gets or sets the range used to represent the gauge's overall geometry and appearance.
 */
@property (nonatomic) XuniGaugeRange* face;

/**
 *  Gets or sets the range used to represent the gauge's current value.
 */
@property (nonatomic) XuniGaugeRange* pointer;

/**
 *  Gets or sets whether the gauge should display the ranges contained in the ranges property.
 */
@property (nonatomic) IBInspectable BOOL showRanges;

/**
 *  Gets or sets the gague ranges.
 */
@property (nonatomic) XuniObservableArray<XuniGaugeRange*>* ranges;

/**
 *  Gets or sets which values should be displayed as text in the gauge.
 */
@property (nonatomic) XuniShowText showText;

/**
 *  Gets or sets the old value of the gague.
 */
@property (nonatomic) IBInspectable double oldValue;

/**
 *  Gets or sets the thickness of the gauge, on a scale between zero and one.
 */
@property (nonatomic) IBInspectable double thickness;

/**
 *  Gets or sets the frame of the gauge.
 */
@property (nonatomic) XuniRect* rectGauge;

/**
 *  Gets or sets the render engine of the gague.
 */
@property (readonly) XuniRenderEngine* renderEngine;

/**
 *  Gets or sets the color when is during animation.
 */
@property (nonatomic) UIColor* animColor;

/**
 *  Gets or sets the ease type of the animation.
 */
@property (nonatomic) id<IXuniEaseAction> easingType;

/**
 *  Gets or sets the value formatter.
 */
@property (nonatomic) NSObject<IXuniValueFormatter> *valueFormatter;

/**
 *  @exclude
 */
- (void)initialization;
/**
 *  Refresh gague if needed.
 */
- (void)invalidate;
/**
 *  Internal, draw a rectangle.
 *
 *  @param rect the rectangle to draw.
 */
- (void)drawRect:(CGRect)rect;
/**
 *  Updates the content and position of the text elements.
 */
- (void)updateText;
/**
 *  Updates the range element.
 *
 *  @param rng   the range of the gague.
 *  @param value the value about the range.
 *  @param time  the time.
 */
- (void)updateRangeElement:(XuniGaugeRange*)rng value:(double)value time:(double)time;

/**
 *  Get value from the point.
 *
 *  @param point the point in control coordinates that this HitTestInfo refers to.
 *
 *  @return return a double value of the gague.
 */
- (double)getValueFromPoint:(XuniPoint*)point;

/**
 *  Gets a number that corresponds to the value of the gauge at a given point.
 *
 *  @param point the point in control coordinates that this HitTestInfo refers to.
 *
 *  @return return a number that corresponds to the value of the gauge at a given point.
 */
- (double)hitTest:(XuniPoint*)point;

/**
 *  Gets a number that corresponds to the value of the gauge at a given point.
 *
 *  @param x x value of the point.
 *  @param y y value of the point.
 *
 *  @return a value that corresponds to the value of the gauge at a given point.
 */
- (double)hitTest:(double)x y:(double)y;

/**
 *  Scales a value to a percentage based on the gauge's min and max properties.
 *
 *  @param value the given value.
 *
 *  @return a value to a percentage based on the gauge's min and max properties.
 */
- (double)getPercent:(double)value;

/**
 *  Gets the color for the pointer range based on the gauge ranges.
 *
 *  @param value the given value.
 *
 *  @return the color for the pointer range based on the gauge ranges.
 */
- (UIColor*)getPointerColor:(double)value;

/**
 *  Clamps a value between a minimum and a maximum.
 *
 *  @param value the given value.
 *  @param min   the minimun value.
 *  @param max   the maximun value.
 *
 *  @return a value between a minimum and a maximum.
 */
- (double)clamp:(double)value min:(double)min max:(double)max;


/**
 *  Respond to tap gesture.
 *
 *  @param recognizer tap gesture recognizer.
 */
- (void)respondToTapGesture:(UITapGestureRecognizer*)recognizer;

/**
 *  Get animation easing.
 *
 *  @return an ease type.
 */
- (id<IXuniEaseAction>)getAnimationEasing;

/**
 *  Get animation duration.
 *
 *  @return the duration of the animation.
 */
- (double)getAnimationDuration;

/**
 *  Format string.
 *
 *  @param number the given number.
 *
 *  @return a formatted string.
 */
- (NSString *)formatDecimal:(double)number;

/**
 *  Refreshes the control.
 */
- (void)refresh;

/**
 *  Get a descriptor of font.
 *
 *  @param attributes the font attributes.
 *
 *  @return a descriptor.
 */
- (UIFontDescriptor*)getDescriptor:(NSMutableDictionary*)attributes;

///#### Syntax <candies> for design-time property setting

/**
 *  Gets or sets whether to show Min and Max value.
 */
@property (nonatomic) IBInspectable BOOL showMinMax;

/**
 *  Gets or sets whether to show current gauge value.
 */
@property (nonatomic) IBInspectable BOOL showValue;

/**
 *  Gets or sets pointer thickness.
 */
@property (nonatomic) IBInspectable double pointerThickness;

@end


