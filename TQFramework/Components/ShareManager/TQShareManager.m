//
//  TQShareManager.m
//  laohu-dota-assistant
//
//  Created by huangluyang on 14-8-25.
//  Copyright (c) 2014年 wanmei. All rights reserved.
//

#import "TQShareManager.h"
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApi.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import "WXApi.h"
#import "WeiboSDK.h"
#import "AFNetworking.h"

static NSString * const TQShareManagerTencentAppId = @"1101744301";
static NSString * const TQShareManagerTencentAppSecret = @"cKbF1l9UzLa6ZMfP";

static NSString * const TQShareManagerWeixinAppId = @"wx60486d8ced1ed29e";
//static NSString * const TQShareManagerWeixinAppSecret = @"88fe49805ccb20928a2f81ed11b21ed0";

static NSString * const TQShareManagerWeiboShareUrl = @"https://upload.api.weibo.com/2/statuses/upload.json";
static NSString * const TQShareManagerWeiboShareWithoutImageUrl = @"https://api.weibo.com/2/statuses/repost.json";
static NSString * const TQShareManagerWeiboAppId = @"3292682220";
static NSString * const TQShareManagerWeiboAppSecret = @"7348b41a73640abe9d8e53e1def2424f";
static NSString * const TQShareManagerWeiboRedirectUrl = @"http://open.weibo.com/apps/3292682220/privilege/oauth";

static NSString * const TQShareManagerDefaultShareTitle = @"大手刀塔传奇助手";
static NSString * const TQShareManagerDefaultShareDetail = @"大手刀塔传奇助手";

NSString * const TQShareManagerDidSendToWeiboSuccessNotification = @"com.hly.share.notification.weibo.sendsuccess";
NSString * const TQShareManagerDidSendToWeiboFailedNotification = @"com.hly.share.notification.weibo.sendfailed";

NSString * const TQShareManagerDidSendToWeixinSuccessNotification = @"com.hly.share.notification.weixin.sendsuccess";
NSString * const TQShareManagerDidSendToWeixinFailedNotification = @"com.hly.share.notification.weixin.sendfailed";

NSString * const TQShareManagerDidSendToQQSuccessNotification = @"com.hly.share.notification.qq.sendsuccess";
NSString * const TQShareManagerDidSendToQQFailedNotification = @"com.hly.share.notification.qq.sendfailed";

NSString * const TQShareManagerUserCancelAuthNotification = @"com.hly.share.notification.cancel.auth";
NSString * const TQShareManagerUserCancelShareNotification = @"com.hly.share.notification.cancel.share";

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

@interface TQWeiboOAuth : NSObject

+ (instancetype)sharedInstance;

/** Access Token凭证，用于后续访问各开放接口 */
@property (nonatomic, copy) NSString * accessToken;

/** Access Token的失效期 */
@property (nonatomic, copy) NSDate   * expirationDate;

/** 用户授权登录后对该用户的唯一标识 */
@property (nonatomic, copy) NSString * openId;

@end

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

@interface TQShareManager () <WXApiDelegate, TencentSessionDelegate, QQApiInterfaceDelegate, WeiboSDKDelegate, WBHttpRequestDelegate>

@property (nonatomic, strong) TencentOAuth *tencentOAuth;

@end

@implementation TQShareManager

+ (instancetype)sharedInstance
{
    static TQShareManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!sharedManager) {
            sharedManager = [[TQShareManager alloc] init];
        }
    });
    
    return sharedManager;
}

#pragma mark -
#pragma mark - public
- (void)setup
{
    self.tencentOAuth = [[TencentOAuth alloc] initWithAppId:TQShareManagerTencentAppId andDelegate:self];
    [WeiboSDK enableDebugMode:YES];
    [WeiboSDK registerApp:TQShareManagerWeiboAppId];
    
    [WXApi registerApp:TQShareManagerWeixinAppId];
}

- (BOOL)handleOpenURL:(NSURL *)url
{
    NSString *path = url.absoluteString;
    if ([path hasPrefix:@"tencent"]) {
        return [QQApiInterface handleOpenURL:url delegate:self];
    } else if ([path hasPrefix:@"wx"]) {
        return [WXApi handleOpenURL:url delegate:self];
    } else if ([path hasPrefix:@"wb"]) {
        return [WeiboSDK handleOpenURL:url delegate:self];
    }
    
    return NO;
}

