//
//  FlexPie.h
//  FlexPie
//
//  Copyright (c) GrapeCity, Inc. All rights reserved.
//

@class XuniAnimation;

/**
 *  Segment of pie.
 */
@interface FlexPieSegment : NSObject<IXuniHitArea>

/**
 *  Gets or sets the tag of pie segment.
 */
@property NSObject *tag;

/**
 *  Gets or sets the startAngle of pie segment.
 */
@property double startAngle;

/**
 *  Gets or sets the sweep of pie segment.
 */
@property double sweep;

/**
 *  Initialize an instance for FlexPieSegment.
 *
 *  @return return an instance of FlexPieSegment.
 */
- (id)init;

/**
 *  Render the segment of pie.
 *
 *  @param engine     the render engine.
 *  @param cx         the x value of the center point of pie.
 *  @param cy         the y value of the center point of pie.
 *  @param radius     the radius of pie.
 *  @param startAngle the start angle of the segment.
 *  @param sweepAngle the sweep angle of the segment.
 *  @param selected   whether is selected.
 */
- (void)render:(XuniRenderEngine*)engine cx:(double)cx cy:(double)cy radius:(double)radius startAngle:(double)startAngle sweepAngle:(double)sweepAngle selected:(BOOL)selected;

@end

/**
 *  Segment of Donut.
 */
@interface FlexDonutSegment : NSObject<IXuniHitArea>

/**
 *  Gets or sets the tag of pie segment.
 */
@property NSObject* tag;

/**
 *  Gets or sets the startAngle of pie segment.
 */
@property double startAngle;

/**
 *  Gets or sets the sweep of pie segment.
 */
@property double sweep;

/**
 *  Initialize an instance for FlexDonutSegment.
 *
 *  @return return an instance of FlexDonutSegment.
 */
- (id)init;

/**
 *  Render the donut segment of pie.
 *
 *  @param engine      the render engine.
 *  @param cx          the x value of the center point of pie.
 *  @param cy          the y value of the center point of pie.
 *  @param radius      the radius of pie.
 *  @param innerRadius the inner radius of pie.
 *  @param startAngle  the start angle of the segment.
 *  @param sweepAngle  the sweep angle of the segment.
 *  @param selected    whether is selected.
 */
- (void)render:(XuniRenderEngine*)engine cx:(double)cx cy:(double)cy radius:(double)radius innerRadius:(double)innerRadius startAngle:(double)startAngle sweepAngle:(double)sweepAngle selected:(BOOL)selected;

@end

/**
 *  PieControl.
 */
@interface FlexPieControl : UIView

/**
*  Internal.
*/
@property dispatch_semaphore_t semaphore;

/**
 *  Gets or sets the rect of pie control.
 */
@property (nonatomic) XuniRect* rectPie;
/**
 *  Gets or sets the render engine of pie.
 */
@property (nonatomic) XuniRenderEngine* engine;
/**
 *  Gets or sets the angles.
 */
@property (nonatomic) NSMutableArray* angles;
/**
 *  Gets or sets the areas of pie control.
 */
@property (nonatomic) NSMutableArray* areas;
/**
 *  Gets or sets the center points of the slices.
 */
@property (nonatomic) NSMutableArray* sliceCenterPoints;
/**
 *  Gets or sets the values of segments of pie.
 */
@property (nonatomic) NSMutableArray* values;
/**
 *  Gets or sets the previous values of segments of pie.
 */
@property (nonatomic) NSMutableArray* preValues;
/**
 *  Gets or sets the total value of segments.
 */
@property (nonatomic) double sum;
/**
 *  Gets or sets the startAngle.
 */
@property (nonatomic) double startAngle;
/**
 *  Gets or sets whether the pie control is reversed.
 */
@property (nonatomic) BOOL reversed;
/**
 *  Gets or sets the inner radius of the pie.
 */
@property (nonatomic) double innerRadius;
/**
 *  Gets or sets the radius of the pie.
 */
@property (nonatomic) double radius;
/**
 *  Gets or sets the real inner radius of the pie.
 */
