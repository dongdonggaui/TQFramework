//
//  HLYPullToRefreshLoadingView.h
//  HLYPullToRefreshManager
//
//  Created by huangluyang on 14-8-24.
//  Copyright (c) 2014年 huangluyang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, HLYPullToRefreshState) {
    HLYPullToRefreshStateHide,
    HLYPullToRefreshStateNormal,
    HLYPullToRefreshStatePulling,
    HLYPullToRefreshStateLoading,
};

typedef NS_ENUM(NSUInteger, HLYPullToRefreshType) {
    HLYPullToRefreshTypeRefresh,
    HLYPullToRefreshTypeLoadMore,
};

@interface HLYPullToRefreshLoadingView : UIView

@property (nonatomic, unsafe_unretained) HLYPullToRefreshState state;
@property (nonatomic, unsafe_unretained) HLYPullToRefreshType type;
@property (nonatomic, strong) NSString *updateTimeIdentifier;

- (instancetype)initWithFrame:(CGRect)frame contentView:(UIView *)contentView;

- (void)setStatusMessage:(NSString *)message forState:(HLYPullToRefreshState)state;
- (NSString *)statusMessageForState:(HLYPullToRefreshState)state;

- (void)updateWithType:(HLYPullToRefreshType)type state:(HLYPullToRefreshState)state;

/**
 *  处理滑动回调
 *
 *  @param progress 可见部分百分比
 */
- (void)updateWithProgress:(CGFloat)progress;

- (NSString *)lastUpdateTime;

@end
