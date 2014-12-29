//
//  TQGridView.m
//  Hiweido
//
//  Created by huangluyang on 14/11/16.
//  Copyright (c) 2014年 huangluyang. All rights reserved.
//

#import "TQGridView.h"
#import "UIView+Frame.h"

@interface TQGridView ()

// auto layout需要，用来检测view的尺寸是否发生变化
@property (nonatomic, unsafe_unretained) CGRect oldFrame;

@end

@implementation TQGridView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _oldFrame = self.frame;
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.oldFrame = self.frame;
}

// 即content size
- (CGSize)intrinsicContentSize
{
    CGFloat maxWidth = 0;
    CGFloat maxHeight = 0;
    for (UIView *subView in self.subviews) {
        maxWidth = MAX(maxWidth, [subView hly_right]);
        maxHeight = MAX(maxHeight, [subView hly_bottom]);
    }
    
    CGSize size = CGSizeMake(maxWidth, maxHeight);
    
    return size;
}

- (void)updateConstraints
{
    [super updateConstraints];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat itemSpace = self.itemSpace;
    CGFloat rowSpace = self.rowSpace;
    CGFloat itemWidth = ceilf(([self hly_width] - itemSpace * (self.maxItemsPerLine - 1)) / self.maxItemsPerLine);
    CGFloat itemHeight = self.fixedWidth ? self.itemHeight : itemWidth * self.itemHeightWidthRate;
    CGFloat imageContentViewHeight = 0;
    
    for (int i = 0; i < self.gridCotentViews.count; i++) {
        TQGridViewContentView *contentView = (TQGridViewContentView *)[self viewWithTag:100 + i];
        if (!contentView || ![contentView isKindOfClass:[TQGridViewContentView class]]) {
            break;
        }
        [contentView hly_setWidth:itemWidth];
        [contentView hly_setHeight:itemHeight];
        [contentView hly_setLeft:(i % self.maxItemsPerLine) * (itemWidth + itemSpace)];
        [contentView hly_setTop:(i / self.maxItemsPerLine) * (itemHeight + rowSpace)];
        
        imageContentViewHeight = [contentView hly_bottom];
    }
    [self hly_setHeight:imageContentViewHeight];
    
    if (self.oldFrame.size.width != self.frame.size.width ||
        self.oldFrame.size.height != self.frame.size.height) {
        // 发送Auto Layout通知
        [self invalidateIntrinsicContentSize];
        
        self.oldFrame = self.frame;
    }
}

#pragma mark -
#pragma mark - setters & getters
- (void)setGridCotentViews:(NSArray *)gridCotentViews
{
    if (_gridCotentViews != gridCotentViews) {
        
        [_gridCotentViews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        
        for (int i = 0; i < gridCotentViews.count; i++) {
            TQGridViewContentView *contentView = [gridCotentViews objectAtIndex:i];
            contentView.userInteractionEnabled = YES;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ic_imageDidTapped:)];
            [contentView addGestureRecognizer:tap];
            contentView.tag = 100 + i;
            [self addSubview:contentView];
        }
        _gridCotentViews = gridCotentViews;
    }
    
    [self setNeedsLayout];
}

- (NSInteger)maxItemsPerLine
{
    if (_maxItemsPerLine == 0) {
        _maxItemsPerLine = 3;
    }
    
    return _maxItemsPerLine;
}

- (CGFloat)itemSpace
{
    if (_itemSpace == 0) {
        _itemSpace = 3;
    }
    
    return _itemSpace;
}

- (CGFloat)itemHeightWidthRate
{
    if (_itemHeightWidthRate == 0) {
        _itemHeightWidthRate = 1;
    }
    
    return _itemHeightWidthRate;
}

- (CGFloat)rowSpace
{
    if (_rowSpace == 0) {
        _rowSpace = 3;
    }
    
    return _rowSpace;
}

- (CGFloat)itemHeight
{
    if (_itemHeight == 0) {
        _itemHeight = 44;
    }
    
    return _itemHeight;
}

#pragma mark -
#pragma mark - public
- (void)prepareForReuse
{
    [self.gridCotentViews makeObjectsPerformSelector:@selector(prepareForResuse)];
    self.gridCotentViews = nil;
}

#pragma mark -
#pragma mark - private
- (void)ic_imageDidTapped:(UITapGestureRecognizer *)tap
{
    TQGridViewContentView *contentView = (TQGridViewContentView *)tap.view;
    if (!contentView || ![contentView isKindOfClass:[TQGridViewContentView class]]) {
        return;
    }
    
    if (self.tappedAtIndex) {
        self.tappedAtIndex(self, contentView.tag - 100);
    }
}

@end


//////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////

@implementation TQGridViewContentView

- (void)prepareForResuse
{
    
}

@end