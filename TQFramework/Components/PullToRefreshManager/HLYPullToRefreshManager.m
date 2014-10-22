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

@property (nonatomic, weak) UITableView *tableView;

@end

@implementation HLYPullToRefreshManager

- (instancetype)initWithTableView:(UITableView *)tableView
{
    if (!tableView) {
        return nil;
    }
    
    if (self = [self init]) {
        _tableView = tableView;
        _tableView.delegate = self;
        
        _footerView = [[HLYPullToRefreshLoadingView alloc] initWithFrame:CGRectMake(0, [_tableView hly_height], CGRectGetWidth(tableView.frame), kHLYPullToRefreshHeaderHeight)];
        _footerView.type = HLYPullToRefreshTypeLoadMore;
        _footerView.backgroundColor = [UIColor clearColor];
        _footerView.clipsToBounds = NO;
        [_tableView addSubview:_footerView];
        
        _headerView = [[HLYPullToRefreshLoadingView alloc] initWithFrame:CGRectMake(0, -kHLYPullToRefreshHeaderHeight, CGRectGetWidth(tableView.frame), kHLYPullToRefreshHeaderHeight)];
        _headerView.type = HLYPullToRefreshTypeRefresh;
        _headerView.backgroundColor = [UIColor clearColor];
        _headerView.clipsToBounds = NO;
        [_tableView addSubview:_headerView];
        
        if (!_tableView.tableFooterView) {
            _tableView.tableFooterView = [[UIView alloc] init];
        }
        
        self.enableLoadNew = YES;
        self.enableLoadMore = YES;
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
        [self.tableView addSubview:_headerView];
        kHLYPullToRefreshHeaderHeight = [_headerView hly_height];
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
        [self.tableView addSubview:_footerView];
        kHLYPullToRefreshFooterHeight = [_footerView hly_height];
    }
}

#pragma mark -
#pragma mark - public
- (void)triggerLoadNew
{
    if (!self.tableView) {
        return;
    }
    
    self.headerView.state = HLYPullToRefreshStateNormal;
    
    __weak HLYPullToRefreshManager *safeSelf = self;
    [UIView animateWithDuration:0.25 animations:^{
        safeSelf.tableView.contentInset = UIEdgeInsetsMake(kHLYPullToRefreshHeaderHeight, 0, 0, 0);
        safeSelf.tableView.contentOffset = CGPointMake(0, -kHLYPullToRefreshHeaderHeight);
    } completion:^(BOOL finished) {
        if (finished) {
            safeSelf.headerView.state = HLYPullToRefreshStateLoading;
            if (safeSelf.loadNew) {
                safeSelf.loadNew();
            }
        }
    }];
}

- (void)endLoad
{
    if (!self.tableView) {
        return;
    }
    
    if (self.headerView.state == HLYPullToRefreshStateLoading) {
        self.headerView.state = HLYPullToRefreshStateNormal;
    }
    
    if (self.footerView.state == HLYPullToRefreshStateLoading) {
        self.footerView.state = HLYPullToRefreshStateNormal;
    }
    
    __weak HLYPullToRefreshManager *safeSelf = self;
    [UIView animateWithDuration:0.25 animations:^{
        safeSelf.tableView.contentInset = UIEdgeInsetsZero;
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

#pragma mark -
#pragma mark - table view
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.didSelectedTableViewAtIndexPath) {
        self.didSelectedTableViewAtIndexPath(tableView, indexPath);
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.cellHeightForTableViewAtIndexPath) {
        return self.cellHeightForTableViewAtIndexPath(tableView, indexPath);
    }
    
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.estimatedCellHeightForTableViewAtIndexPath) {
        return self.estimatedCellHeightForTableViewAtIndexPath(tableView, indexPath);
    }
    
    return 44;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (self.headerViewForTableViewInSection) {
        return self.headerViewForTableViewInSection(tableView, section);
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (self.headerViewHeightForTableViewInSection) {
        return self.headerViewHeightForTableViewInSection(tableView, section);
    }
    
    return 0;
}

#pragma mark -
#pragma mark - scroll view delegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    CGFloat footerTop = MAX([scrollView hly_height], scrollView.contentSize.height);
    if ([self.footerView hly_top] < footerTop) {
        [self.footerView hly_setTop:footerTop];
    }
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
    
    CGFloat footerTop = MAX([scrollView hly_height], scrollView.contentSize.height);

    CGFloat offsetY = scrollView.contentOffset.y;
    CGFloat topBaseLine = 0;
    CGFloat topMaxLine = -kHLYPullToRefreshHeaderHeight;
    CGFloat bottomBaseLine = footerTop - CGRectGetHeight(scrollView.frame);
    CGFloat bottomMaxLine = bottomBaseLine + kHLYPullToRefreshHeaderHeight;
    
    if (offsetY < topBaseLine && offsetY > topMaxLine) {
        self.headerView.state = HLYPullToRefreshStateNormal;
    } else if (offsetY < topMaxLine) {
        self.headerView.state = HLYPullToRefreshStatePulling;
    } else if (offsetY > bottomBaseLine && offsetY < bottomMaxLine) {
        self.footerView.state = HLYPullToRefreshStateNormal;
    } else if (offsetY > bottomMaxLine) {
        self.footerView.state = HLYPullToRefreshStatePulling;
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate) {
        return;
    }
    
    if (!self.headerView.isHidden && self.headerView.state == HLYPullToRefreshStatePulling) {
        self.headerView.state = HLYPullToRefreshStateLoading;
        if (self.tableView) {
            [UIView animateWithDuration:0.25 animations:^{
                self.tableView.contentInset = UIEdgeInsetsMake(kHLYPullToRefreshHeaderHeight, 0, 0, 0);
            }];
        }
        if (self.loadNew) {
            self.loadNew();
        }
    }
    
    if (!self.footerView.isHidden && self.footerView.state == HLYPullToRefreshStatePulling) {
        self.footerView.state = HLYPullToRefreshStateLoading;
        if (self.tableView) {
            [UIView animateWithDuration:0.25 animations:^{
                self.tableView.contentInset = UIEdgeInsetsMake(0, 0, kHLYPullToRefreshHeaderHeight, 0);
            }];
            
        }
        if (self.loadMore) {
            self.loadMore();
        }
    }
}

@end
