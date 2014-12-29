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

@property (nonatomic, strong) UILabel *stateLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) CALayer *animateImageLayer;   // 必须用CALayer，若用UIImageView则在用CATransation旋转的时候无动画效果

@property (nonatomic, strong) UIActivityIndicatorView *juhua;

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
        _stateLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _stateLabel.backgroundColor = [UIColor clearColor];
        _stateLabel.font = [UIFont systemFontOfSize:14];
        [self addSubview:_stateLabel];
        
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _timeLabel.backgroundColor = [UIColor clearColor];
        _timeLabel.font = [UIFont systemFontOfSize:12];
        _timeLabel.textColor = [UIColor darkGrayColor];
        [self addSubview:_timeLabel];
        
        NSString *bundlePath = [[NSBundle mainBundle] pathForResource:@"HLYPullToRefreshManager" ofType:@"bundle"];
        bundlePath = [bundlePath stringByAppendingPathComponent:@"images"];
        NSString *downArrowImagePath = [bundlePath stringByAppendingPathComponent:@"blueArrow.png"];
        UIImage *image = [UIImage imageWithContentsOfFile:downArrowImagePath];
        _animateImageLayer = [[CALayer alloc] init];
        _animateImageLayer.frame = CGRectMake(0, 0, image.size.width, image.size.height);
        _animateImageLayer.contents = (id)image.CGImage;
        UIView *animateImageLayerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, image.size.width + 10, image.size.height + 10)];
        [animateImageLayerView.layer addSublayer:_animateImageLayer];
        [self addSubview:animateImageLayerView];
        
        _juhua = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [self addSubview:_juhua];
        
        /**
         *  iOS8以前的autoLayout对UITableView的addSubView方式添加的且设置
         *  translatesAutoresizingMaskIntoConstraints为NO的子视图不兼容
         *  故需判断系统版本，iOS8及以上版本使用AutoLayout约束，iOS8以下的版本
         *  使用frame
         */
        if (![self ptr_isBelowIOS8]) {
            // constraints
//            self.translatesAutoresizingMaskIntoConstraints = NO;
//            _stateLabel.translatesAutoresizingMaskIntoConstraints = NO;
//            _timeLabel.translatesAutoresizingMaskIntoConstraints = NO;
//            animateImageLayerView.translatesAutoresizingMaskIntoConstraints = NO;
//            _juhua.translatesAutoresizingMaskIntoConstraints = NO;
//            
//            NSDictionary *viewsDic = NSDictionaryOfVariableBindings(_stateLabel, _timeLabel, animateImageLayerView);
//            
//            [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-12-[_stateLabel]-10-[_timeLabel]" options:0 metrics:nil views:viewsDic]];
//            [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-30-[animateImageLayerView(==imageWidth)]" options:0 metrics:@{@"imageWidth":@(image.size.width)} views:viewsDic]];
//            [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[animateImageLayerView(==imageHeight)]" options:0 metrics:@{@"imageHeight":@(image.size.height)} views:viewsDic]];
//            [self addConstraint:[NSLayoutConstraint constraintWithItem:animateImageLayerView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
//            [self addConstraint:[NSLayoutConstraint constraintWithItem:self.juhua attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
//            [self addConstraint:[NSLayoutConstraint constraintWithItem:self.juhua attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:animateImageLayerView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
//            [self addConstraint:[NSLayoutConstraint constraintWithItem:_stateLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
        }
    }
    return self;
}

- (void)didMoveToSuperview
{
    [super didMoveToSuperview];
    
    [self loadUpdateTime];
}

- (void)updateConstraints
{
    [super updateConstraints];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.stateLabel sizeToFit];
    
    [self.timeLabel sizeToFit];
    
