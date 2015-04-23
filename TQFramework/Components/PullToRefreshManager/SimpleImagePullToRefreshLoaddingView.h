//
//  SimpleImagePullToRefreshLoaddingView.h
//  PocketForLuanDouXiYou
//
//  Created by huangluyang on 15/1/9.
//  Copyright (c) 2015年 Perfect World. All rights reserved.
//

#import "HLYPullToRefreshLoadingView.h"

@interface SimpleImagePullToRefreshLoaddingView : HLYPullToRefreshLoadingView

@property (nonatomic, strong, readonly) UIImageView *iconView;
@property (nonatomic, strong, readonly) UIImageView *loadingIconView;
@property (nonatomic, strong, readonly) UILabel *textLabel;

- (instancetype)initWithFrame:(CGRect)frame icon:(UIImage *)icon;

- (void)updateWithType:(HLYPullToRefreshType)type state:(HLYPullToRefreshState)state;

- (void)updateWithProgress:(CGFloat)progress;

@end
