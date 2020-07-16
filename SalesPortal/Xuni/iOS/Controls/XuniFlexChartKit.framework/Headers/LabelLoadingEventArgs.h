//
//  LabelLoadingEventArgs.h
//  FlexChart
//
//  Copyright (c) GrapeCity, Inc. All rights reserved.
//

#ifndef XuniCoreKit_h
#import "XuniCore/Event.h"
#endif

@protocol IXuniRenderEngine;

/**
 *  Arguments for LabelLoading event.
 */
@interface XuniLabelLoadingEventArgs : XuniEventArgs

/**
 *  Gets or sets the render engine.
 */
@property (nonatomic) NSObject<IXuniRenderEngine> *renderEngine;

/**
 *  Gets or sets the original label value.
 */
@property (nonatomic) double value;

/**
 *  Gets or sets the label string.
 */
@property (nonatomic) NSString *label;

/**
 *  Gets or sets the label region.
 */
@property (nonatomic) XuniRect *region;

/**
 *  Initialize an instance for XuniLabelLoadingEventArgs.
 *
 *  @param renderEngine the render engine.
 *  @param value        the original label value.
 *  @param label        the label string.
 *  @param region       the label region.
 *
 *  @return an instance of XuniLabelLoadingEventArgs.
 */
- (id)initWithEngine:(NSObject<IXuniRenderEngine> *)renderEngine value:(double)value label:(NSString *)label region:(XuniRect *)region;

@end
