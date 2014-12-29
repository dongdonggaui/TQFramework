//
//  TQDropList.m
//  Hiweido
//
//  Created by huangluyang on 14-8-28.
//  Copyright (c) 2014年 huangluyang. All rights reserved.
//

#import "TQDropList.h"

#import <POP.h>

#import "UIView+Frame.h"
#import <UIImage+ImageWithColor.h>
#import <UIColor+Hex.h>

@interface TQDropList ()

// UI
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *maskView;

//
@property (nonatomic, strong) NSMutableArray *items;

//
@property (nonatomic, unsafe_unretained) CGFloat appearanceY;

@end

@implementation TQDropList

- (instancetype)init
{
    if (self = [super init]) {
        self.clipsToBounds = YES;
        self.hidden = YES;
        
        _maskView = [[UIView alloc] initWithFrame:CGRectZero];
        _maskView.userInteractionEnabled = YES;
        _maskView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
        [self addSubview:_maskView];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(maskViewDidSingleTapped:)];
        [_maskView addGestureRecognizer:tap];
        
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
        _scrollView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_scrollView];
        
        _items = [NSMutableArray array];
        
        _itemWidth = 185;
        _itemHeight = 43;
        _itemAnchor = 0;
        _displayItemCount = 4;
        _appearanceY = 0;
    }
    
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    UIView *superView = self.superview;
    [self hly_setTop:self.appearanceY];
    [self hly_setWidth:[superView hly_width]];
    [self hly_setHeight:[superView hly_height] - [self hly_top]];
    
    self.maskView.frame = self.bounds;
    
    // 以标题和图标总长度最长的item居中后的左边对齐
    CGFloat maxTitleWidth = 0;
    
    for (int i = 0; i < self.items.count; i++) {
        UIButton *button = [self.items objectAtIndex:i];
        
        [button sizeToFit];
        
        maxTitleWidth = MAX(maxTitleWidth, [button hly_width]);
        
        [button hly_setWidth:self.itemWidth];
        [button hly_setHeight:self.itemHeight];
        [button hly_setTop:i * self.itemHeight];
    }
    
    for (TQLeftIconButton *button in self.items) {
        [button tq_setLeftPadding:ceilf((self.itemWidth - maxTitleWidth) / 2)];
    }
    
    [self.scrollView hly_setTop:0];
//    [self.scrollView hly_setHeight:self.displayItemCount * self.itemHeight];
    [self.scrollView hly_setWidth:self.itemWidth];
    [self.scrollView hly_setLeft:self.itemAnchor];
    self.scrollView.contentSize = CGSizeMake([self.scrollView hly_width], MAX([self.scrollView hly_height], self.itemHeight * self.items.count));
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    BOOL flag = [super pointInside:point withEvent:event];
    if (!flag) {
        [self dismiss];
    }
    
    return flag;
}

#pragma mark -
#pragma mark - setters & getters
- (void)setSelectedIndex:(NSInteger)selectedIndex
{
    if (selectedIndex >= self.items.count) {
        return;
    }
    
    UIButton *button = [self.items objectAtIndex:selectedIndex];
    button.selected = YES;
}

- (NSInteger)selectedIndex
{
    for (UIButton *button in self.items) {
        if (button.isSelected) {
            return button.tag - 100;
        }
    }
    
    return 0;
}

#pragma mark -
#pragma mark - public
- (void)setupWithTitles:(NSArray *)titles
{
    [self setupWithTitles:titles icons:nil];
}

- (void)setupWithTitles:(NSArray *)titles icons:(NSArray *)icons
{
    if (!titles) {
        return;
    }
    
    [self.items makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.items removeAllObjects];
    
    for (int i = 0; i < titles.count; i++) {
        TQLeftIconButton *button = [TQLeftIconButton buttonWithType:UIButtonTypeCustom];
        button.tag = 100 + i;
        
        NSString *title = [titles objectAtIndex:i];
        button.titleLabel.font = [UIFont boldSystemFontOfSize:15];
        [button setTitle:title forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithHex:0x4d4d4d] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageWithColor:[UIColor clearColor]] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageWithColor:[UIColor lightGrayColor]] forState:UIControlStateSelected];
        [button setBackgroundImage:[UIImage imageWithColor:[UIColor lightGrayColor]] forState:UIControlStateHighlighted];
        [button addTarget:self action:@selector(buttonDidTapped:) forControlEvents:UIControlEventTouchUpInside];
        
        if (icons && icons.count > i) {
            UIImage *icon = [icons objectAtIndex:i];
            [button setImage:icon forState:UIControlStateNormal];
        }
        
        [self.scrollView addSubview:button];
        
        [self.items addObject:button];
    }
}

- (void)updateItemWithTitle:(NSString *)title titleColor:(UIColor *)titleColor icon:(UIImage *)icon atIndex:(NSInteger)index
{
    if (!self.items || self.items.count <= index) {
        return;
    }
    
    TQLeftIconButton *button = [self.items objectAtIndex:index];
    if (title) {
        [button setTitle:title forState:UIControlStateNormal];
    }
    
    if (titleColor) {
        [button setTitleColor:titleColor forState:UIControlStateNormal];
    }
    
    if (icon) {
        [button setImage:icon forState:UIControlStateNormal];
    }
}

- (NSString *)titleAtIndex:(NSInteger)index
{
    if (!self.items || index >= self.items.count) {
        return nil;
    }
    
    UIButton *button = [self.items objectAtIndex:index];
    
    if (![button isKindOfClass:[UIButton class]]) {
        return nil;
    }
    
    return [button titleForState:UIControlStateNormal];
}

