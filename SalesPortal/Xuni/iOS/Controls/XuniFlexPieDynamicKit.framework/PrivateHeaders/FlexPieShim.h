#ifndef XUNI_INTERNAL_DYNAMIC_BUILD

#import "XuniCore/Animation.h"
#import "XuniCore/XuniTooltip.h"
#import "XuniCore/IXuniValueFormatter.h"
#import "XuniCore/CollectionView.h"
#import "XuniChartCore/ChartLoadAnimation.h"
#import "XuniChartCore/BaseChartXuniTooltipView.h"
#import "XuniCore/Easing.h"
#import "XuniCore/LicenseManager.h"

#else
#import "XuniCoreDynamicKit/XuniCoreDynamicKit.h"
#import "XuniChartCoreDynamicKit/XuniChartCoreDynamicKit.h"
#endif


/**
 *  Class FlexPieHitTestInfo.
 */
@interface FlexPieHitTestInfo : XuniHitTestInfo
@end

/**
 *  Class FlexPieDelegate.
 */
@interface FlexPieDelegate : NSObject<FlexChartDelegate>
@end

