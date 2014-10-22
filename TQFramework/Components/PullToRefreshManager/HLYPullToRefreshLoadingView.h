//
//  HLYPullToRefreshLoadingView.h
//  HLYPullToRefreshManager
//
//  Created by huangluyang on 14-8-24.
//  Copyright (c) 2014年 huangluyang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, HLYPullToRefreshState) {
    HLYPullToRefreshStateNormal,
    HLYPullToRefreshStatePulling,
    HLYPullToRefreshStateLoading,
};

typedef NS_ENUM(NSUInteger, HLYPullToRefreshType) {
    HLYPullToRefreshTypeRefresh,
    HLYPullToRefreshTypeLoadMore,
};

@interface HLYPullToRefreshLoadingView : UIView

@property (nonatomic, strong, readonly) UILabel *stateLabel;
@property (nonatomic, strong, readonly) UILabel *timeLabel;

@property (nonatomic, unsafe_unretained) HLYPullToRefreshState state;
@property (nonatomic, unsafe_unretained) HLYPullToRefreshType type;
@property (nonatomic, strong) NSString *updateTimeIdentifier;

- (void)setStatusMessage:(NSString *)message forState:(HLYPullToRefreshState)state;

@end
