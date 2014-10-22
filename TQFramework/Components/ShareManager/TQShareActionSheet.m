//
//  TQShareActionSheet.m
//  laohu
//
//  Created by huangluyang on 14/10/21.
//  Copyright (c) 2014年 wanmei. All rights reserved.
//

#import "TQShareActionSheet.h"

@interface TQShareActionSheet ()

@property (nonatomic, strong) NSMutableArray *items;

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) UIView *separateLine;

@property (nonatomic, strong) UIView *maskView;

@end

@implementation TQShareActionSheet

- (instancetype)initWithTitle:(NSString *)title cancelButtonTitle:(NSString *)cancelButtonTitle
{
    if (self = [super initWithFrame:CGRectZero]) {
        _items = [NSMutableArray array];
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLabel.text = title;
        _titleLabel.textColor = UIColorFromRGB(0x666666);
        _titleLabel.font = [UIFont systemFontOfSize:16];
        _titleLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:_titleLabel];
        
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
        _scrollView.backgroundColor = [UIColor clearColor];
        [self addSubview:_scrollView];
        
        _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancelButton setTitle:cancelButtonTitle forState:UIControlStateNormal];
        [_cancelButton setTitleColor:UIColorFromRGB(0xfe8f3f) forState:UIControlStateNormal];
        [_cancelButton addTarget:self action:@selector(sas_cancelButtonDidTapped:) forControlEvents:UIControlEventTouchUpInside];
        _cancelButton.titleLabel.font = [UIFont systemFontOfSize:18];
        [self addSubview:_cancelButton];
        
        _separateLine = [[UIView alloc] initWithFrame:CGRectZero];
        _separateLine.backgroundColor = [UIColor lightGrayColor];
        [self addSubview:_separateLine];
        
        _maskView = [[UIView alloc] initWithFrame:CGRectZero];
        _maskView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
        _maskView.userInteractionEnabled = YES;
        
        self.backgroundColor = [UIColor whiteColor];
        
        self.layer.shadowColor = [UIColor grayColor].CGColor;
        self.layer.shadowOffset = CGSizeMake(0, -1);
        self.layer.shadowRadius = 1;
        self.layer.shadowOpacity = 0.5;
    }
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    if (!window) {
        window = [UIApplication sharedApplication].windows.lastObject;
    }
    
    self.maskView.frame = window.bounds;
    
    self.width = window.width;
    
    [self.titleLabel sizeToFit];
    self.titleLabel.top = 15;
    self.titleLabel.centerX = ceilf(self.width / 2);
    
    self.scrollView.width = self.width;
    self.scrollView.top = self.titleLabel.bottom + 25;
    self.scrollView.left = 0;
    self.scrollView.height = 78.5;
    
    CGFloat currentLeft = 5;
    CGFloat itemWidth = 75;
    CGFloat itemHeight = self.scrollView.height;
    for (int i  = 0; i < self.items.count; i++) {
        TQShareActionSheetItem *item = [self.items objectAtIndex:i];
        
        item.left = currentLeft;
        item.top = 0;
        item.width = itemWidth;
        item.height = itemHeight;
        
        currentLeft += itemHeight;
    }
    
    self.scrollView.contentSize = CGSizeMake(MAX(currentLeft, self.scrollView.width), self.scrollView.height);
    
    self.separateLine.height = 0.5;
    self.separateLine.width = self.width;
    self.separateLine.top = self.scrollView.bottom + 30;
    
    self.cancelButton.top = self.separateLine.bottom;
    self.cancelButton.width = self.width;
    self.cancelButton.height = 50;
    
    self.height = self.cancelButton.bottom;
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    BOOL flag = [super pointInside:point withEvent:event];
    
    if (!flag) {
        [self dismissShareActionSheet];
    }
    
    return flag;
}

- (void)addShareItem:(TQShareActionSheetItem *)item
{
    if (!item) {
        return;
    }
    
    [self.items addObject:item];
    [self.scrollView addSubview:item];
    [self setNeedsLayout];
}

- (void)showShareActionSheet
{
    if (self.superview) {
        return;
    }
    
    if (self.maskView.superview) {
        [self.maskView removeFromSuperview];
    }
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    if (!window) {
        window = [UIApplication sharedApplication].windows.lastObject;
    }
    
    self.maskView.alpha = 0;
    self.top = window.height;
    self.alpha = 0;
    
    [window addSubview:self.maskView];
    [window addSubview:self];
    
    [self setNeedsLayout];
    [self layoutIfNeeded];
    
    [UIView animateWithDuration:0.25 animations:^{
        self.maskView.alpha = 1;
        self.bottom = window.height;
        self.alpha = 1;
    }];
}

