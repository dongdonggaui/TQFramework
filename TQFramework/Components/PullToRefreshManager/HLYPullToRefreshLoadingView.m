//
//  HLYPullToRefreshLoadingView.m
//  HLYPullToRefreshManager
//
//  Created by huangluyang on 14-8-24.
//  Copyright (c) 2014年 huangluyang. All rights reserved.
//

#import "HLYPullToRefreshLoadingView.h"
#import "HLYDateFormatManager.h"

#import "UIView+Frame.h"

static NSString * const HLYPullToRefreshUpdateTimeUserDefaultsKey = @"com.hly.userdefaultskey.pulltorefresh";

@interface HLYPullToRefreshLoadingView ()

@property (nonatomic, strong) UIView *loadingContentView;

//
@property (nonatomic, strong) NSString *normalLoadNewStatus;
@property (nonatomic, strong) NSString *pullingLoadNewStatus;
@property (nonatomic, strong) NSString *loadingLoadNewStatus;

@property (nonatomic, strong) NSString *normalLoadMoreStatus;
@property (nonatomic, strong) NSString *pullingLoadMoreStatus;
@property (nonatomic, strong) NSString *loadingLoadMoreStatus;

@end

@implementation HLYPullToRefreshLoadingView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame contentView:(UIView *)contentView
{
    if (self = [self initWithFrame:frame]) {
        self.loadingContentView = contentView;
    }
    
    return self;
}

#pragma mark -
#pragma mark - setters && getters
- (void)setState:(HLYPullToRefreshState)state
{
    [self updateWithType:self.type state:state];
    _state = state;
    
    [self setNeedsLayout];
}

- (NSString *)normalLoadNewStatus
{
    if (!_normalLoadNewStatus) {
        _normalLoadNewStatus = NSLocalizedStringFromTableInBundle(@"msg_pulltorefresh", @"HLYPullToRefreshManager", [self hly_bundle], nil);
    }
    
    return _normalLoadNewStatus;
}

- (NSString *)pullingLoadNewStatus
{
    if (!_pullingLoadNewStatus) {
        _pullingLoadNewStatus = NSLocalizedStringFromTableInBundle(@"msg_releasetorefresh", @"HLYPullToRefreshManager", [self hly_bundle], nil);
    }
    
    return _pullingLoadNewStatus;
}

- (NSString *)loadingLoadNewStatus
{
    if (!_loadingLoadNewStatus) {
        _loadingLoadNewStatus = NSLocalizedStringFromTableInBundle(@"msg_loading", @"HLYPullToRefreshManager", [self hly_bundle], nil);
    }
    
    return _loadingLoadNewStatus;
}

- (NSString *)normalLoadMoreStatus
{
    if (!_normalLoadMoreStatus) {
        _normalLoadMoreStatus = NSLocalizedStringFromTableInBundle(@"msg_pulltoloadmore", @"HLYPullToRefreshManager", [self hly_bundle], nil);
    }
    
    return _normalLoadMoreStatus;
}

- (NSString *)pullingLoadMoreStatus
{
    if (!_pullingLoadMoreStatus) {
        _pullingLoadMoreStatus = NSLocalizedStringFromTableInBundle(@"msg_releasetoloadmore", @"HLYPullToRefreshManager", [self hly_bundle], nil);
    }
    
    return _pullingLoadMoreStatus;
}

- (NSString *)loadingLoadMoreStatus
{
    if (!_loadingLoadMoreStatus) {
        _loadingLoadMoreStatus = NSLocalizedStringFromTableInBundle(@"msg_loading", @"HLYPullToRefreshManager", [self hly_bundle], nil);
    }
    
    return _loadingLoadMoreStatus;
}

#pragma mark -
#pragma mark - public
- (void)setStatusMessage:(NSString *)message forState:(HLYPullToRefreshState)state;
{
    switch (state) {
        case HLYPullToRefreshStateNormal:
            if (self.type == HLYPullToRefreshTypeRefresh) {
                self.normalLoadNewStatus = message;
            } else {
                self.normalLoadMoreStatus = message;
            }
            break;
            
        case HLYPullToRefreshStatePulling:
            if (self.type == HLYPullToRefreshTypeRefresh) {
                self.pullingLoadNewStatus = message;
            } else {
                self.pullingLoadMoreStatus = message;
            }
            break;
            
        case HLYPullToRefreshStateLoading:
            if (self.type == HLYPullToRefreshTypeRefresh) {
                self.loadingLoadNewStatus = message;
            } else {
                self.loadingLoadMoreStatus = message;
            }
            break;
            
        default:
            break;
    }
}

- (NSString *)statusMessageForState:(HLYPullToRefreshState)state
{
    NSString *status = nil;
    switch (state) {
        case HLYPullToRefreshStateNormal:
            if (self.type == HLYPullToRefreshTypeRefresh) {
                status = self.normalLoadNewStatus;
            } else {
                status = self.normalLoadMoreStatus;
            }
            break;
            
        case HLYPullToRefreshStatePulling:
            if (self.type == HLYPullToRefreshTypeRefresh) {
                status = self.pullingLoadNewStatus;
            } else {
                status = self.pullingLoadMoreStatus;
            }
            break;
            
        case HLYPullToRefreshStateLoading:
            if (self.type == HLYPullToRefreshTypeRefresh) {
                status = self.loadingLoadNewStatus;
            } else {
                status = self.loadingLoadMoreStatus;
            }
            break;
            
        default:
            break;
    }
    
    return status;
}

- (void)updateWithType:(HLYPullToRefreshType)type state:(HLYPullToRefreshState)state
{
    
}

- (void)updateWithProgress:(CGFloat)progress
{
    
}

- (NSString *)lastUpdateTime
{
    if (!self.updateTimeIdentifier) {
        return nil;
    }
    
    NSDictionary *updateInfo = [[NSUserDefaults standardUserDefaults] objectForKey:HLYPullToRefreshUpdateTimeUserDefaultsKey];
    
    if (updateInfo && [updateInfo objectForKey:self.updateTimeIdentifier]) {
        NSDate *updateTime = [updateInfo objectForKey:self.updateTimeIdentifier];
        return [[HLYDateFormatManager sharedInstance] lapseTimeFormatFromDate:updateTime];
    }
    
    return nil;
}

#pragma mark -
#pragma mark - private
- (void)updateRefreshTime
{
    if (!self.updateTimeIdentifier) {
        return;
    }
    
    NSDictionary *updateInfo = [[NSUserDefaults standardUserDefaults] objectForKey:HLYPullToRefreshUpdateTimeUserDefaultsKey];
    NSMutableDictionary *temp = nil;
    if (updateInfo) {
        temp = [NSMutableDictionary dictionaryWithDictionary:updateInfo];
    } else {
        temp = [NSMutableDictionary dictionary];
    }
    
    NSDate *now = [NSDate date];
    
    [temp setObject:now forKey:self.updateTimeIdentifier];
    
    if (temp) {
        [[NSUserDefaults standardUserDefaults] setObject:temp forKey:HLYPullToRefreshUpdateTimeUserDefaultsKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (NSBundle *)hly_bundle
{
    NSString *bundlePath = [[NSBundle mainBundle] pathForResource:@"HLYPullToRefreshManager" ofType:@"bundle"];
    NSBundle *bundle = [NSBundle bundleWithPath:bundlePath];
    
    return bundle;
}

- (BOOL)ptr_isBelowIOS8
{
    return [UIDevice currentDevice].systemVersion.floatValue < 8;
}

@end
