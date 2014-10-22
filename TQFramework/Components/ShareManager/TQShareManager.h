//
//  TQShareManager.h
//  laohu-dota-assistant
//
//  Created by huangluyang on 14-8-25.
//  Copyright (c) 2014年 wanmei. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, TQShareType) {
    TQShareTypeWeixin,
    TQShareTypeWeixinTimeline,
    TQShareTypeQQ,
    TQShareTypeWeibo,
};

@interface TQShareManager : NSObject

+ (instancetype)sharedInstance;

- (void)setup;
- (BOOL)handleOpenURL:(NSURL *)url;
- (void)authWithType:(TQShareType)type;
- (void)shareWithType:(TQShareType)type title:(NSString *)title detail:(NSString *)detail image:(UIImage *)image url:(NSString *)url;

@end

extern NSString * const TQShareManagerDidSendToWeiboSuccessNotification;
extern NSString * const TQShareManagerDidSendToWeiboFailedNotification;
