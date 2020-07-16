//
//  DefaultFlexPieDataLabelRenderer.h
//  FlexPie
//
//  Copyright (c) GrapeCity, Inc. All rights reserved.
//
#ifndef FlexPieKit_h
#import "FlexPieDataLabelRenderer.h"
#endif

/**
 * Class DefaultFlexPieDataLabelRenderer.
 */
@interface DefaultFlexPieDataLabelRenderer : FlexPieDataLabelRenderer

/**
 *  Initialize an object for DefaultFlexPieDataLabelRenderer.
 *
 *  @param pie   the pie.
 *  @param label the label.
 *
 *  @return an object for DefaultFlexPieDataLabelRenderer.
 */
-(id)init:(FlexPie*)pie label:(FlexPieDataLabel*)label;
@end
