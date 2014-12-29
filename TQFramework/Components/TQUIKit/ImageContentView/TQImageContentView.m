//
//  TQImageContentView.m
//  Hiweido
//
//  Created by huangluyang on 14-9-11.
//  Copyright (c) 2014年 huangluyang. All rights reserved.
//

#import "TQImageContentView.h"
#import "UIView+Frame.h"
#import <UIImageView+WebCache.h>
#import <UIImage+ImageWithColor.h>

@interface TQImageContentView ()

@property (nonatomic, strong) NSMutableArray *imageViews;

@property (nonatomic, unsafe_unretained) CGRect oldFrame;

@end

@implementation TQImageContentView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
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
    
    CGFloat imageSpace = self.itemHorizontalSpace;
    CGFloat imageWidth = ceilf(([self hly_width] - imageSpace * (self.maxItemsPerLine - 1)) / self.maxItemsPerLine);
    CGFloat imageHeigth = (self.contentType == TQImageContentTitleBottomImage)?imageWidth+25 : imageWidth;
    CGFloat imageContentViewHeight = 0;
    for (int i = 0; i < self.imagePaths.count; i++) {
        TQImageItemView *imageView = (TQImageItemView *)[self viewWithTag:100 + i];
        if (!imageView || ![imageView isKindOfClass:[TQImageItemView class]]) {
            break;
        }
        [imageView hly_setWidth:imageWidth];
        [imageView hly_setHeight:imageHeigth];
        [imageView hly_setLeft:(i % self.maxItemsPerLine) * (imageWidth + imageSpace)];
        [imageView hly_setTop:(i / self.maxItemsPerLine) * (imageHeigth + self.itemVerticalSpace)];
        
        imageContentViewHeight = [imageView hly_bottom];
    }
    [self hly_setHeight:imageContentViewHeight];
    
    if (self.oldFrame.size.width != self.frame.size.width ||
        self.oldFrame.size.height != self.frame.size.height) {
        // 发送Auto Layout通知
        [self invalidateIntrinsicContentSize];
        
        self.oldFrame = self.frame;
    }
}

-(void)updateConstraintsWithImages:(NSArray *)imagePaths titleArrays:(NSArray *)imageTitles
{
    if (_imagePaths != imagePaths) {
        _imagePaths = imagePaths;
        
        [self.imageViews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [self.imageViews removeAllObjects];
        
        for (int i = 0; i < imagePaths.count; i++) {
            NSString *path = [imagePaths objectAtIndex:i];
            TQImageItemView *tqImageView = [[TQImageItemView alloc] initWithFrame:CGRectZero contentType:self.contentType];
            tqImageView.userInteractionEnabled = YES;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ic_imageDidTapped:)];
            [tqImageView addGestureRecognizer:tap];
            [tqImageView.imageView sd_setImageWithURL:[NSURL URLWithString:path] placeholderImage:[ThemeImage placeholderImage1]];
            tqImageView.tag = 100 + i;
            
            if (self.contentType != TQImageContentOnlyImage && i < imageTitles.count) {
                tqImageView.titleLabel.text = [imageTitles objectAtIndex:i];
                tqImageView.titleLabel.font = [UIFont systemFontOfSize:9.f];
                tqImageView.titleLabel.textColor = self.titleColor;
                tqImageView.titleLabel.textAlignment = NSTextAlignmentCenter;
//                tqImageView.titleLabel.adjustsFontSizeToFitWidth = YES;
                tqImageView.titleLabel.backgroundColor = self.titlebackgroundColor;
            }
            [self addSubview:tqImageView];
            [self.imageViews addObject:tqImageView];
        }
        
        [self setNeedsLayout];
    }
}

// 在awakeFromNib中设置会覆盖掉在awakeFromNib之前设置的值
- (NSInteger)maxItemsPerLine
{
    if (_maxItemsPerLine == 0) {
        _maxItemsPerLine = 3;
    }
    
    return _maxItemsPerLine;
}

// 在awakeFromNib中设置会覆盖掉在awakeFromNib之前设置的值
- (CGFloat)itemHorizontalSpace
{
    if (_itemHorizontalSpace == 0) {
        _itemHorizontalSpace = 3;
    }
    
    return _itemHorizontalSpace;
}

- (CGFloat)itemVerticalSpace
{
    if (_itemVerticalSpace == 0) {
        _itemVerticalSpace = self.itemHorizontalSpace;
    }
    
    return _itemVerticalSpace;
}
- (NSMutableArray *)imageViews
{
    if (!_imageViews) {
        _imageViews = [NSMutableArray array];
    }
    
    return _imageViews;
}

-(UIColor *)titleColor
{
    if (!_titleColor) {
        _titleColor = [UIColor whiteColor];
    }
    
    return _titleColor;
}

-(UIColor *)titlebackgroundColor
{
    if (!_titlebackgroundColor) {
        _titlebackgroundColor = [UIColor clearColor];
    }
    
    return _titlebackgroundColor;
}

#pragma mark -
#pragma mark - public
- (void)prepareForReuse
{
    [self.imageViews makeObjectsPerformSelector:@selector(cancelCurrentImageLoad)];
    self.imagePaths = nil;
    for (TQImageItemView *imageView in self.imageViews) {
        imageView.imageView.image = nil;
        [imageView removeFromSuperview];
    }
}

#pragma mark -
#pragma mark - private
- (void)ic_imageDidTapped:(UITapGestureRecognizer *)tap
{
    TQImageItemView *imageView = (TQImageItemView *)tap.view;
    if (!imageView || ![imageView isKindOfClass:[TQImageItemView class]]) {
        return;
    }
    
    if (self.tappedAtIndex) {
        self.tappedAtIndex(imageView.tag - 100);
    }
}

@end
