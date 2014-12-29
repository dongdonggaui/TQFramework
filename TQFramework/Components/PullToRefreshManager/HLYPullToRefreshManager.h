//
//  HLYPullToRefreshManager.h
//  HLYPullToRefreshManager
//
//  Created by huangluyang on 14-8-24.
//  Copyright (c) 2014年 huangluyang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HLYPullToRefreshLoadingView.h"

/**
 *  Template:
 
 // property
 @property (nonatomic, strong) HLYPullToRefreshManager *pullToRefreshManager;
 
 */
@interface HLYPullToRefreshManager : NSObject <UITableViewDelegate> {
@protected
    UIScrollView *_scrollView;
}

// UI
@property (nonatomic, strong, readonly) UIScrollView *scrollView;

/**
 *  初始化
 */
- (instancetype)initWithScrollView:(UIScrollView *)scrollView;

// 自定义加载视图背景
@property (nonatomic, strong) UIView *headerBackgroundView;
@property (nonatomic, strong) UIView *footerBackgroundView;

// 自定义下拉刷新和上拉加载的效果只需要集成HLYPullToRefreshLoadingView，重写setState:方法，并设置以下两个属性即可
@property (nonatomic, strong) HLYPullToRefreshLoadingView *headerView;
@property (nonatomic, strong) HLYPullToRefreshLoadingView *footerView;

- (void)setHeaderUpdateTimeIdentifier:(NSString *)identifier;
- (void)setFooterUpdateTimeIdentifier:(NSString *)identifier;

- (void)updateRefreshViewState;

// callback
@property (nonatomic, copy) void (^loadNew)();
@property (nonatomic, copy) void (^loadMore)();

// state
@property (nonatomic, unsafe_unretained) BOOL enableLoadNew;
@property (nonatomic, unsafe_unretained) BOOL enableLoadMore;
@property (nonatomic, unsafe_unretained) BOOL loading;

/**
 *  自动下拉刷新
 */
- (void)triggerLoadNew;

/**
 *  结束加载，播放复原动画
 */
- (void)endLoad;

/**
 *  针对iOS7以上的UIViewcontroller的topLayoutGuide的补偿值，默认为0
 */
@property (nonatomic, unsafe_unretained) CGFloat viewTopLayoutGuide;
@property (nonatomic, unsafe_unretained) CGFloat viewBottomLayoutGuide;

/**
 *  在viewController的viewDidLayoutSubviews中调用，自动调整layoutGuide
 *
 *  @param viewController 指定的vc
 */
- (void)updateLayoutGuidesWithViewController:(UIViewController *)viewController;

/**
 *  需要的时候设置，通常iOS8以前不需要此设置，在viewController的viewDidLayoutSubviews中
 *  调用updateLayoutGuidesWithViewController:即可
 *
 *  @param topLayoutGuide 顶部inset
 *  @param viewController 指定的vc
 */
- (void)setTopLayoutGuide:(CGFloat)topLayoutGuide withViewController:(UIViewController *)viewController;

/**
 *  需要的时候设置，通常iOS8以前不需要此设置，在viewController的viewDidLayoutSubviews中
 *  调用updateLayoutGuidesWithViewController:即可
 *
 *  @param bottomLayoutGuide 底部inset
 *  @param viewController 指定的vc
 */
- (void)setBottomLayoutGuide:(CGFloat)bottomLayoutGuide withViewController:(UIViewController *)viewController;

@end
