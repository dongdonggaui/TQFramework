//
//  HLYGridView.m
//  laohu-dota-assistant
//
//  Created by huangluyang on 14-7-31.
//  Copyright (c) 2014年 wanmei. All rights reserved.
//

#import "HLYGridView.h"
#import "UIView+Frame.h"

@interface HLYGridView ()

@property (nonatomic, unsafe_unretained) CGFloat topPadding;
@property (nonatomic, unsafe_unretained) CGFloat leftPadding;
@property (nonatomic, unsafe_unretained) CGFloat bottomPadding;
@property (nonatomic, unsafe_unretained) CGFloat rightPadding;

@property (nonatomic, unsafe_unretained) CGFloat oldHeight;

@end

@implementation HLYGridView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.columnCount = 1;
    }
    return self;
}

- (CGSize)intrinsicContentSize
{
    CGFloat width = 0;
    CGFloat height = 0;
    for (UIView *subView in self.subviews) {
        width = MAX(width, [subView hly_right]);
        height = MAX(height, [subView hly_bottom]);
    }
    
    NSLog(@"intrinsic content size --> %@", NSStringFromCGSize(CGSizeMake(width, height)));
    
    return CGSizeMake(width, height);
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat currentTop = 0;
    
    if (!self.items) {
        return;
    }
    
    CGFloat unitWidth = ceilf(([self hly_width] - self.leftPadding - self.rightPadding) / self.columnCount);
    CGFloat bottom = 0;
    for (int i = 0; i < self.items.count; i++) {
        HLYGridViewItem *item = [self.items objectAtIndex:i];
        if (![item isKindOfClass:[HLYGridViewItem class]]) {
            return;
        }
        
        [item hly_setLeft:(i % self.columnCount) * unitWidth + self.leftPadding];
        [item hly_setTop:(i / self.columnCount) * self.rowHeight + currentTop];
        [item hly_setWidth:unitWidth];
        [item hly_setHeight:self.rowHeight];
        
        bottom = [item hly_bottom];
    }
    
    [self hly_setHeight:bottom];
    
    if ([self hly_height] != self.oldHeight) {
        [self invalidateIntrinsicContentSize];
        self.oldHeight = [self hly_height];
    }
    
    NSLog(@"layout subviews --> %@", self);
}

- (void)updateConstraints
{
    [super updateConstraints];
    
    NSLog(@"update constraints --> %@", self);
}

#pragma mark -
#pragma mark - setters & getters
- (void)setItems:(NSArray *)items
{
    _items = items;
    
    for (UIView *subView in self.subviews) {
        if (subView.tag >= 100) {
            [subView removeFromSuperview];
        }
    }
    
    if (items) {
        for (int i = 0; i < items.count; i++) {
            HLYGridViewItem *item = [items objectAtIndex:i];
            if (![item isKindOfClass:[HLYGridViewItem class]]) {
                return;
            }
            item.backgroundColor = [UIColor yellowColor];
            item.tag = 100 + i;
            
            [self addSubview:item];
        }
    }
}

@end

@interface HLYGridViewItem ()

@property (nonatomic, strong) UIView *contentView;

@end

@implementation HLYGridViewItem

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        _contentView = [[UIView alloc] initWithFrame:self.bounds];
        _contentView.backgroundColor = [UIColor clearColor];
        [self addSubview:_contentView];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.contentView.frame = self.bounds;
}

@end


@interface GridViewSimpleItem ()

@property (nonatomic, strong) UIButton    *iconButton;
@property (nonatomic, strong) UILabel     *titleLabel;
@property (nonatomic, strong) UIImageView *badgeView;
@property (nonatomic, copy) void (^tappedAction)(GridViewSimpleItem *item);

@end

@implementation GridViewSimpleItem

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.clipsToBounds = YES;
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (instancetype)initWithTitle:(NSString *)title
                         icon:(UIImage *)icon
              highlightedIcon:(UIImage *)highlightedIcon
                       tapped:(void (^)(GridViewSimpleItem *item))tapped
{
    if (self = [self initWithFrame:CGRectZero]) {
        
        _iconButton = [UIButton buttonWithType:UIButtonTypeCustom];
        if (highlightedIcon) {
            [_iconButton setImage:highlightedIcon forState:UIControlStateHighlighted];
            _iconButton.width = highlightedIcon.size.width;
            _iconButton.height = highlightedIcon.size.height;
        }
        if (icon) {
            [_iconButton setImage:icon forState:UIControlStateNormal];
            _iconButton.width = icon.size.width;
            _iconButton.height = icon.size.height;
        }
        [_iconButton addTarget:self action:@selector(buttonDidTapped:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_iconButton];
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.text = title;
        _titleLabel.font = [UIFont systemFontOfSize:10];
        [self.contentView addSubview:_titleLabel];
        
        CGFloat badgeWidth = 6;
        _badgeView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, badgeWidth, badgeWidth)];
        _badgeView.image = [[UIImage imageWithColor:[UIColor redColor]] stretchableImageByCenter];
        _badgeView.clipsToBounds = YES;
        _badgeView.layer.cornerRadius = ceilf(badgeWidth / 2);
        _badgeView.hidden = YES;
        [self.contentView addSubview:_badgeView];
        
        if (tapped) {
            self.tappedAction = tapped;
        }
    }
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.iconButton.center = self.contentView.center;
    self.iconButton.top -= 8;
    
    CGSize titleSize = [self.titleLabel.text sizeWithFont:self.titleLabel.font];
    self.titleLabel.width = titleSize.width;
    self.titleLabel.height = titleSize.height;
    self.titleLabel.center = self.contentView.center;
    self.titleLabel.bottom = self.contentView.bottom - 8;
    
    self.badgeView.right = self.contentView.width - 20;
    self.badgeView.top = 15;
}

#pragma mark -
#pragma mark - public
- (void)showBadge
{
    self.badgeView.hidden = NO;
}

- (void)hideBadge
{
    self.badgeView.hidden = YES;
}

#pragma mark -
#pragma mark - private
- (void)buttonDidTapped:(UIButton *)sender
{
    if (self.tappedAction) {
        self.tappedAction(self);
    }
}

@end