//
//  FlexChartEnums.h
//  FlexChart
//
//  Copyright (c) GrapeCity, Inc. All rights reserved.
//

#ifndef FlexChart_FlexChartEnums_h
#define FlexChart_FlexChartEnums_h

/**
 *  the switch for displaying OverlappingLabels.
 */
typedef NS_ENUM(NSInteger, XuniChartOverlappingLabels){
    /**
     *  XuniChartOverlappingLabelsAuto
     */
    XuniChartOverlappingLabelsAuto,
    /**
     *  XuniChartOverlappingLabelsShow
     */
    XuniChartOverlappingLabelsShow
};

/**
 *  Identifies the axis type.
 */
typedef NS_ENUM(NSInteger, XuniAxisType){
    /**
     *  XuniAxisTypeX
     */
    XuniAxisTypeX,
    /**
     *  XuniAxisTypeY
     */
    XuniAxisTypeY
};

/**
 *  Specifies the appearance of axis tick marks.
 */
typedef NS_ENUM(NSInteger, XuniTickMark){
    /**
     *  XuniTickMarkNone
     */
    XuniTickMarkNone,
    /**
     *  XuniTickMarkOutside
     */
    XuniTickMarkOutside,
    /**
     *  XuniTickMarkInside
     */
    XuniTickMarkInside,
    /**
     *  XuniTickMarkCross
     */
    XuniTickMarkCross
};

/**
 *  Specifies the axis scrolling behavior.
 */
typedef NS_ENUM(NSInteger, XuniZoomMode){
    /**
     *  XuniZoomModeX
     */
    XuniZoomModeX,
    /**
     *  XuniZoomModeY
     */
    XuniZoomModeY,
    /**
     *  XuniZoomModeXY
     */
    XuniZoomModeXY,
    /**
     *  XuniZoomModeDisabled
     */
    XuniZoomModeDisabled
};

/**
 *  XuniAxisScrollPosition
 */
typedef NS_ENUM(NSInteger, XuniAxisScrollPosition){
    /**
     *  XuniAxisScrollPositionMin
     */
    XuniAxisScrollPositionMin,
    /**
     *  XuniAxisScrollPositionCenter
     */
    XuniAxisScrollPositionCenter,
    /**
     *  XuniAxisScrollPositionMax
     */
    XuniAxisScrollPositionMax
};

/**
 *  Specifies the line type for the LineMarker.
 */
typedef NS_ENUM(NSInteger, XuniChartMarkerLines){
    /**
     *  Show no lines.
     */
    XuniChartMarkerLinesNone,
    /**
     *  Show a vertical line.
     */
    XuniChartMarkerLinesVertical,
    /**
     *  Show a horizontal line.
     */
    XuniChartMarkerLinesHorizontal,
    /**
     *  Show both vertical and horizontal lines.
     */
    XuniChartMarkerLinesBoth
};

/**
 *  Specifies how the LineMarker interacts with the user.
 */
typedef NS_ENUM(NSInteger, XuniChartMarkerInteraction){
    /**
     *  No interaction.
     */
    XuniChartMarkerInteractionNone,
    /**
     *  The LineMarker moves when the user taps or drags along the plot.
     */
    XuniChartMarkerInteractionMove,
    /**
     *  The LineMarker moves when the user touches down on the line or marker itself and drags.
     */
    XuniChartMarkerInteractionDrag
};

/**
 *  Specifies the alignment of the LineMarker.
 */
typedef NS_ENUM(NSInteger, XuniChartMarkerAlignment){
    /**
     *  The LineMarker alignment adjusts automatically.
     */
    XuniChartMarkerAlignmentAuto,
    /**
     *  The LineMarker aligns to the bottom right of the point.
     */
    XuniChartMarkerAlignmentBottomRight,
    /**
     *  The LineMarker aligns to the bottom left of the point.
     */
    XuniChartMarkerAlignmentBottomLeft,
    /**
     *  The LineMarker aligns to the top right of the point.
     */
    XuniChartMarkerAlignmentTopRight,
    /**
     *  The LineMarker aligns to the top left of the point.
     */
    XuniChartMarkerAlignmentTopLeft
};

/**
 *  Specifies the type of PlotElementLoading event.
 */
typedef NS_ENUM(NSInteger, XuniPlotElementLoadingType) {
    /**
     *  No PlotElementLoading event, render default element.
     */
    XuniPlotElementLoadingTypeNone,
    /**
     *  Handle native PlotElementLoading event.
     */
    XuniPlotElementLoadingTypeNative,
    /**
     *  Handle Xamarin Form PlotElementLoading event.
     */
    XuniPlotElementLoadingTypeXF
};

/**
 *  Specifies the attachment of the annotation.
 */
typedef NS_ENUM(NSInteger, XuniChartAnnotationAttachment) {
    /**
     *  The coordinates of the annotation are specified by the annotation's shape data in pixels.
     */
    XuniChartAnnotationAttachmentAbsolute,
    /**
     *  The annotation coordinates are specified in data coordinates.
     */
    XuniChartAnnotationAttachmentDataCoordinate,
    /**
     *  The annotation coordinates are specified by the data series index and point index.
     */
    XuniChartAnnotationAttachmentDataIndex,
    /**
     *  The annotation coordinates are specified as a relative position within the control 
     *  where (0,0) is the top left corner and (1,1) is the bottom right corner.
     */
    XuniChartAnnotationAttachmentRelative
};

/**
 *  Specifies the position of the annotation.
 */
typedef NS_ENUM(NSInteger, XuniChartAnnotationPosition) {
    /**
     *  The annotation appears at the bottom of the target point.
     */
    XuniChartAnnotationPositionBottom,
    /**
     *  The annotation appears at the center of the target point.
     */
    XuniChartAnnotationPositionCenter,
    /**
     *  The annotation appears to the left of the target point.
     */
    XuniChartAnnotationPositionLeft,
    /**
     *  The annotation appears to the right of the target point.
     */
    XuniChartAnnotationPositionRight,
    /**
     *  The annotation appears at the top of the target point.
     */
    XuniChartAnnotationPositionTop
};

#endif
