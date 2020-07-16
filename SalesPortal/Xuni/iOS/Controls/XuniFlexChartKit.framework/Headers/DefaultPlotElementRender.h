//
//  DefaultPlotElementRender.h
//  FlexChart
//
//  Copyright (c) GrapeCity, Inc. All rights reserved.
//

#ifndef XuniCoreKit_h
#import "XuniCore/Event.h"
#endif

/**
 *  Class BasePlotElementRender.
 */
@interface BasePlotElementRender : NSObject

/**
 *  Execute the function.
 *
 *  @return generic object.
 */
- (NSObject *)execute;

/**
 *  Execute the function.
 *
 *  @param args array of parameters.
 *
 *  @return generic object.
 */
- (NSObject *)execute:(NSArray *)args;

@end

/**
 *  Class DefaultPlotElementRender.
 */
@interface DefaultPlotElementRender : BasePlotElementRender

/**
 *  Initialize an object for DefaultPlotElementRender.
 *
 *  @param renderEngine the renderEngine.
 *  @param x            the x value.
 *  @param y            the y value.
 *  @param borderWidth  the borderWidth.
 *  @param symbolSize   the symbolSize.
 *  @param borderColor  the borderColor.
 *  @param symbolMarker the symbolMarker.
 *
 *  @return an object for DefaultPlotElementRender.
 */
- (id)init:(NSObject<IXuniRenderEngine>*)renderEngine x:(double)x y:(double)y borderWidth:(double)borderWidth symbolSize:(double)symbolSize borderColor:(UIColor*)borderColor symbolMarker:(XuniMarkerType)symbolMarker;

/**
 *  Get the symbol rectangle.
 *
 *  @return an object for CGRect.
 */
- (CGRect)getSymbolRect;

@end

/**
 *  Class DefaultBarElementRender.
 */
@interface DefaultBarElementRender : BasePlotElementRender

/**
 *  Initialize an object for DefaultBarElementRender.
 *
 *  @param renderEngine the renderEngine.
 *  @param x            the X value.
 *  @param y            the Y value.
 *  @param width        the width.
 *  @param height       the height.
 *
 *  @return an object for DefaultBarElementRender.
 */
- (id)init:(NSObject<IXuniRenderEngine>*)renderEngine x:(double)x y:(double)y width:(double)width height:(double)height;

/**
 *  Get the Bar rectangle.
 *
 *  @return an object for CGRect.
 */
- (CGRect)getBarRect;

@end

/**
 *  Class DefaultFinanceElementRender.
 */
@interface DefaultFinanceElementRender : BasePlotElementRender

/**
 *  Initialize an object for DefaultFinanceElementRender.
 *
 *  @param renderEngine   the renderEngine.
 *  @param x              the x value.
 *  @param y              the y value.
 *  @param w              the w value.
 *  @param hi             the high value.
 *  @param lo             the low value.
 *  @param open           the open value.
 *  @param close          the close value.
 *  @param isCandle       whether is candle.
 *  @param rotated        whether the chart is rotated.
 *  @param isAxisReversed whether the axis is reversed.
 *
 *  @return an object for DefaultFinanceElementRender.
 */
- (id)init:(NSObject<IXuniRenderEngine>*)renderEngine x:(double)x y:(double)y w:(double)w hi:(double)hi lo:(double)lo open:(double)open close:(double)close isCandle:(BOOL)isCandle isRotated:(BOOL)rotated reversed:(BOOL)isAxisReversed;

@end
