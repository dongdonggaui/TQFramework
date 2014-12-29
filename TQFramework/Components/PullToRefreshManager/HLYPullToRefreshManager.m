//
//  HLYPullToRefreshManager.m
//  HLYPullToRefreshManager
//
//  Created by huangluyang on 14-8-24.
//  Copyright (c) 2014年 huangluyang. All rights reserved.
//

#import "HLYPullToRefreshManager.h"

#import "UIView+Frame.h"

static CGFloat kHLYPullToRefreshHeaderHeight = 60;
static CGFloat kHLYPullToRefreshFooterHeight = 60;

@interface HLYPullToRefreshManager ()

@property (nonatomic, strong) UIScrollView *scrollView;

/**
 *  用来保存footerView的约束，方便remove
 */
@property (nonatomic, strong) NSArray *footerViewTopConstraints;

@end

@implementation HLYPullToRefreshManager

- (void)dealloc
{
    [_scrollView removeObserver:self forKeyPath:@"contentSize" context:(__bridge void *)self];
    _scrollView.delegate = nil;
    _scrollView = nil;
}

- (instancetype)initWithScrollView:(UIScrollView *)scrollView
{
    if (!scrollView) {
        return nil;
    }
    
    if (self = [self init]) {
        _scrollView = scrollView;
        _scrollView.delegate = self;
        
        _footerView = [[HLYPullToRefreshLoadingView alloc] initWithFrame:CGRectMake(0, [_scrollView hly_height], CGRectGetWidth(scrollView.frame), kHLYPullToRefreshHeaderHeight)];
        _footerView.type = HLYPullToRefreshTypeLoadMore;
        _footerView.backgroundColor = [UIColor clearColor];
        _footerView.clipsToBounds = NO;
        [_scrollView addSubview:_footerView];
        
        _headerView = [[HLYPullToRefreshLoadingView alloc] initWithFrame:CGRectMake(0, -kHLYPullToRefreshHeaderHeight, CGRectGetWidth(scrollView.frame), kHLYPullToRefreshHeaderHeight)];
        _headerView.type = HLYPullToRefreshTypeRefresh;
        _headerView.backgroundColor = [UIColor clearColor];
        _headerView.clipsToBounds = NO;
        [_scrollView addSubview:_headerView];
        
        self.enableLoadNew = YES;
        self.enableLoadMore = YES;
        self.viewTopLayoutGuide = 0;
        self.viewBottomLayoutGuide = 0;
        
        /**
         *  iOS8以前的autoLayout对UIscrollView的addSubView方式添加的且设置
         *  translatesAutoresizingMaskIntoConstraints为NO的子视图不兼容
         *  故需判断系统版本，iOS8及以上版本使用AutoLayout约束，iOS8以下的版本
         *  使用frame
         */
        if (![self ptrm_isBelowIOS8]) {
            // constraints
            _footerView.translatesAutoresizingMaskIntoConstraints = NO;
            _headerView.translatesAutoresizingMaskIntoConstraints = NO;
            NSDictionary *viewsDic = NSDictionaryOfVariableBindings(_footerView, _headerView, _scrollView);
            NSDictionary *metricsDic = @{@"headerHeight": @(kHLYPullToRefreshHeaderHeight),
                                         @"footerHeight": @(kHLYPullToRefreshFooterHeight)};
            
            [_scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_headerView(==_scrollView)]-0-|" options:0 metrics:nil views:viewsDic]];
            [_scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_headerView(==headerHeight)]-0-|" options:0 metrics:metricsDic views:viewsDic]];
            [_scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_footerView(==_scrollView)]-0-|" options:0 metrics:nil views:viewsDic]];
            [_scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_footerView(==footerHeight)]" options:0 metrics:metricsDic views:viewsDic]];
        }
        
        [_scrollView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:(__bridge void *)self];
    }
    
    return self;
}

#pragma mark -
#pragma mark - setters && getters
- (void)setEnableLoadNew:(BOOL)enableLoadNew
{
    _enableLoadNew = enableLoadNew;
    self.headerView.hidden = !enableLoadNew;
}

- (void)setEnableLoadMore:(BOOL)enableLoadMore
{
    _enableLoadMore = enableLoadMore;
    self.footerView.hidden = !enableLoadMore;
}

- (void)setHeaderBackgroundView:(UIView *)headerBackgroundView
{
    if (headerBackgroundView) {
        [self.headerView insertSubview:headerBackgroundView atIndex:0];
    }
}

- (void)setFooterBackgroundView:(UIView *)footerBackgroundView
{
    if (footerBackgroundView) {
        [self.footerView insertSubview:footerBackgroundView atIndex:0];
    }
}