@property (nonatomic) double innerR;
/**
 *  Gets or sets the offset of each segment of pie.
 */
@property (nonatomic) double offset;
/**
 *  Gets or sets the offset of the selected item.
 */
@property (nonatomic) double selectedItemOffset;
/**
 *  Gets or sets the selected index of the item.
 */
@property (nonatomic) NSInteger selectedIndex;
/**
 *  Gets or sets the slice border width.
 */
@property (nonatomic) double sliceBorderWidth;
/**
 *  Gets or sets the rotation angle of the pie control.
 */
@property (nonatomic) double rotationAngle;
/**
 *  Gets or sets whether the pie control is animated.
 */
@property (nonatomic) BOOL isAnimated;
/**
 *  Gets or sets the load animation of the pie control.
 */
@property (nonatomic) XuniChartLoadAnimation *loadAnimation;
/**
 *  Gets or sets whether the pie is loaded the first time.
 */
@property (nonatomic) BOOL firstLoad;
/**
 *  Gets or sets whether the pie control is update animated.
 */
@property (nonatomic) BOOL isUpdateAnimated;
/**
 *  Gets or sets the update animation of the pie control.
 */
@property (nonatomic) XuniAnimation *updateAnimation;
/**
 *  Gets or sets the value added to the sourceCollection.
 */
@property (nonatomic) NSMutableArray *addedValueArr;
/**
 *  Gets or sets the value removed from the sourceCollection.
 */
@property (nonatomic) NSMutableArray *removedValueArr;
/**
 *  Gets or sets the value changed in the sourceCollection.
 */
@property (nonatomic) NSMutableArray *changedValueArr;
/**
 *  Gets or sets the value added to the sourceCollection.
 */
@property (nonatomic) NSMutableArray *addedValueInd;
/**
 *  Gets or sets the value removed from the sourceCollection.
 */
@property (nonatomic) NSMutableArray *removedValueInd;
/**
 *  Gets or sets the value changed in the sourceCollection.
 */
@property (nonatomic) NSMutableArray *changedValueInd;
/**
 *  Gets or sets the arguments when the collectionView is changed.
 */
@property (nonatomic) XuniNotifyCollectionChangedEventArgs* args;

/**
 *  Get a pie control instance.
 *
 *  @param pie   the pie about the control.
 *  @param frame the frame about the control.
 *
 *  @return a pie control instance.
 */
- (id)initWithPie:(FlexPie*)pie frame:(CGRect)frame;
/**
 *  Init internal arguments.
 */
- (void)initInternals;
/**
 *  Render slice with parameters.
 *
 *  @param engine         the render engine.
 *  @param startAngle     the start angle.
 *  @param i              the index of the slice.
 *  @param reversed       whether is reversed.
 *  @param innerRadius    the inner radius of the pie control.
 *  @param offset         the offset of the slice.
 *  @param offsets        the offsets of the slices.
 *  @param angle          the angle of slice after sweeped.
 *  @param cx0            the x value of the center point of the pie control.
 *  @param cy0            the y value of the center point of the pie control.
 *  @param r              the radius of the pie control.
 *  @param maxoff         the max offset value.
 *  @param irad           the inner radius of the pie control.
 *  @param sum            the total value of the pie control.
 *  @param renderSelected whether the border of the selected slice is rendered.
 */
- (void)renderSlice:(XuniRenderEngine*)engine startAngle:(double)startAngle i:(NSInteger)i reversed:(BOOL)reversed innerRadius:(double)innerRadius offset:(double)offset offsets:(NSMutableArray*)offsets angle:(double)angle cx0:(double)cx0 cy0:(double)cy0 r:(double)r maxoff:(double)maxoff irad:(double)irad sum:(double)sum renderSelected:(bool)renderSelected;
/**
 *  Render the pie control.
 *
 *  @param engine the render engine.
 */
- (void)render:(XuniRenderEngine*)engine;
/**
 *  Refresh the control if needed.
 */
- (void)invalidate;

@end

