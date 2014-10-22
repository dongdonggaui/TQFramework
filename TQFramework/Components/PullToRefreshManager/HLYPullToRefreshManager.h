//
//  HLYPullToRefreshManager.h
//  HLYPullToRefreshManager
//
//  Created by huangluyang on 14-8-24.
//  Copyright (c) 2014年 huangluyang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HLYPullToRefreshLoadingView.h"

@interface HLYPullToRefreshManager : NSObject <UITableViewDelegate>

// callback
@property (nonatomic, copy) void (^loadNew)();
@property (nonatomic, copy) void (^loadMore)();
@property (nonatomic, copy) void (^didSelectedTableViewAtIndexPath)(UITableView *tableView, NSIndexPath *indexPath);
@property (nonatomic, copy) CGFloat (^cellHeightForTableViewAtIndexPath)(UITableView *tableView, NSIndexPath *indexPath);
@property (nonatomic, copy) CGFloat (^estimatedCellHeightForTableViewAtIndexPath)(UITableView *tableView, NSIndexPath *indexPath);
@property (nonatomic, copy) UIView * (^headerViewForTableViewInSection)(UITableView *tableView, NSInteger section);
@property (nonatomic, copy) CGFloat (^headerViewHeightForTableViewInSection)(UITableView *tableView, NSInteger section);

// state
@property (nonatomic, unsafe_unretained) BOOL enableLoadNew;
@property (nonatomic, unsafe_unretained) BOOL enableLoadMore;
@property (nonatomic, unsafe_unretained) BOOL loading;

// UI
@property (nonatomic, weak, readonly) UITableView *tableView;

// 自定义加载视图背景
@property (nonatomic, strong) UIView *headerBackgroundView;
@property (nonatomic, strong) UIView *footerBackgroundView;

// 自定义下拉刷新和上拉加载的效果只需要集成HLYPullToRefreshLoadingView，重写setState:方法，并设置以下两个属性即可
@property (nonatomic, strong) HLYPullToRefreshLoadingView *headerView;
@property (nonatomic, strong) HLYPullToRefreshLoadingView *footerView;

/**
 *  初始化
 */
- (instancetype)initWithTableView:(UITableView *)tableView;

/**
 *  自动下拉刷新
 */
- (void)triggerLoadNew;

/**
 *  结束加载，播放复原动画
 */
- (void)endLoad;

- (void)setHeaderUpdateTimeIdentifier:(NSString *)identifier;
- (void)setFooterUpdateTimeIdentifier:(NSString *)identifier;

@end
