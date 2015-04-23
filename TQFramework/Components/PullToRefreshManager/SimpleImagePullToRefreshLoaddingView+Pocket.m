//
//  SimpleImagePullToRefreshLoaddingView+Pocket.m
//  PocketForLuanDouXiYou
//
//  Created by huangluyang on 15/1/9.
//  Copyright (c) 2015年 Perfect World. All rights reserved.
//

#import "SimpleImagePullToRefreshLoaddingView+Pocket.h"
#import <UIColor+Hex.h>

@implementation SimpleImagePullToRefreshLoaddingView (Pocket)

+ (instancetype)pa_defaultLoadingViewWithWidth:(CGFloat)width
{
    SimpleImagePullToRefreshLoaddingView *loadingView = [[SimpleImagePullToRefreshLoaddingView alloc] initWithFrame:CGRectMake(0, 0, width, 60) icon:nil];
    loadingView.textLabel.font = [UIFont systemFontOfSize:11.0f];
    loadingView.textLabel.textColor = UIColorFromRGB(0x484848);
    loadingView.iconView.image = [UIImage imageNamed:@"ic_pull_refresh_normal"];
    loadingView.loadingIconView.image = [UIImage imageNamed:@"ic_pull_refresh_loading"];
    
    return loadingView;
}

@end
