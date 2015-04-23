//
//  BaseViewController+Share.m
//  laohu
//
//  Created by huangluyang on 14/10/22.
//  Copyright (c) 2014年 wanmei. All rights reserved.
//

#import "UIViewController+Share.h"
#import "TQShareActionSheet.h"
#import "TQShareManager.h"

@implementation UIViewController (Share)

- (void)tq_showShareChooserWithTitle:(NSString *)title
                              detail:(NSString *)detail
                               image:(UIImage *)image
                            imageUrl:(NSURL *)imageUrl
                         relativeUrl:(NSURL *)relativeUrl
                      tappedCallback:(void (^)())tappedCallback
{
    TQShareActionSheet *as = [[TQShareActionSheet alloc] initWithTitle:@"分享到" cancelButtonTitle:@"取消"];
    
    __block TQShareActionSheet *safeAs = as;
    
    if (!relativeUrl) {
        relativeUrl = [NSURL URLWithString:@"http://www.laohu.com/laohuapp.html"];
    }
    
    if (!image) {
        image = [UIImage imageNamed:@"icon"];
    }
    
    if (!imageUrl) {
        imageUrl = [NSURL URLWithString:@"http://www.laohu.com/_s/m/app.png"];
    }
    
    TQShareActionSheetItem *weixinItem = [TQShareActionSheetItem itemWithIcon:[UIImage imageNamed:@"ic_share_weixin.png"] title:@"微信好友" selectedIcon:nil selectedTitle:nil tapped:^{
        NSLog(@"weixin");
        [[TQShareManager sharedInstance] shareWithType:TQShareTypeWeixin title:title detail:detail image:image imageUrl:imageUrl relativeUrl:relativeUrl];
        [safeAs dismissShareActionSheet];
    }];
    [as addShareItem:weixinItem];
    
    TQShareActionSheetItem *weixinTimelineItem = [TQShareActionSheetItem itemWithIcon:[UIImage imageNamed:@"ic_share_wxtimeline.png"] title:@"微信朋友圈" selectedIcon:nil selectedTitle:nil tapped:^{
        NSLog(@"timeline");
        [[TQShareManager sharedInstance] shareWithType:TQShareTypeWeixinTimeline title:title detail:detail image:image imageUrl:imageUrl relativeUrl:relativeUrl];
        [safeAs dismissShareActionSheet];
    }];
    [as addShareItem:weixinTimelineItem];
    
    TQShareActionSheetItem *weiboItem = [TQShareActionSheetItem itemWithIcon:[UIImage imageNamed:@"ic_share_weibo.png"] title:@"新浪微博" selectedIcon:nil selectedTitle:nil tapped:^{
        NSLog(@"weibo");
        [[TQShareManager sharedInstance] shareWithType:TQShareTypeWeibo title:title detail:detail image:image imageUrl:imageUrl relativeUrl:relativeUrl];
        [safeAs dismissShareActionSheet];
    }];
    [as addShareItem:weiboItem];
    
    TQShareActionSheetItem *qqItem = [TQShareActionSheetItem itemWithIcon:[UIImage imageNamed:@"ic_share_qq.png"] title:@"QQ好友" selectedIcon:nil selectedTitle:nil tapped:^{
        NSLog(@"qq");
        [[TQShareManager sharedInstance] shareWithType:TQShareTypeQQ title:title detail:detail image:image imageUrl:imageUrl relativeUrl:relativeUrl];
        [safeAs dismissShareActionSheet];
    }];
    [as addShareItem:qqItem];
    if (tappedCallback) {
        as.willDismissBlock = ^{
            tappedCallback();
        };
    }
    
    [as showShareActionSheet];
}

@end