//    if ([self ptr_isBelowIOS8]) {
        [self.stateLabel hly_setCenterX:ceilf([UIScreen mainScreen].bounds.size.width * 0.5)];
        [self.stateLabel hly_setTop:12];
        
        [self.timeLabel hly_setCenterX:[self.stateLabel hly_centerX]];
        [self.timeLabel hly_setTop:[self.stateLabel hly_bottom] + 10];
        
        CGRect frame = self.animateImageLayer.frame;
        frame.origin.x = 30;
        frame.origin.y = ceilf(([self hly_height] - CGRectGetHeight(self.animateImageLayer.frame)) / 2);
        self.animateImageLayer.frame = frame;
        
        CGRect juhuaFrame = self.juhua.frame;
        juhuaFrame.origin.x = frame.origin.x + ceilf((frame.size.width - self.juhua.frame.size.width) / 2);
        juhuaFrame.origin.y = frame.origin.y + ceilf((frame.size.height - self.juhua.frame.size.height) / 2);
        self.juhua.frame = juhuaFrame;
//    }
}

#pragma mark -
#pragma mark - setters && getters
- (void)setType:(HLYPullToRefreshType)type
{
    switch (type) {
        case HLYPullToRefreshTypeRefresh:
            
            break;
            
        case HLYPullToRefreshTypeLoadMore:
            
            break;
            
        default:
            break;
    }
    
    _type = type;
}

- (void)setState:(HLYPullToRefreshState)state
{
    switch (state) {
            
        case HLYPullToRefreshStateNormal: {
            
            self.stateLabel.hidden = NO;
            self.animateImageLayer.hidden = NO;
            self.timeLabel.hidden = NO;
            
            [self loadUpdateTime];
            
            if (_state == HLYPullToRefreshStateLoading) {
                
                [self updateRefreshTime];
                
            } else if (_state == HLYPullToRefreshStatePulling) {
                [CATransaction begin];
                [CATransaction setAnimationDuration:0.18];
                self.animateImageLayer.transform = CATransform3DIdentity;
                [CATransaction commit];
                
            }
            
            self.stateLabel.text = self.type == HLYPullToRefreshTypeRefresh ? self.normalLoadNewStatus : self.normalLoadMoreStatus;
            
            [self.juhua stopAnimating];
            [CATransaction begin];
            [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
            self.animateImageLayer.hidden = NO;
            self.animateImageLayer.transform = CATransform3DIdentity;
            [CATransaction commit];
            
            break;
        }
            
        case HLYPullToRefreshStatePulling:
            
            self.stateLabel.hidden = NO;
            self.animateImageLayer.hidden = NO;
            self.timeLabel.hidden = NO;
            
            self.stateLabel.text = self.type == HLYPullToRefreshTypeRefresh ? self.pullingLoadNewStatus : self.pullingLoadMoreStatus;
            [CATransaction begin];
            [CATransaction setAnimationDuration:0.18];
            self.animateImageLayer.transform = CATransform3DMakeRotation((M_PI / 180.0) * 180.0f, 0.0f, 0.0f, 1.0f);
            [CATransaction commit];
            
            break;
            
        case HLYPullToRefreshStateLoading:
            
            self.stateLabel.hidden = NO;
            self.timeLabel.hidden = NO;
            
            self.stateLabel.text = self.type == HLYPullToRefreshTypeRefresh ? self.loadingLoadNewStatus : self.loadingLoadMoreStatus;
            [self.juhua startAnimating];
            self.animateImageLayer.hidden = YES;
            
            break;
            
        case HLYPullToRefreshStateHide:
        default:
            self.stateLabel.hidden = YES;
            [self.juhua stopAnimating];
            self.animateImageLayer.hidden = YES;
            self.timeLabel.hidden = YES;
            
            break;
    }
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

#pragma mark -
#pragma mark - private
- (void)loadUpdateTime
{
    if (!self.updateTimeIdentifier) {
        return;
    }
    
    NSDictionary *updateInfo = [[NSUserDefaults standardUserDefaults] objectForKey:HLYPullToRefreshUpdateTimeUserDefaultsKey];
    
    if (updateInfo && [updateInfo objectForKey:self.updateTimeIdentifier]) {
        NSDate *updateTime = [updateInfo objectForKey:self.updateTimeIdentifier];
        self.timeLabel.text = [[HLYDateFormatManager sharedInstance] lapseTimeFormatFromDate:updateTime];
    }
}

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
    self.timeLabel.text = [[HLYDateFormatManager sharedInstance] lapseTimeFormatFromDate:now];
    
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
