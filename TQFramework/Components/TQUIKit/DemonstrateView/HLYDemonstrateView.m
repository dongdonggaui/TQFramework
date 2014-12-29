//
//  HLYDemonstrateView.m
//  laohu-dota-assistant
//
//  Created by huangluyang on 14-7-31.
//  Copyright (c) 2014年 wanmei. All rights reserved.
//

#import "HLYDemonstrateView.h"
#import "HLYCycleScrollView.h"
#import "StyledPageControl.h"
#import "UIImageView+WebCache.h"

@interface HLYDemonstrateView ()

@property (nonatomic, strong) HLYCycleScrollView *scrollView;
@property (nonatomic, strong) StyledPageControl  *pageControl;

@property (nonatomic, assign) CGRect oldFrame;

@end

@implementation HLYDemonstrateView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame animationDuration:(NSTimeInterval)animationDuration
{
    if (self = [self initWithFrame:frame]) {
        
        // pageControl
        _pageControl = [[StyledPageControl alloc] initWithFrame:CGRectMake(0, 0, 70, 30)];
        [_pageControl setHidesForSinglePage:NO];
        [_pageControl setCoreNormalColor:[UIColor whiteColor]];
        [_pageControl setCoreSelectedColor:[UIColor yellowColor]];
        [_pageControl setGapWidth:6];
        [_pageControl setDiameter:10];
        [self addSubview:_pageControl];
        
        // placeholder : 1 page
        __weak HLYDemonstrateView *safeSelf = self;
        _scrollView = [[HLYCycleScrollView alloc] initWithFrame:CGRectZero animationDuration:animationDuration];
        _scrollView.fetchContentViewAtIndex = ^UIView * (NSInteger pageIndex) {
            
            safeSelf.pageControl.numberOfPages = 1;
            
            UIView *view = [[UIView alloc] initWithFrame:safeSelf.bounds];
            view.backgroundColor = [UIColor lightGrayColor];
            
            return view;
        };
        _scrollView.totalPagesCount = ^NSInteger(){
            
            return 1;
        };
        _scrollView.didEndScrolledBlock = ^(NSInteger pageIndex) {
            safeSelf.pageControl.currentPage = pageIndex;
        };
        [self insertSubview:_scrollView belowSubview:_pageControl];
        
        _scrollView.translatesAutoresizingMaskIntoConstraints = NO;
        _pageControl.translatesAutoresizingMaskIntoConstraints = NO;
        NSDictionary *viewsDic = @{@"scrollView": _scrollView,
                                   @"pageControl": _pageControl};
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[scrollView]-0-|" options:0 metrics:nil views:viewsDic]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[scrollView]-0-|" options:0 metrics:nil views:viewsDic]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[pageControl(>=50)]-20-|" options:0 metrics:nil views:viewsDic]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[pageControl(10)]-10-|" options:0 metrics:nil views:viewsDic]];
    }
    
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.oldFrame = self.frame;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (CGRectGetWidth(self.frame) != CGRectGetWidth(self.oldFrame)) {
        self.oldFrame = self.frame;
        [self invalidateIntrinsicContentSize];
    }
}

- (void)updateConstraints
{
    [super updateConstraints];
}

- (CGSize)intrinsicContentSize
{
    CGFloat width = CGRectGetWidth(self.frame);
    CGFloat height = width * 310 / 750.f;
    return CGSizeMake(width, height);
}

#pragma mark -
#pragma mark - public
- (void)setContentUrls:(NSArray *)contentUrls withTapActionBloack:(void (^)(NSInteger))tappedAtIndex
{
    if (!contentUrls || 0 == contentUrls.count) {
        return;
    }
    
    __weak HLYDemonstrateView *safeSelf = self;
    self.scrollView.fetchContentViewAtIndex = ^UIView * (NSInteger pageIndex) {
        
        safeSelf.pageControl.numberOfPages = contentUrls.count;
        
        NSString *path = [contentUrls objectAtIndex:pageIndex];
        CGRect frame=safeSelf.scrollView.bounds;
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds=YES;
        [imageView sd_setImageWithURL:[NSURL URLWithString:path] placeholderImage:[ThemeImage placeholderImage1]];
        
        return imageView;
    };
    
    self.scrollView.totalPagesCount = ^NSInteger () {
        return contentUrls.count;
    };
    
    self.scrollView.tapActionBlock = tappedAtIndex;
}

- (void)stopLoadWebImage
{
    for (UIView *subView in self.scrollView.subviews) {
        if ([subView isKindOfClass:[UIImageView class]]) {
            [(UIImageView *)subView sd_cancelCurrentImageLoad];
        }
    }
}

@end