- (void)authWithType:(TQShareType)type
{
    if (type == TQShareTypeQQ) {
        [self.tencentOAuth authorize:@[kOPEN_PERMISSION_GET_USER_INFO]];
    } else if (type == TQShareTypeWeibo) {
        WBAuthorizeRequest *request = [WBAuthorizeRequest request];
        request.redirectURI = TQShareManagerWeiboRedirectUrl;
        request.scope = @"follow_app_official_microblog";
        request.userInfo = @{@"other_info": @(123)};
        [WeiboSDK sendRequest:request];
    }
}

- (void)shareWithType:(TQShareType)type
                title:(NSString *)title
               detail:(NSString *)detail
                image:(UIImage *)image
             imageUrl:(NSURL *)imageUrl
          relativeUrl:(NSURL *)relativeUrl
{
    BOOL shareEnabled = NO;
    switch (type) {
        case TQShareTypeWeixin:
        case TQShareTypeWeixinTimeline:
        {
            shareEnabled = [self checkIfWeixinShareEnabled];
            break;
        }
        case TQShareTypeQQ:
            shareEnabled = YES;
            break;
        case TQShareTypeWeibo:
            shareEnabled = YES;
            break;
        default:
            break;
    }
    
    if(shareEnabled)
    {
        
        UIImage *thumbnail = nil;
        if(image) {
            thumbnail = [self thumbImageWithImage:image limitSize:CGSizeMake(150.f, 150.f)];
        } else {
            thumbnail = [self thumbImageWithImage:[UIImage skinImageNamed:@"icon.png"] limitSize:CGSizeMake(150.f, 150.f)];
        }
        
        title = title ? : [self defaultShareTitle];
        detail = detail ? : [self defaultShareDetail];
        
        switch(type)
        {
            case TQShareTypeWeixin:
            case TQShareTypeWeixinTimeline:
            {
                WXMediaMessage *message = [WXMediaMessage message];
                message.thumbData = UIImageJPEGRepresentation(thumbnail, 0.1);
                
                if(title)
                {
                    message.title = title;
                }
                
                if(detail)
                {
                    message.description = detail;
                }
                
                if(relativeUrl)
                {
                    WXWebpageObject *webObj = [WXWebpageObject object];
                    webObj.webpageUrl = relativeUrl.absoluteString;
                    message.mediaObject = webObj;
                }
                
                SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
                
                if(type == TQShareTypeWeixin)
                {
                    req.scene = WXSceneSession;
                }
                else
                {
                    req.scene = WXSceneTimeline;
                }
                req.bText = NO;
                req.message = message;
                [WXApi sendReq:req];
                
                break;
            }
                
            case TQShareTypeQQ:
            {
                QQApiNewsObject *newsObj = nil;
                if (imageUrl) {         // 优先使用imageUrl
                    newsObj = [QQApiNewsObject objectWithURL:relativeUrl title:title description:detail previewImageURL:imageUrl];
                } else if (thumbnail) {
                    newsObj = [QQApiNewsObject objectWithURL:relativeUrl title:title description:detail previewImageData:UIImageJPEGRepresentation(thumbnail, 0.1)];
                } else {
                    newsObj = [QQApiNewsObject objectWithURL:relativeUrl title:title description:detail previewImageURL:nil];
                }
                SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:newsObj];
                QQApiSendResultCode sent = [QQApiInterface sendReq:req];
                [self handleQQSendResult:sent];
                DLog(@"qq sent code --> %d", sent);
                
                break;
            }
                
            case TQShareTypeWeibo:
            {
                if ([WeiboSDK isWeiboAppInstalled]) {
                    
                    WBMessageObject *message = [WBMessageObject message];
                    message.text = detail;
                    if (thumbnail) {
                        WBImageObject *imageObj = [WBImageObject object];
                        imageObj.imageData = UIImageJPEGRepresentation(thumbnail, 0.01);
                        message.imageObject = imageObj;
                    }
                    
                    WBSendMessageToWeiboRequest *request = [WBSendMessageToWeiboRequest requestWithMessage:message];
                    
                    [WeiboSDK sendRequest:request];
                    
                } else {
                    
                    WBAuthorizeRequest *request = [WBAuthorizeRequest request];
                    request.redirectURI = TQShareManagerWeiboRedirectUrl;
                    request.scope = @"follow_app_official_microblog";
                    NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithDictionary:@{@"type": @"share"}];
                    NSMutableDictionary *content = [NSMutableDictionary dictionaryWithDictionary:@{@"text": detail}];
                    if (thumbnail) {
                        [content setObject:UIImageJPEGRepresentation(thumbnail, 0.01) forKey:@"image"];
                    }
                    [userInfo setObject:content forKey:@"content"];
                    request.userInfo = userInfo;
                    
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [WeiboSDK sendRequest:request];
                    });
                }
                
                
                break;
            }
            default:
                break;
        }
    }
}

