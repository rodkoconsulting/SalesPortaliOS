//
//  PieHitTestInfoPrivate.h
//  FlexPie
//
//  Copyright (c) GrapeCity, Inc. All rights reserved.
//

#ifndef FlexPie_PieHitTestInfoPrivate_h
#define FlexPie_PieHitTestInfoPrivate_h

@interface XuniPieHitTestInfo ()

/**
 *  Gets or sets the pie object the hit test occured inside.
 */
@property FlexPie *pie;

/**
 *  Gets or sets the DataPoint of the XuniChartHitTestInfo.
 */
@property XuniPieDataPoint *dataPoint;

/**
 *  Gets or sets the chart element type selected.
 */
@property XuniChartElement chartElement;

@end

#endif