- (void)dismissShareActionSheet
{
    if (!self.superview) {
        return;
    }
    
    if (self.willDismissBlock) {
        self.willDismissBlock();
    }
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    if (!window) {
        window = [UIApplication sharedApplication].windows.lastObject;
    }
    
    [UIView animateWithDuration:0.25 animations:^{
        self.maskView.alpha = 0;
        self.top = window.height;
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self.maskView removeFromSuperview];
        [self removeFromSuperview];
    }];
}

#pragma mark -
#pragma mark - private
- (void)sas_cancelButtonDidTapped:(UIButton *)sender
{
    [self dismissShareActionSheet];
}

@end


////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

@interface TQShareActionSheetItem ()

@property (nonatomic, strong) UIImage *iconNormal;
@property (nonatomic, strong) NSString *titleNormal;
@property (nonatomic, strong) UIColor *titleColorNormal;

@property (nonatomic, strong) UIImage *iconSelected;
@property (nonatomic, strong) NSString *titleSelected;
@property (nonatomic, strong) UIColor *titleColorSelected;

@end

@implementation TQShareActionSheetItem

+ (instancetype)itemWithIcon:(UIImage *)icon
                       title:(NSString *)title
                selectedIcon:(UIImage *)selectedIcon
               selectedTitle:(NSString *)selectedTitle
                      tapped:(TQShareActionSheetItemTappedBlock)tapped
{
    TQShareActionSheetItem *item = [self buttonWithType:UIButtonTypeCustom];
    if (icon) {
        [item setImage:icon forState:UIControlStateNormal];
        item.iconNormal = icon;
    }
    
    if (title) {
        [item setTitle:title forState:UIControlStateNormal];
        item.titleNormal = title;
    }
    
    if (selectedIcon) {
        [item setImage:selectedIcon forState:UIControlStateSelected];
        item.iconSelected = selectedIcon;
    }
    
    if (selectedTitle) {
        [item setTitle:selectedTitle forState:UIControlStateSelected];
        item.titleSelected = selectedTitle;
    }
    
    if (tapped) {
        item.tappedAction = tapped;
    }
    
    item.titleColorNormal = [UIColor grayColor];
    item.titleColorSelected = UIColorFromRGB(0xff7e00);
    
    [item setTitleColor:item.titleColorNormal forState:UIControlStateNormal];
    [item setTitleColor:item.titleColorSelected forState:UIControlStateSelected];
    [item addTarget:item action:@selector(sasi_itemDidTapped:) forControlEvents:UIControlEventTouchUpInside];
    item.titleLabel.font = [UIFont systemFontOfSize:12];
    
    return item;
}

- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    
    if (selected) {
        [self setImage:self.iconSelected forState:UIControlStateNormal];
        [self setTitle:self.titleSelected forState:UIControlStateNormal];
        [self setTitleColor:self.titleColorSelected forState:UIControlStateNormal];
    } else {
        [self setImage:self.iconNormal forState:UIControlStateNormal];
        [self setTitle:self.titleNormal forState:UIControlStateNormal];
        [self setTitleColor:self.titleColorNormal forState:UIControlStateNormal];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat centerX = ceilf(self.width / 2);
    CGFloat currentTop = 0;
    [self.titleLabel sizeToFit];
    self.titleLabel.centerX = centerX;
    
    if (self.imageView.image) {
        [self.imageView sizeToFit];
        self.imageView.centerX = centerX;
        self.imageView.top = currentTop;
        currentTop += self.imageView.height + 9;
    }
    
    self.titleLabel.top = currentTop;
}

#pragma mark -
#pragma mark - public
- (void)updateItemWithIcon:(UIImage *)icon title:(NSString *)title
{
    if (icon) {
        [self setImage:icon forState:UIControlStateNormal];
    }
    
    if (title) {
        [self setTitle:title forState:UIControlStateNormal];
    }
    
    [self setNeedsLayout];
}

#pragma mark -
#pragma mark - private
- (void)sasi_itemDidTapped:(TQShareActionSheetItem *)sender
{
    if (self.tappedAction) {
        self.tappedAction();
    }
}

@end
