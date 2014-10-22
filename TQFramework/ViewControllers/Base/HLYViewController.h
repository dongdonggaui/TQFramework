//
//  HLYViewController.h
//  MyWeChat
//
//  Created by 黄露洋 on 13-11-7.
//  Copyright (c) 2013年 黄露洋. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TQSlideController.h"

@class HWDAppDelegate;
@interface HLYViewController : UIViewController

@property (nonatomic, strong) UIBarButtonItem *hlyLeftBarButtonItem;
@property (nonatomic, strong) UIBarButtonItem *hlyRightBarButtonItem;
@property (nonatomic, strong) id passValue;

- (HWDAppDelegate *)hly_appDelegate;
- (NSUserDefaults *)hly_userDefaults;
- (CGFloat)hly_topLayoutGuideLength;
- (void)hly_leftItemDidTapped:(id)sender;
- (void)hly_rightItemDidTapped:(id)sender;
- (BOOL)hly_needCustomLeftItem;
- (void)hly_presentLoginViewCompleted:(void(^)(void))completed;

@end
