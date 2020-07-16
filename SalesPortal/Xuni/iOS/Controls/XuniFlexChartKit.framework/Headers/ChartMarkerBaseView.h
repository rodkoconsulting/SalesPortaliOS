//
//  ChartMarkerBaseView.h
//  FlexChart
//
//  Copyright (c) GrapeCity, Inc. All rights reserved.
//

@protocol IXuniChartMarkerRender;
@class XuniChartLineMarker;

/**
 *  Class XuniChartMarkerBaseView.
 */
@interface XuniChartMarkerBaseView : UIView<UIGestureRecognizerDelegate>

/**
 *  Gets or sets the marker render.
 */
@property (nonatomic) NSObject<IXuniChartMarkerRender> *markerRender;

/**
 *  Initialize an instance for XuniChartMarkerBaseView.
 *
 *  @param lineMarker the instance of XuniChartLineMarker.
 *
 *  @return an instance of XuniChartMarkerBaseView.
 */
- (id)initWithLineMarker:(XuniChartLineMarker *)lineMarker;

@end
