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
- (void)shareWithType:(TQShareType)type
                title:(NSString *)title
               detail:(NSString *)detail
                image:(UIImage *)image
             imageUrl:(NSURL *)imageUrl
          relativeUrl:(NSURL *)relativeUrl;
- (void)addShareCallbackNotificationObserver:(id)observer selector:(SEL)selector object:(id)object;
- (void)removeShareCallbackNotificationObserver:(id)observer object:(id)object;

- (NSString *)defaultShareTitle;
- (NSString *)defaultShareDetail;
- (UIImage *)defaultShareImage;

@end

extern NSString * const TQShareManagerDidSendToWeiboSuccessNotification;
extern NSString * const TQShareManagerDidSendToWeiboFailedNotification;
extern NSString * const TQShareManagerDidSendToWeixinSuccessNotification;
extern NSString * const TQShareManagerDidSendToWeixinFailedNotification;
extern NSString * const TQShareManagerDidSendToQQSuccessNotification;
extern NSString * const TQShareManagerDidSendToQQFailedNotification;
extern NSString * const TQShareManagerUserCancelAuthNotification;
extern NSString * const TQShareManagerUserCancelShareNotification;