- (void)addShareCallbackNotificationObserver:(id)observer selector:(SEL)selector object:(id)object
{
    if (!observer || !selector) {
        return;
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:observer selector:selector name:TQShareManagerDidSendToWeiboSuccessNotification object:object];
    [[NSNotificationCenter defaultCenter] addObserver:observer selector:selector name:TQShareManagerDidSendToWeiboFailedNotification object:object];
    [[NSNotificationCenter defaultCenter] addObserver:observer selector:selector name:TQShareManagerDidSendToWeixinSuccessNotification object:object];
    [[NSNotificationCenter defaultCenter] addObserver:observer selector:selector name:TQShareManagerDidSendToWeixinFailedNotification object:object];
    [[NSNotificationCenter defaultCenter] addObserver:observer selector:selector name:TQShareManagerDidSendToQQSuccessNotification object:object];
    [[NSNotificationCenter defaultCenter] addObserver:observer selector:selector name:TQShareManagerDidSendToQQFailedNotification object:object];
    [[NSNotificationCenter defaultCenter] addObserver:observer selector:selector name:TQShareManagerUserCancelAuthNotification object:object];
    [[NSNotificationCenter defaultCenter] addObserver:observer selector:selector name:TQShareManagerUserCancelShareNotification object:object];
}

- (void)removeShareCallbackNotificationObserver:(id)observer object:(id)object
{
    if (!observer) {
        return;
    }
    
    [[NSNotificationCenter defaultCenter] removeObserver:observer name:TQShareManagerDidSendToWeiboSuccessNotification object:object];
    [[NSNotificationCenter defaultCenter] removeObserver:observer name:TQShareManagerDidSendToWeiboFailedNotification object:object];
    [[NSNotificationCenter defaultCenter] removeObserver:observer name:TQShareManagerDidSendToWeixinSuccessNotification object:object];
    [[NSNotificationCenter defaultCenter] removeObserver:observer name:TQShareManagerDidSendToWeixinFailedNotification object:object];
    [[NSNotificationCenter defaultCenter] removeObserver:observer name:TQShareManagerDidSendToQQSuccessNotification object:object];
    [[NSNotificationCenter defaultCenter] removeObserver:observer name:TQShareManagerDidSendToQQFailedNotification object:object];
    [[NSNotificationCenter defaultCenter] removeObserver:observer name:TQShareManagerUserCancelAuthNotification object:object];
    [[NSNotificationCenter defaultCenter] removeObserver:observer name:TQShareManagerUserCancelShareNotification object:object];
}

- (NSString *)defaultShareTitle
{
    return TQShareManagerDefaultShareTitle;
}

- (NSString *)defaultShareDetail
{
    return TQShareManagerDefaultShareDetail;
}

- (UIImage *)defaultShareImage
{
    return [self thumbImageWithImage:[UIImage skinImageNamed:@"icon.png"] limitSize:CGSizeMake(150.f, 150.f)];
}


#pragma mark -
#pragma mark - private
- (BOOL)checkIfWeixinShareEnabled
{
    BOOL enabled = ([WXApi isWXAppInstalled] && [WXApi isWXAppSupportApi]);
    if(!enabled)
    {
        [DGAlertView showAlertTitle:@"您还没有安装微信或者您微信的版本不支持分享功能!" message:nil alertStyle:AlertStyleFail];
    }
    return enabled;
}

