//
//  ChartAnnotation.h
//  FlexChart
//
//  Copyright (c) GrapeCity, Inc. All rights reserved.
//

@class FlexChart;
/**
 *  The FlexChart annotation class.
 */
@interface XuniChartAnnotation : NSObject

/**
 *  Gets or sets the attachment of the annotation.
 */
@property (nonatomic) XuniChartAnnotationAttachment attachment;

/**
 *  Gets or sets the width of the annotation.
 */
@property (nonatomic) double width;

/**
 *  Gets or sets the height of the annotation.
 */
@property (nonatomic) double height;

/**
 *  Gets or sets whether annotation is visible.
 */
@property (nonatomic) BOOL isVisible;

/**
 *  Gets or sets the offset of the annotation from the point.
 */
@property (nonatomic) XuniPoint *offset;

/**
 *  Gets or sets the position of the annotation relative to the point.
 */
@property (nonatomic) XuniChartAnnotationPosition position;

/**
 *  Gets or sets the point of the annotation.
 *  The point coordinates depend on the Attachment property.
 */
@property (nonatomic) XuniPoint *point;

/**
 *  Gets or sets the point index of the annotation.
 *  Applies only when the Attachment property is PointIndex.
 */
@property (nonatomic) int pointIndex;

/**
 *  Gets or sets the series index of the annotation.
 *  Applies only when the Attachment property is DataIndex.
 */
@property (nonatomic) int seriesIndex;

/**
 *  Gets or sets the tooltip tex of the annotation.
 */
@property (nonatomic) NSString *tooltipText;

/**
 *  Initialize an instance of class XuniChartAnnotation.
 *
 *  @param chart the FlexChart to init with.
 *
 *  @return an instance of class XuniChartAnnotation.
 */
- (instancetype)initWithChart:(FlexChart *)chart;

@end
