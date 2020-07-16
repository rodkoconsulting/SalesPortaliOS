//
//  FlexPie.h
//  FlexPie
//
//  Copyright (c) GrapeCity, Inc. All rights reserved.
//

#ifndef FlexPieKit_h
#import "PieDataLabel.h"
#endif 

#ifndef XUNI_INTERNAL_DYNAMIC_BUILD

#ifndef XuniChartCoreKit_h
#import "XuniChartCore/FlexChartBase.h"
#import "XuniChartCore/ChartLoadAnimation.h"
#import "XuniChartCore/ChartTooltip.h"
#import <CoreText/CoreText.h>
#endif

#else
#import "XuniChartCoreDynamicKit/XuniChartCoreDynamicKit.h"
#endif

@class XuniChartLoadAnimation;
@class XuniAnimation;
@class FlexPieDataLabel;
@class FlexPieDataLabelRenderer;
@class XuniPieHitTestInfo;
@protocol IXuniValueFormatter;



extern NSInteger const DEFAULT_SELECTED_BORDER_WIDTH;

/**
 *  The FlexPie control provides pie and doughnut charts with selectable slices.
 */
IB_DESIGNABLE
@interface FlexPie : FlexChartBase<UIGestureRecognizerDelegate>

/**
 *  Gets or sets the dataLabel renderer.
 */
@property (nonatomic) FlexPieDataLabelRenderer *dataLabelRenderer;

/**
 *   Gets or sets the dataLabel.
 */
@property (nonatomic) FlexPieDataLabel *dataLabel;


/**
 *  Gets or sets the name of the property that contains the name of the data item.
 */
@property (nonatomic) IBInspectable NSString *bindingName;

/**
 *  Gets or sets the starting angle for the pie slices, in degrees.
 *  Angles are measured clockwise, starting at the 9 o'clock position.
 */
@property (nonatomic) IBInspectable double startAngle;

/**
 *   Gets or sets the offset of the slices from the pie center.
 *   The offset is measured as a fraction of the pie radius.
 */
@property (nonatomic) IBInspectable double offset;

/**
 *  Gets or sets the size of the pie's inner radius.
 */
@property (nonatomic) IBInspectable double innerRadius;

/**
 *  Gets or sets whether angles are reversed (counter-clockwise).
 */
@property (nonatomic) IBInspectable BOOL reversed;

/**
 *  Gets or sets the position of the selected slice.
 */
@property (nonatomic) XuniPosition selectedItemPosition;

/**
 *  Gets or sets the offset of the selected slice from the pie center.
 */
@property (nonatomic) IBInspectable double selectedItemOffset;

/**
 *  Gets or sets the index of the selected slice.
 */
@property (nonatomic) IBInspectable NSInteger selectedIndex;

/**
 *  Gets or sets the offset angle of the selected slice.
 */
@property (nonatomic) double angle;

/**
 *  Gets or sets the offset rotation angle of the selected slice.
 */
@property (nonatomic) double rotationAngle;

/**
 *  Gets or sets the selectedIndex with code.
 */
@property (nonatomic) BOOL setWithCode;

/**
 *  Gets or sets a value indicating whether to use animation when items are selected.
 */
@property (nonatomic) IBInspectable BOOL isAnimated;

/**
 *   Gets or sets a value indicating whether to use updateanimation when items are updated.
 */
@property (nonatomic) IBInspectable BOOL isUpdateAnimated;

/**
 *   Gets or sets the load animation of pie.
 */
@property (nonatomic) XuniChartLoadAnimation *loadAnimation;

/**
 *  Gets or sets the update animation of pie.
 */
@property (nonatomic) XuniAnimation *updateAnimation;

/**
 *  Gets or sets the animation when selected an item of pie.
 */
@property (nonatomic) XuniAnimation *selectAnimation;

/**
 *  Gets or sets the values of pie segment.
 */
@property (readonly) NSArray<NSNumber*> *values;

/**
 *  Gets or sets the labels of legend.
 */
@property (readonly) NSArray<NSString*> *labels;

/**
 *  Gets or sets the border width of slice.
 */
@property (nonatomic) IBInspectable double sliceBorderWidth;


/**
 *  Gets or sets the value formatter.
 */
@property (nonatomic) NSObject<IXuniValueFormatter> *valueFormatter;

/**
 *  Gets or sets the whether is Xamarin's data label.
 */
@property (nonatomic) BOOL isXamarinLabel;

/**
*  Internal variable used to calculate the current rotation.
*/
-(double) rotation;

/**
 *  Gets a HitTestInfo object with information about a given point.
 *
 *  @param point Point to investigate, in screen coordinates.
 *
 *  @return HitTestInfo object with information about the point.
 */
- (XuniPieHitTestInfo*)hitTest:(XuniPoint*)point;

/**
 *  Gets a size of the legend item.
 *
 *  @param engine the render engine.
 *  @param name   the item name.
 *
 *  @return XuniSize object about the legend item.
 */
- (XuniSize *)measureLegendItem:(XuniRenderEngine *)engine name:(NSString *)name;

/**
 *  Draw the legend item.
 *
 *  @param engine the render engine.
 *  @param rect   the rectangle of the legend item.
 *  @param i      the index of the legend item.
 *  @param name   the name of the legend item.
 */
- (void)drawLegendItem:(XuniRenderEngine *)engine rect:(XuniRect *)rect i:(NSInteger)i name:(NSString *)name;

/**
 *  Clamp the angle when the angle is above 360.
 *
 *  @param angle the angle.
 *
 *  @return return a clamped angle.
 */
+ (double)clampAngle:(double)angle;

/**
 *  Get a descriptor.
 *
 *  @param attributes the attributes.
 *
 *  @return a descriptor.
 */
- (UIFontDescriptor*)getDescriptor:(NSMutableDictionary*)attributes;

/**
 *  Set selected dataPoint and selection changed.
 */
- (void)setSelectedDataPointAndSelectionChanged;

/**
 *  Prepare for select animation.
 */
-(void)prepareForSelectAnimation:(double)targetAngle;

/**
 *  Set tootip point.
 */
-(void)setTootipPoint;

@end
