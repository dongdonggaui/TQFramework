//
//  HLYScrollContainerView.h
//  laohu
//
//  Created by huangluyang on 14-7-28.
//  Copyright (c) 2014年 wanmei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HLYScrollTabbar.h"

typedef NS_ENUM(NSUInteger, HLYScrollTabbarPosition) {
    HLYScrollTabbarPositionTop,
    HLYScrollTabbarPositionBottom,
};

/**
 *  “水平滑动式多屏容器视图”，可左右滑动切换显示视图
 */
@interface HLYScrollContainerView : UIView

@property (nonatomic, strong, readonly) HLYScrollTabbar *scrollTabbar;

// settings
@property (nonatomic, unsafe_unretained) NSInteger totalContentViewCount;

// callback
@property (nonatomic, copy) void (^didEndDeceleratingWithIndex)(HLYScrollContainerView *, NSInteger index);

- (instancetype)initWithTabbar:(HLYScrollTabbar *)tabbar position:(HLYScrollTabbarPosition)position tabbarHeight:(CGFloat)tabbarHeight;

/**
 *  配置视图
 *
 *  @param contentView 要添加到“容器视图”中的视图
 *  @param index       要添加到的位置
 */
- (void)addContentView:(UIView *)contentView atIndex:(NSInteger)index;

/**
 *  切换当前显示位置
 *
 *  @param index    要切换到的位置
 *  @param animated 切换过程中是否播放动画
 */
- (void)setContentIndex:(NSInteger)index animated:(BOOL)animated;

@end