- (void)setHeaderView:(HLYPullToRefreshLoadingView *)headerView
{
    if (!headerView) {
        return;
    }
    
    if (_headerView != headerView) {
        [_headerView removeFromSuperview];
        _headerView = headerView;
        [_headerView hly_setBottom:0];
        [self.scrollView addSubview:_headerView];
        kHLYPullToRefreshHeaderHeight = [_headerView hly_height];   // 强制更新视图高度
    }
}

- (void)setFooterView:(HLYPullToRefreshLoadingView *)footerView
{
    if (!footerView) {
        return;
    }
    
    if (_footerView != footerView) {
        [footerView hly_setTop:[_footerView hly_top]];
        [_footerView removeFromSuperview];
        _footerView = footerView;
        [self.scrollView addSubview:_footerView];
        kHLYPullToRefreshFooterHeight = [_footerView hly_height];
    }
}

#pragma mark -
#pragma mark - public
- (void)setTopLayoutGuide:(CGFloat)topLayoutGuide withViewController:(UIViewController *)viewController
{
    if ([self isTopLayoutGuideEnableWithViewController:viewController]) {
        self.viewTopLayoutGuide = topLayoutGuide;
    }
}

- (void)setBottomLayoutGuide:(CGFloat)bottomLayoutGuide withViewController:(UIViewController *)viewController
{
    if ([self isBottomLayoutGuideEnableWithViewController:viewController]) {
        self.viewBottomLayoutGuide = bottomLayoutGuide;
    }
}

- (void)triggerLoadNew
{
    if (!self.scrollView) {
        return;
    }
    
    self.headerView.state = HLYPullToRefreshStateLoading;
    
    __weak HLYPullToRefreshManager *safeSelf = self;
    UIEdgeInsets insets = self.scrollView.contentInset;
    insets.top = kHLYPullToRefreshHeaderHeight + self.viewTopLayoutGuide;
    CGPoint offset = self.scrollView.contentOffset;
    offset.y = -kHLYPullToRefreshHeaderHeight - self.viewTopLayoutGuide;
    
    [UIView animateWithDuration:0.25 animations:^{
        safeSelf.scrollView.contentInset = insets;
        safeSelf.scrollView.contentOffset = offset;
    } completion:^(BOOL finished) {
        if (finished) {
//            safeSelf.headerView.state = HLYPullToRefreshStateLoading;
            if (safeSelf.loadNew) {
                safeSelf.loadNew();
            }
        }
    }];
}

- (void)endLoad
{
    if (!self.scrollView) {
        return;
    }
    
    if (self.headerView.state == HLYPullToRefreshStateLoading) {
        self.headerView.state = HLYPullToRefreshStateNormal;
    }
    
    if (self.footerView.state == HLYPullToRefreshStateLoading) {
        self.footerView.state = HLYPullToRefreshStateNormal;
    }
    
    __weak HLYPullToRefreshManager *safeSelf = self;
    UIEdgeInsets insets = self.scrollView.contentInset;
    insets.top = self.viewTopLayoutGuide;
    insets.bottom = self.viewBottomLayoutGuide;
    [UIView animateWithDuration:0.25 animations:^{
        safeSelf.scrollView.contentInset = insets;
    }];
}

- (void)setHeaderUpdateTimeIdentifier:(NSString *)identifier
{
    self.headerView.updateTimeIdentifier = identifier;
}

- (void)setFooterUpdateTimeIdentifier:(NSString *)identifier
{
    self.footerView.updateTimeIdentifier = identifier;
}

- (void)updateLayoutGuidesWithViewController:(UIViewController *)viewController
{
    if ([self isTopLayoutGuideEnableWithViewController:viewController]) {
        self.viewTopLayoutGuide = [viewController.topLayoutGuide length];
    }
    
    if ([self isBottomLayoutGuideEnableWithViewController:viewController]) {
        self.viewBottomLayoutGuide = [viewController.bottomLayoutGuide length];
    }
}

- (void)updateRefreshViewState
{
    if (!self.scrollView) {
        return;
    }
    
    CGFloat footerTop = MAX([self.scrollView hly_height], self.scrollView.contentSize.height);
    
    CGFloat offsetY = self.scrollView.contentOffset.y;
    CGFloat topBaseLine = -self.viewTopLayoutGuide;
    CGFloat topMaxLine = -self.viewTopLayoutGuide - kHLYPullToRefreshHeaderHeight;
    CGFloat bottomBaseLine = self.viewBottomLayoutGuide + footerTop - CGRectGetHeight(self.scrollView.frame);
    CGFloat bottomMaxLine = bottomBaseLine + kHLYPullToRefreshHeaderHeight;
    
    if (offsetY < topBaseLine && offsetY > topMaxLine) {
        self.headerView.state = HLYPullToRefreshStateNormal;
    } else if (offsetY < topMaxLine) {
        self.headerView.state = HLYPullToRefreshStatePulling;
    } else if (offsetY > bottomBaseLine && offsetY < bottomMaxLine) {
        self.footerView.state = HLYPullToRefreshStateNormal;
    } else if (offsetY > bottomMaxLine) {
        self.footerView.state = HLYPullToRefreshStatePulling;
    } else {
        self.headerView.state = HLYPullToRefreshStateHide;
        self.footerView.state = HLYPullToRefreshStateHide;
    }
}