- (UIImage *)thumbImageWithImage:(UIImage *)scImg limitSize:(CGSize)limitSize
{
    if(scImg.size.width <= limitSize.width && scImg.size.height <= limitSize.height)
    {
        return scImg;
    }
    CGSize thumbSize;
    if(scImg.size.width/scImg.size.height > limitSize.width/limitSize.height)
    {
        thumbSize.width = limitSize.width;
        thumbSize.height = limitSize.width/scImg.size.width * scImg.size.height;
    } else {
        thumbSize.height = limitSize.height;
        thumbSize.width = limitSize.height/scImg.size.height * scImg.size.width;
    }
    UIGraphicsBeginImageContext(thumbSize);
    [scImg drawInRect:(CGRect){CGPointZero,thumbSize}];
    UIImage *thumbImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return thumbImg;
}

- (void)handleQQSendResult:(QQApiSendResultCode)sendResult
{
    switch (sendResult)
    {
        case EQQAPIAPPNOTREGISTED:
        {
            DLog(@"App未注册");
            break;
        }
        case EQQAPIMESSAGECONTENTINVALID:
        case EQQAPIMESSAGECONTENTNULL:
        case EQQAPIMESSAGETYPEINVALID:
        {
            DLog(@"发送参数错误");
            break;
        }
        case EQQAPIQQNOTINSTALLED:
        {
            DLog(@"未安装手Q");
            break;
        }
        case EQQAPIQQNOTSUPPORTAPI:
        {
            DLog(@"API接口不支持");
            break;
        }
        case EQQAPISENDFAILD:
        {
            DLog(@"发送失败");
            break;
        }
        case EQQAPIQZONENOTSUPPORTTEXT:
        {
            DLog(@"空间分享不支持纯文本分享，请使用图文分享");
            break;
        }
        case EQQAPIQZONENOTSUPPORTIMAGE:
        {
            DLog(@"空间分享不支持纯图片分享，请使用图文分享");
            break;
        }
        default:
        {
            break;
        }
    }
}

#pragma mark -
#pragma mark - tecent
- (void)tencentDidLogin
{
    DLog(@"tencent did login");
}

- (void)tencentDidNotLogin:(BOOL)cancelled
{
    DLog(@"cancelled --> %@", cancelled ? @"YES" : @"NO");
    if (cancelled) {
        [[NSNotificationCenter defaultCenter] postNotificationName:TQShareManagerUserCancelAuthNotification object:nil];
    }
}

- (void)tencentDidNotNetWork
{
    DLog(@"unreachable");
}

- (BOOL)onTencentReq:(TencentApiReq *)req
{
    DLog(@"req --> %@", req);
    
    return YES;
}

- (BOOL)onTencentResp:(TencentApiResp *)resp
{
    DLog(@"resp --> %@", resp);
    
    return YES;
}

#pragma mark -
#pragma mark - weibo auth/client delegate
- (void)didReceiveWeiboRequest:(WBBaseRequest *)request
{
    
}

- (void)didReceiveWeiboResponse:(WBBaseResponse *)response
{
    if ([response isKindOfClass:[WBAuthorizeResponse class]]) {
        WBAuthorizeResponse *autorizeResponse = (WBAuthorizeResponse *)response;
        if (autorizeResponse.statusCode == WeiboSDKResponseStatusCodeSuccess) {
            [TQWeiboOAuth sharedInstance].accessToken = autorizeResponse.accessToken;
            [TQWeiboOAuth sharedInstance].expirationDate = autorizeResponse.expirationDate;
            [TQWeiboOAuth sharedInstance].openId = autorizeResponse.userID;
            
            if (response.requestUserInfo) {
                NSString *type = [response.requestUserInfo objectForKey:@"type"];
                if (type && [type isEqualToString:@"share"]) {
                    NSDictionary *content = [response.requestUserInfo objectForKey:@"content"];
                    if (!content) {
                        return;
                    }
                    
                    NSString *text = [content objectForKey:@"text"];
                    if (!text) {
                        return;
                    }
                    
                    NSData *imageData = [content objectForKey:@"image"];
                    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithCapacity:3];
                    NSString *shareUrl = TQShareManagerWeiboShareWithoutImageUrl;
                    [parameters setObject:text forKey:@"status"];
                    [parameters setObject:autorizeResponse.accessToken forKey:@"access_token"];
                    if (imageData) {
                        [parameters setObject:imageData forKey:@"pic"];
                        shareUrl = TQShareManagerWeiboShareUrl;
                    }
                    
                    [WBHttpRequest requestWithAccessToken:autorizeResponse.accessToken url:shareUrl httpMethod:@"POST" params:parameters delegate:self withTag:nil];
                }
            }
        } else if (autorizeResponse.statusCode == WeiboSDKResponseStatusCodeUserCancel ||
                   autorizeResponse.statusCode == WeiboSDKResponseStatusCodeUserCancelInstall) {
            [[NSNotificationCenter defaultCenter] postNotificationName:TQShareManagerUserCancelAuthNotification object:nil];
        } else {
            [[NSNotificationCenter defaultCenter] postNotificationName:TQShareManagerDidSendToWeiboFailedNotification object:nil];
        }
    } else if ([response isKindOfClass:[WBSendMessageToWeiboResponse class]]) {
        if (response.statusCode == WeiboSDKResponseStatusCodeSuccess) {
            [[NSNotificationCenter defaultCenter] postNotificationName:TQShareManagerDidSendToWeiboSuccessNotification object:nil];
        } else if (response.statusCode == WeiboSDKResponseStatusCodeUserCancel) {
            [[NSNotificationCenter defaultCenter] postNotificationName:TQShareManagerUserCancelShareNotification object:nil];
        } else {
            [[NSNotificationCenter defaultCenter] postNotificationName:TQShareManagerDidSendToWeiboFailedNotification object:nil];
        }
    }
}

