//
//  FlexPieDataLabelRenderer.h
//  FlexPie
//
//  Copyright (c) GrapeCity, Inc. All rights reserved.

//

#import <Foundation/Foundation.h>

#ifndef FlexPieKit_h
#import "FlexPie.h"
#import "PieDataLabel.h"
#endif

/**
 *  Class FlexPieDataLabelRenderer.
 */
@interface FlexPieDataLabelRenderer : NSObject
{
    FlexPie* _pie;
    FlexPieDataLabel* _label;
}

/**
 *  Initialize an object for DefaultFlexPieDataLabelRenderer.
 *
 *  @param pie   the pie.
 *  @param label the label.
 *
 *  @return an object for DefaultFlexPieDataLabelRenderer.
 */
-(id)init:(FlexPie*)pie label:(FlexPieDataLabel*)label;

/**
 *  Render datalabel.
 *
 *  @param seriesName the series name.
 *  @param rect       the rect.
 *  @param index      the index.
 *  @param value      the value.
 *  @param values     the values.
 */
-(void) render:(NSString*)seriesName rect:(XuniRect*)rect index:(NSInteger)index value:(double)value values:(NSArray *)values;

/**
 *  Get xamarin's data label's Size.
 *
 *  @param seriesName the series name.
 *  @param index      the index.
 *  @param value      the value.
 *  @param values     the values.
 *
 *  @return the size.
 */
-(XuniSize*) getLabelSize:(NSString*)seriesName index:(NSInteger)index value:(double)value values:(NSArray *)values;

/**
 *  Clear xamarin's data labels if itemsource is updated.
 */
-(void)clearXamarinDataLabelIfUpdated;

/**
*  Calculate the data label width.
*
*  @param seriesName the series name.
*  @param index      the index.
*  @param value      the value.
*
*  @return the width.
*/
-(double) dataLabelDimension:(NSString*)seriesName index:(NSInteger)index value:(double)value;
@end
