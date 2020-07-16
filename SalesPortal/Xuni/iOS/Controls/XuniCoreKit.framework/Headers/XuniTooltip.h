//
//  XuniTooltip.h
//  XuniCore
//
//  Copyright (c) GrapeCity, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  Class XuniBaseTooltipView.
 */
@interface XuniBaseTooltipView : UIView

/**
 *  Gets or sets the the duration before tooltip totally appeared.
 */
@property (nonatomic, assign) double appearDuration;

/**
 *  Gets or sets the the delay before tooltip start appears.
 */
@property (nonatomic, assign) double appearDelay;

/**
 *  Gets or sets the the duration before tooltip totally disappeared.
 */
@property (nonatomic, assign) double disappearDuration;

/**
 *  Gets or sets the the delay before tooltip start disappears.
 */
@property (nonatomic, assign) double disappearDelay;

/**
 *  Gets or sets whether the  tooltip start has shadow.
 */
@property (nonatomic, assign) BOOL hasShadow;

/**
 *  Gets or sets whether the  tooltip should be visible.
 */
@property (nonatomic, assign) BOOL isVisible;

/**
 *  Gets or sets the text on the tooltip.
 */
@property (strong, nonatomic) NSString *text;

/**
 *  Gets or sets the color of the text.
 */
@property (strong, nonatomic) UIColor *textColor;

/**
 *  Gets or sets the font of the text.
 */
@property (strong, nonatomic) UIFont *textFont;

/**
 *  Gets or sets the font size of the text.
 */
@property (nonatomic) double textFontSize;

/**
 *  Gets or sets the corner radius of the tooltip.
 */
@property (nonatomic, assign) int cornerRadius;

/**
 *  Gets or sets the point tooltip appears at.
 */
@property (nonatomic, assign) CGPoint senderPoint;

/**
 *  Gets or sets the backgroundcolor of the tooltip.
 */
@property (nonatomic, strong) UIColor *backColor;

/**
 *  Gets or sets the opacity of the tooltip.
 */
@property (nonatomic) double opacity;

/**
 *  Gets or sets the gap between tooltip and the touch point.
 */
@property (nonatomic) double gap;

/**
 *  Gets or sets the maximum distance from the target element.
 */
@property (nonatomic) double threshold;

/**
 *  Gets or sets whether is customized..
 */
@property (nonatomic) BOOL isCustomized;

/**
 *  Initialize an instance for XuniTooltip.
 *
 *  @return return an instance of XuniTooltip.
 */
- (id)init;

/**
 *  Refresh tooltip if needed.
 */
- (void)invalidate;

/**
 *  Hide the tooltip.
 */
- (void)hide;

/**
 *  Show the tooltip.
 */
- (void)show;

@end