#pragma mark -
#pragma mark - weibo http delegate
- (void)request:(WBHttpRequest *)request didReceiveResponse:(NSURLResponse *)response
{
    
}

- (void)request:(WBHttpRequest *)request didFailWithError:(NSError *)error
{
    [[NSNotificationCenter defaultCenter] postNotificationName:TQShareManagerDidSendToWeiboFailedNotification object:error];
}

- (void)request:(WBHttpRequest *)request didFinishLoadingWithResult:(NSString *)result
{
    
}

- (void)request:(WBHttpRequest *)request didFinishLoadingWithDataResult:(NSData *)data
{
    NSError *error = nil;
    NSDictionary *responseObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
    if (!error && responseObject && [responseObject isKindOfClass:[NSDictionary class]] && ![responseObject objectForKey:@"error"]) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:TQShareManagerDidSendToWeiboSuccessNotification object:responseObject];
    } else {
        [[NSNotificationCenter defaultCenter] postNotificationName:TQShareManagerDidSendToWeiboFailedNotification object:error];
    }
}

#pragma mark -
#pragma mark - weixin/qq
- (void)onResp:(id)resp
{
    if ([resp isKindOfClass:[BaseResp class]]) {
        BaseResp *theResp = (BaseResp *)resp;
        if (theResp.errCode == WXSuccess) {
            [[NSNotificationCenter defaultCenter] postNotificationName:TQShareManagerDidSendToWeixinSuccessNotification object:nil];
        } else if (theResp.errCode == WXErrCodeUserCancel) {
            [[NSNotificationCenter defaultCenter] postNotificationName:TQShareManagerUserCancelShareNotification object:nil];
        } else {
            [[NSNotificationCenter defaultCenter] postNotificationName:TQShareManagerDidSendToWeixinFailedNotification object:nil];
        }
    } else if ([resp isKindOfClass:[QQBaseResp class]]) {
        QQBaseResp *theResp = (QQBaseResp *)resp;
        DLog(@"qq resp type --> %d, msg --> %@， info --> %@, result --> %@", theResp.type, theResp.errorDescription, theResp.extendInfo, theResp.result);
        if (theResp.type == 2 && !theResp.errorDescription && theResp.result.intValue == 0) {
            [[NSNotificationCenter defaultCenter] postNotificationName:TQShareManagerDidSendToQQSuccessNotification object:nil];
        } else if (theResp.result.intValue == -4) {
            [[NSNotificationCenter defaultCenter] postNotificationName:TQShareManagerUserCancelShareNotification object:nil];
        } else {
            [[NSNotificationCenter defaultCenter] postNotificationName:TQShareManagerDidSendToQQFailedNotification object:nil];
        }
    }
    
}

- (void)onReq:(id)req
{
    DLog(@"weixin/qq on request");
}

- (void)isOnlineResponse:(NSDictionary *)response
{
    DLog(@"is qq online on request --> %@", response);
}

@end

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

@implementation TQWeiboOAuth

+ (instancetype)sharedInstance
{
    static TQWeiboOAuth *sharedObj = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!sharedObj) {
            sharedObj = [[TQWeiboOAuth alloc] init];
        }
    });
    
    return sharedObj;
}

@end
