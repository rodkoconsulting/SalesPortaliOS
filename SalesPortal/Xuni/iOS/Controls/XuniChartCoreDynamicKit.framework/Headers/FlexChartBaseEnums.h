//
//  FlexChartBaseEnums.h
//  XuniChartCore
//
//  Copyright (c) GrapeCity, Inc. All rights reserved.
//

#ifndef XuniChartCore_FlexChartBaseEnums_h
#define XuniChartCore_FlexChartBaseEnums_h



/**
 *  Identifies the legend orientation.
 */
typedef NS_ENUM(NSInteger, XuniChartLegendOrientation){
    /**
     *  XuniChartLegendOrientationHorizontal.
     */
    XuniChartLegendOrientationHorizontal,
    /**
     *  XuniChartLegendOrientationVertical.
     */
    XuniChartLegendOrientationVertical,
    /**
     *  XuniChartLegendOrientationAuto
     */
    XuniChartLegendOrientationAuto
};


/**
 *  Specifies the chart type.
 */
typedef NS_ENUM(NSInteger, XuniChartType) {
    /**
     *  XuniChartTypeNull
     */
    XuniChartTypeNull,
    /**
     *  XuniChartTypeColumn
     */
    XuniChartTypeColumn,
    /**
     *  XuniChartTypeBar
     */
    XuniChartTypeBar,
    /**
     *  XuniChartTypeScatter
     */
    XuniChartTypeScatter,
    /**
     *  XuniChartTypeLine
     */
    XuniChartTypeLine,
    /**
     *  XuniChartTypeLineSymbols
     */
    XuniChartTypeLineSymbols,
    /**
     *  XuniChartTypeArea
     */
    XuniChartTypeArea,
    /**
     *  XuniChartTypeBubble
     */
    XuniChartTypeBubble,
    /**
     *  XuniChartTypeCandlestick
     */
    XuniChartTypeCandlestick,
    /**
     *  XuniChartTypeHighLowOpenClose
     */
    XuniChartTypeHighLowOpenClose,
    /**
     *  XuniChartTypeSpline
     */
    XuniChartTypeSpline,
    /**
     *  XuniChartTypeSplineSymbols
     */
    XuniChartTypeSplineSymbols,
    /**
     *  XuniChartTypeSplineArea
     */
    XuniChartTypeSplineArea
};


/**
 *  Chart elements enumeration.
 */
typedef NS_ENUM(NSInteger, XuniChartElement) {
    /**
     *  XuniChartElementPlotArea
     */
    XuniChartElementPlotArea,
    /**
     *  XuniChartElementAxisX
     */
    XuniChartElementAxisX,
    /**
     *  XuniChartElementAxisY
     */
    XuniChartElementAxisY,
    /**
     *  XuniChartElementChartArea
     */
    XuniChartElementChartArea,
    /**
     *  XuniChartElementLegend
     */
    XuniChartElementLegend,
    /**
     *  XuniChartElementHeader
     */
    XuniChartElementHeader,
    /**
     *  XuniChartElementFooter
     */
    XuniChartElementFooter,
    /**
     *  XuniChartElementAnnotation
     */
    XuniChartElementAnnotation,
    /**
     *  XuniChartElementNone
     */
    XuniChartElementNone
};

/**
 *  Specifies whether and where the Series is visible.
 */
typedef NS_ENUM(NSInteger, XuniSeriesVisibility) {
    /**
     *  The series is visible on the plot and in the legend.
     */
    XuniSeriesVisibilityVisible,
    
    /**
     *  The series is visible only on the plot.
     */
    XuniSeriesVisibilityPlot,
    
    /**
     *  The series is visible only in the legend.
     */
    XuniSeriesVisibilityLegend,
    
    /**
     *  The series is hidden.
     */
    XuniSeriesVisibilityHidden
};

/**
 *  Specifies chart data stacking options.
 */
typedef NS_ENUM(NSInteger, XuniStacking) {
    /**
     *  Sets the chart series are stacked none.
     */
    XuniStackingNone,
    
    /**
     *  Sets the chart series are stacked.
     */
    XuniStackingStacked,
    
    /**
     *  Sets the chart series are stacked 100pc.
     */
    XuniStackingStacked100pc
};

/**
 *  Specifies data selection mode of the chart.
 */
typedef NS_ENUM(NSInteger, XuniSelectionMode) {
    /**
     *  XuniSelectionModeNone
     */
    XuniSelectionModeNone,
    /**
     *  XuniSelectionModeSeries
     */
    XuniSelectionModeSeries,
    /**
     *  XuniSelectionModePoint
     */
    XuniSelectionModePoint
};


/**
 *  Specifies how to measure the distance between two points.
 */
typedef NS_ENUM(NSInteger, XuniMeasureOption) {
    /**
     *  Measure the distance between two points by calculate the distance of X coordinates.
     */
    XuniMeasureOptionX,
    /**
     *  Measure the distance between two points by calculate the distance of Y coordinates.
     */
    XuniMeasureOptionY,
    /**
     *  Measure the distance between two points.
     */
    XuniMeasureOptionXY
};


/**
 *  Identifies the position of an axis or legend on the chart.
 */
typedef NS_ENUM(NSInteger, XuniPosition) {
    /**
     *  XuniPositionNone
     */
    XuniPositionNone,
    /**
     *  Identifies the position of an axis or legend on the chart.
     */
    XuniPositionLeft,
    /**
     *  XuniPositionTop
     */
    XuniPositionTop,
    /**
     *  XuniPositionRight
     */
    XuniPositionRight,
    /**
     *  XuniPositionBottom
     */
    XuniPositionBottom
};

/**
 *  Identifies the position of an axis or legend on the chart.
 */
typedef NS_ENUM(NSInteger, XuniChartLegendPosition) {
    /**
     *  XuniChartLegendPositionNone
     */
    XuniChartLegendPositionNone,
    /**
     *  Identifies the position of an axis or legend on the chart.
     */
    XuniChartLegendPositionLeft,
    /**
     *  XuniChartLegendPositionTop
     */
    XuniChartLegendPositionTop,
    /**
     *  XuniChartLegendPositionRight
     */
    XuniChartLegendPositionRight,
    /**
     *  XuniChartLegendPositionBottom
     */
    XuniChartLegendPositionBottom,
    /**
     *  XuniChartLegendPositionAuto
     */
    XuniChartLegendPositionAuto
};


/**
 *  Specifies how plotted points are animated.
 */
typedef NS_ENUM(NSInteger, XuniAnimationMode) {
    /**
     *  XuniAnimationModeAll
     */
    XuniAnimationModeAll,
    /**
     *  XuniAnimationModePoint
     */
    XuniAnimationModePoint,
    /**
     *  XuniAnimationModeSeries
     */
    XuniAnimationModeSeries
};

/**
 *  Series plot data point marker type.
 */
typedef NS_ENUM(NSInteger, XuniMarkerType) {
    /**
     *  Mark the data point as a dot.
     */
    XuniMarkerTypeDot,
    /**
     *  Mark the data point as a rectangle box.
     */
    XuniMarkerTypeBox
};

#endif