- (void)showFromHeight:(CGFloat)height
{
    if (self.superview) {
        return;
    }
    self.appearanceY = height;
    self.hidden = NO;
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    if (!window) {
        window = [UIApplication sharedApplication].windows.lastObject;
    }
    
    [window addSubview:self];
    
    if (self.willShow) {
        self.willShow(self);
    }
    
    if ([self.scrollView pop_animationForKey:@"showMove"] || [self.scrollView pop_animationForKey:@"showFade"]) {
        return;
    }
    
    [self.scrollView pop_removeAllAnimations];
    
    POPSpringAnimation *moveAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPViewFrame];
    CGRect toFrame = self.scrollView.frame;
    toFrame.size.height = self.displayItemCount * self.itemHeight;
    moveAnimation.toValue = [NSValue valueWithCGRect:toFrame];
    moveAnimation.springBounciness = 10;
    moveAnimation.springSpeed = 6;
    
    POPSpringAnimation *fadeAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPViewAlpha];
    fadeAnimation.toValue = @(1);
    fadeAnimation.springSpeed = 6;
    
    [self.scrollView pop_addAnimation:moveAnimation forKey:@"showMove"];
    [self.maskView pop_addAnimation:fadeAnimation forKey:@"showFade"];
}

- (void)dismiss
{
    if (!self.superview) {
        return;
    }
    
    __weak TQDropList *safeSelf = self;
    
    if (self.willDismissWithIndex) {
        self.willDismissWithIndex(self, self.selectedIndex);
    }
    
    POPSpringAnimation *moveAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPViewFrame];
    CGRect toFrame = self.scrollView.frame;
    toFrame.size.height = 0;
    moveAnimation.toValue = [NSValue valueWithCGRect:toFrame];
    moveAnimation.springSpeed = 26;
    moveAnimation.springBounciness = 0;
    moveAnimation.completionBlock = ^(POPAnimation *anim, BOOL finished) {
        if (finished) {
            if (![safeSelf.scrollView pop_animationForKey:@"showMove"]) {
                safeSelf.hidden = YES;
            }
            
            if (safeSelf.deselectItemWhenDismiss) {
                for (UIButton *button in safeSelf.items) {
                    button.selected = NO;
                }
            }
            
            [safeSelf removeFromSuperview];
        }
    };
    
    POPSpringAnimation *fadeAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPViewAlpha];
    fadeAnimation.toValue = @(0);
    fadeAnimation.springSpeed = 26;
    
    [self.scrollView pop_addAnimation:moveAnimation forKey:@"dismissMove"];
    [self.maskView pop_addAnimation:fadeAnimation forKey:@"dismissFade"];
}

- (void)deselectItemAtIndex:(NSInteger)index animated:(BOOL)animated
{
    if (!self.items || index >= self.items.count) {
        return;
    }
    
    UIButton *item = [self.items objectAtIndex:index];
    if (animated) {
        [UIView animateWithDuration:1 animations:^{
            
        } completion:^(BOOL finished) {
            if (finished) {
//                item.selected = NO;
            }
        }];
    } else {
        item.selected = NO;
    }
}

#pragma mark -
#pragma mark - private
- (UIWindow *)tq_applicationWindow
{
    return [UIApplication sharedApplication].keyWindow ? : [[UIApplication sharedApplication].windows lastObject];
}

- (void)buttonDidTapped:(UIButton *)sender
{
    if (sender.isSelected) {
        return;
    }
    
    for (UIButton *button in self.items) {
        button.selected = NO;
    }
    
    sender.selected = YES;
    
    if (self.didSelectItemAtIndex) {
        self.didSelectItemAtIndex(self, sender.tag - 100);
    }
    
    [self dismiss];
}

#pragma mark -
#pragma mark - gesture
- (void)maskViewDidSingleTapped:(UITapGestureRecognizer *)tap
{
    [self dismiss];
    
    if (self.cancelBlock) {
        self.cancelBlock(self);
    }
}

@end


//////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////

@interface TQLeftIconButton ()

@property (nonatomic) CGFloat leftPadding;
@property (nonatomic) CGFloat rightPadding;
@property (nonatomic) CGFloat space;

@end

@implementation TQLeftIconButton

+ (instancetype)buttonWithType:(UIButtonType)buttonType
{
    TQLeftIconButton *button = [super buttonWithType:buttonType];
    button.leftPadding = 0;
    button.space = 10;
    button.rightPadding = 0;
    
    return button;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (self.imageView.image) {
        self.imageView.hidden = NO;
        [self.imageView hly_setLeft:self.leftPadding - 5];
        [self.titleLabel hly_setLeft:[self.imageView hly_right] + self.space];
    } else {
        self.imageView.hidden = YES;
        [self.titleLabel hly_setLeft:self.leftPadding];
    }
}

#pragma mark -
#pragma mark - public
- (void)tq_setLeftPadding:(CGFloat)leftPadding
{
    self.leftPadding = leftPadding;
    
    [self setNeedsLayout];
}

- (void)tq_setRightPadding:(CGFloat)rightPadding
{
    self.rightPadding = rightPadding;
    
    [self setNeedsLayout];
}

- (void)tq_setSpaceBetweenImageAndTitle:(CGFloat)space
{
    self.space = space;
    
    [self setNeedsLayout];
}

@end

