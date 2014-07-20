//
//  HLYViewController.h
//  MyWeChat
//
//  Created by 黄露洋 on 13-11-7.
//  Copyright (c) 2013年 黄露洋. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HLYAppDelegate;
@interface HLYViewController : UIViewController

@property (nonatomic, strong) UIBarButtonItem *hlyLeftBarButtonItem;
@property (nonatomic, strong) UIBarButtonItem *hlyRightBarButtonItem;
@property (nonatomic, strong) id passValue;
@property (nonatomic, readonly) CGFloat viewTopOffset;

- (HLYAppDelegate *)appDelegate;
- (NSUserDefaults *)userDefaults;
- (void)setupViews;
- (void)hlyLeftItemDidTapped:(id)sender;
- (void)hlyRightItemDidTapped:(id)sender;
- (BOOL)needCustomLeftItem;
- (void)presentLoginViewCompleted:(void(^)(void))completed;

@end