- (BOOL)ptrm_isBelowIOS8
{
    return [UIDevice currentDevice].systemVersion.floatValue < 8;
}

- (BOOL)isTopLayoutGuideEnableWithViewController:(UIViewController *)viewController
{
    return [viewController respondsToSelector:@selector(edgesForExtendedLayout)] &&
    (viewController.edgesForExtendedLayout == UIRectEdgeAll || viewController.edgesForExtendedLayout == UIRectEdgeTop);
}

- (BOOL)isBottomLayoutGuideEnableWithViewController:(UIViewController *)viewController
{
    return [viewController respondsToSelector:@selector(edgesForExtendedLayout)] &&
    (viewController.edgesForExtendedLayout == UIRectEdgeAll || viewController.edgesForExtendedLayout == UIRectEdgeBottom);
}

#pragma mark -
#pragma mark - kvo
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (context == (__bridge void *)self && object == self.scrollView) {
        // 设置kvo来观察table view 的 contentSize 以重新对 footerView 进行约束
        NSLog(@"change --> %@", change);
        CGSize newSize = [[change valueForKey:@"new"] CGSizeValue];
        CGSize oldSize = [[change valueForKey:@"old"] CGSizeValue];
        
        if (oldSize.height != newSize.height) {
            CGFloat bottom = MAX(newSize.height, self.scrollView.contentSize.height);
            NSDictionary *viewsDic = @{@"footerView": self.footerView};
            NSDictionary *metricDic = @{@"newFooterTop": @(bottom)};
            
            if (![self ptrm_isBelowIOS8]) {
                if (self.footerViewTopConstraints) {
                    [self.scrollView removeConstraints:self.footerViewTopConstraints];
                }
                self.footerViewTopConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(newFooterTop)-[footerView]" options:0 metrics:metricDic views:viewsDic];
                [self.scrollView addConstraints:self.footerViewTopConstraints];
                [self.scrollView setNeedsUpdateConstraints];
            } else {
                [self.headerView hly_setHeight:kHLYPullToRefreshHeaderHeight];
                [self.headerView hly_setWidth:[self.scrollView hly_width]];
                [self.footerView hly_setHeight:kHLYPullToRefreshFooterHeight];
                [self.footerView hly_setWidth:[self.scrollView hly_width]];
                [self.footerView hly_setTop:bottom];
            }
            
            UIEdgeInsets insets = self.scrollView.contentInset;
            if (self.headerView.state != HLYPullToRefreshStateLoading) {
                insets.top = self.viewTopLayoutGuide;
            }
            if (self.footerView.state != HLYPullToRefreshStateLoading) {
                insets.bottom = self.viewBottomLayoutGuide;
            }
            self.scrollView.contentInset = insets;
        }
    }
}

#pragma mark -
#pragma mark - scroll view delegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (self.loading) {
        return;
    }
    
    if (self.headerView.isHidden && self.footerView.isHidden) {
        return;
    }
    
    if (self.headerView.state == HLYPullToRefreshStateLoading || self.footerView.state == HLYPullToRefreshStateLoading) {
        return;
    }
    
    [self updateRefreshViewState];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate) {
        return;
    }
    
    if (!self.headerView.isHidden && self.headerView.state == HLYPullToRefreshStatePulling) {
        self.headerView.state = HLYPullToRefreshStateLoading;
        if (self.scrollView) {
            UIEdgeInsets insets = self.scrollView.contentInset;
            insets.top = kHLYPullToRefreshHeaderHeight + self.viewTopLayoutGuide;
            [UIView animateWithDuration:0.25 animations:^{
                self.scrollView.contentInset = insets;
            }];
        }
        if (self.loadNew) {
            self.loadNew();
        }
    }
    
    if (!self.footerView.isHidden && self.footerView.state == HLYPullToRefreshStatePulling) {
        self.footerView.state = HLYPullToRefreshStateLoading;
        if (self.scrollView) {
            UIEdgeInsets insets = self.scrollView.contentInset;
            insets.bottom = kHLYPullToRefreshHeaderHeight + self.viewBottomLayoutGuide;
            [UIView animateWithDuration:0.25 animations:^{
                self.scrollView.contentInset = insets;
            }];
            
        }
        if (self.loadMore) {
            self.loadMore();
        }
    }
}

@end
