//
//  HLYDemonstrateView.h
//  laohu-dota-assistant
//
//  Created by huangluyang on 14-7-31.
//  Copyright (c) 2014年 wanmei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HLYDemonstrateView : UIView

- (id)initWithFrame:(CGRect)frame animationDuration:(NSTimeInterval)animationDuration;

- (void)setContentUrls:(NSArray *)contentUrls withTapActionBloack:(void (^)(NSInteger pageIndex))tappedAtIndex;
- (void)stopLoadWebImage;

@end
