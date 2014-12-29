//
//  HLYScrollContainerView.m
//  laohu
//
//  Created by huangluyang on 14-7-28.
//  Copyright (c) 2014年 wanmei. All rights reserved.
//

#import "HLYScrollContainerView.h"
#import "UIView+Frame.h"

@interface HLYScrollContainerView () <UIScrollViewDelegate>

@property (nonatomic, strong) HLYScrollTabbar *scrollTabbar;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSLayoutConstraint *scrollContentWidthContraint;

@end

@implementation HLYScrollContainerView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.clipsToBounds = YES;
        
//        _contentViewDic = [NSMutableDictionary dictionary];
        
        _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        _scrollView.backgroundColor = [UIColor clearColor];
        _scrollView.delegate = self;
        _scrollView.pagingEnabled = YES;
        _scrollView.showsHorizontalScrollIndicator = NO;
        [self addSubview:_scrollView];
        
        NSDictionary *viewsDic = @{@"scrollView": _scrollView};
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[scrollView]-0-|" options:0 metrics:nil views:viewsDic]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[scrollView]-0-|" options:0 metrics:nil views:viewsDic]];
    }
    return self;
}

- (instancetype)initWithTabbar:(HLYScrollTabbar *)tabbar position:(HLYScrollTabbarPosition)position tabbarHeight:(CGFloat)tabbarHeight
{
    if (!tabbar) {
        return [self initWithFrame:CGRectZero];
    }
    
    if (self = [super initWithFrame:CGRectZero]) {
        self.clipsToBounds = YES;
        
//        _contentViewDic = [NSMutableDictionary dictionary];
        
        _scrollTabbar = tabbar;
        _scrollTabbar.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:_scrollTabbar];
        
        _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        _scrollView.translatesAutoresizingMaskIntoConstraints = NO;
        _scrollView.backgroundColor = [UIColor clearColor];
        _scrollView.delegate = self;
        _scrollView.pagingEnabled = YES;
        _scrollView.showsHorizontalScrollIndicator = NO;
        [self addSubview:_scrollView];
        
        NSDictionary *viewsDic = @{@"scrollView": _scrollView,
                                   @"tabbar": _scrollTabbar};
        NSDictionary *metricsDic = @{@"tabbarHeight": @(tabbarHeight)};
        NSString *tabbarVerticalConstraintsString = position == HLYScrollTabbarPositionTop ? @"V:|-0-[tabbar(==tabbarHeight)]-0-[scrollView]-0-|" : @"V:|-0-[scrollView]-0-[tabbar(==tabbarHeight)]-0-|";
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[tabbar]-0-|" options:0 metrics:nil views:viewsDic]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[scrollView]-0-|" options:0 metrics:nil views:viewsDic]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:tabbarVerticalConstraintsString options:0 metrics:metricsDic views:viewsDic]];
    }
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.scrollView.contentSize = CGSizeMake(self.totalContentViewCount * self.scrollView.width, self.scrollView.contentSize.height);
}

#pragma mark -
#pragma mark - setters & getters
- (void)setTotalContentViewCount:(NSInteger)totalContentViewCount
{
    _totalContentViewCount = totalContentViewCount;
    
    self.scrollView.contentSize = CGSizeMake(totalContentViewCount * self.scrollView.width, self.scrollView.contentSize.height);
}

#pragma mark -
#pragma mark - public
- (void)addContentView:(UIView *)contentView atIndex:(NSInteger)index
{
    if (!contentView) {
        return;
    }
//    [self.contentViewDic setObject:contentView forKey:@(index)];
    [self.scrollView addSubview:contentView];
    [contentView hly_setWidth:[self.scrollView hly_width]];
    [contentView hly_setHeight:[self.scrollView hly_height]];
    [contentView hly_setLeft:index * [self.scrollView hly_width]];
}

- (void)setContentIndex:(NSInteger)index animated:(BOOL)animated
{
    [self.scrollView setContentOffset:CGPointMake(index * self.scrollView.width, 0) animated:animated];
}

#pragma mark -
#pragma mark - scroll view delegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger index = scrollView.contentOffset.x / scrollView.width;
    if (self.didEndDeceleratingWithIndex) {
        self.didEndDeceleratingWithIndex(self, index);
    }
}


@end
