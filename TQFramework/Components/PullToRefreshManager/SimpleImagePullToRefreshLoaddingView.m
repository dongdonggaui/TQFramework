//
//  SimpleImagePullToRefreshLoaddingView.m
//  PocketForLuanDouXiYou
//
//  Created by huangluyang on 15/1/9.
//  Copyright (c) 2015年 Perfect World. All rights reserved.
//

#import "SimpleImagePullToRefreshLoaddingView.h"
#import "UIView+Frame.h"
#import <UIImage+ImageWithColor.h>
#import <POP.h>

@interface SimpleImagePullToRefreshLoaddingView ()

@property (nonatomic, strong) UIImageView *iconView;
@property (nonatomic, strong) UIImageView *loadingIconView;
@property (nonatomic, strong) UILabel *textLabel;

@property (nonatomic, assign) BOOL isPlayingLoadingAnimation;

@end

@implementation SimpleImagePullToRefreshLoaddingView

- (instancetype)initWithFrame:(CGRect)frame icon:(UIImage *)icon
{
    if (self = [super initWithFrame:frame]) {
        if (!icon) {
            icon = [UIImage imageWithColor:[UIColor yellowColor] size:CGSizeMake(15, 15)];
        }
        _iconView = [[UIImageView alloc] initWithImage:icon];
        [self addSubview:_iconView];
        
        _loadingIconView = [[UIImageView alloc] initWithImage:icon];
        _loadingIconView.hidden = YES;
        [self addSubview:_loadingIconView];
        
        _textLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [self addSubview:_textLabel];
        
        _isPlayingLoadingAnimation = NO;
    }
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat centerX = [self hly_width] * 0.5;
    CGFloat vertSpace = 5;
    
    [self.textLabel sizeToFit];
    
    CGFloat top = ([self hly_height] - [self.iconView hly_height] - vertSpace - [self.textLabel hly_height]) * 0.5;
    
    [self.iconView hly_setCenterX:centerX];
    [self.iconView hly_setTop:top];
    
    [self.loadingIconView hly_setCenterX:centerX];
    [self.loadingIconView hly_setTop:top];
    
    [self.textLabel hly_setCenterX:centerX];
    [self.textLabel hly_setTop:[self.iconView hly_bottom] + vertSpace];
}

- (void)updateWithType:(HLYPullToRefreshType)type state:(HLYPullToRefreshState)state
{
    if (state == HLYPullToRefreshStateLoading) {
        [self startLoadingAnimation];
    } else {
        [self stopLoadingAnimation];
    }
    
    switch (state) {
            
        case HLYPullToRefreshStateNormal: {
            
            self.textLabel.hidden = NO;
            
            if (self.state != HLYPullToRefreshStateNormal) {
                [UIView animateWithDuration:0.25 animations:^{
                    
                    self.iconView.layer.transform = CATransform3DIdentity;
                }];
            }
            
            break;
        }
            
        case HLYPullToRefreshStatePulling:
            
            self.textLabel.hidden = NO;
            
            if (self.state != HLYPullToRefreshStatePulling) {
                [UIView animateWithDuration:0.25 animations:^{
                    self.iconView.layer.transform = CATransform3DMakeRotation((M_PI / 180.0) * 180.0f, 0.0f, 0.0f, 1.0f);
                }];
            }
            
            break;
            
        case HLYPullToRefreshStateLoading:
            
            self.textLabel.hidden = NO;
            
            break;
            
        case HLYPullToRefreshStateHide:
        default:
            self.textLabel.hidden = YES;
            
            break;
    }
    
    self.textLabel.text = [self statusMessageForState:state];
}

- (void)updateWithProgress:(CGFloat)progress
{
    
}

- (void)startLoadingAnimation
{
    if (self.isPlayingLoadingAnimation) {
        return;
    }
    
    self.isPlayingLoadingAnimation = YES;
    self.iconView.hidden = YES;
    self.loadingIconView.hidden = NO;
    
    CABasicAnimation *rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat:M_PI];
    rotationAnimation.duration = 0.5;
    rotationAnimation.repeatCount = MAXFLOAT;
    rotationAnimation.cumulative = YES;
    [self.loadingIconView.layer addAnimation:rotationAnimation forKey:@"rotationAnimation1"];
}

- (void)stopLoadingAnimation
{
    if (!self.isPlayingLoadingAnimation) {
        return;
    }
    
    self.isPlayingLoadingAnimation = NO;
    self.iconView.hidden = NO;
    self.loadingIconView.hidden = YES;
    
    [self.loadingIconView.layer removeAnimationForKey:@"rotationAnimation1"];
}

@end
