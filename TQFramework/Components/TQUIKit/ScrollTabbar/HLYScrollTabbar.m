//
//  HLYScrollTabbar.m
//  laohu
//
//  Created by huangluyang on 14-7-28.
//  Copyright (c) 2014年 wanmei. All rights reserved.
//

#import "HLYScrollTabbar.h"
#import <UIImage+ImageWithColor.h>
#import "UIView+Frame.h"
#import <UIColor+Hex.h>

@interface HLYScrollTabbar ()

@property (nonatomic, strong) UIScrollView   *scrollView;
@property (nonatomic, strong) UIImageView    *backgroundView;
@property (nonatomic, strong) NSMutableArray *contentViews;
@property (nonatomic, strong) NSMutableArray *borders;
@property (nonatomic, strong) UIColor        *titleColor;
@property (nonatomic, strong) UIColor        *selectedTitleColor;
@property (nonatomic, strong) UIImage        *itemBackgroundImage;
@property (nonatomic, strong) UIImage        *itemSelectedBackgroundImage;
@property (nonatomic, strong) UIView         *bottomBorder;
@property (nonatomic, strong) UIView         *cursor;

@property (nonatomic, unsafe_unretained) BOOL showBorder;

@end

@implementation HLYScrollTabbar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        _backgroundView = [[UIImageView alloc] initWithFrame:self.bounds];
        _backgroundView.image = [UIImage imageWithColor:[UIColor clearColor]];
        [self insertSubview:_backgroundView atIndex:0];
        
        _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.clipsToBounds = YES;
        _scrollView.backgroundColor = [UIColor clearColor];
        [self addSubview:_scrollView];
        
        _contentViews = [NSMutableArray array];
        _borders = [NSMutableArray array];
        
        _bottomBorder = [[UIView alloc] initWithFrame:CGRectZero];
        _bottomBorder.backgroundColor = [UIColor colorWithHex:0xD5D5D5];
        _bottomBorder.hidden = YES;
        [self addSubview:_bottomBorder];
        
        _cursor = [[UIView alloc] initWithFrame:CGRectZero];
        [_scrollView addSubview:_cursor];
        
        // default settings
        self.titleColor = [UIColor colorWithHex:0x666666];
        self.selectedTitleColor = [UIColor whiteColor];
        self.itemBackgroundImage = [UIImage imageWithColor:[UIColor clearColor]];
        self.itemSelectedBackgroundImage = [UIImage imageWithColor:[UIColor clearColor]];
        
        self.contentAlignment = HLYVerticalAlignmentCenter;
        
        _itemWidth = 75.f;
        _verticalPadding = 7.f;
        _horizPadding = 8.f;
        _itemCornerRadius = 2.f;
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
              backgroundImage:(UIImage *)backgroundImage
                   titleColor:(UIColor *)titleColor
           selectedTitleColor:(UIColor *)selectedTitleColor
          itemBackgroundImage:(UIImage *)itemBackgroundImage
  itemSelectedBackgroundImage:(UIImage *)itemSelectedBackgroundImage
                  cursorColor:(UIColor *)cursorColor
{
    if (self = [self initWithFrame:frame]) {
        if (backgroundImage) {
            self.backgroundView.image = backgroundImage;
        }
        
        if (titleColor) {
            self.titleColor = titleColor;
        }
        
        if (selectedTitleColor) {
            self.selectedTitleColor = selectedTitleColor;
        }
        
        if (itemBackgroundImage) {
            self.itemBackgroundImage = itemBackgroundImage;
        }
        
        if (itemSelectedBackgroundImage) {
            self.itemSelectedBackgroundImage = itemSelectedBackgroundImage;
        }
        
        if (cursorColor) {
            self.cursor.backgroundColor = cursorColor;
        } else {
            self.cursor.hidden = YES;
        }
    }
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if ([self viewWithTag:10010]) {
        UIView *more = [self viewWithTag:10010];
        [self.scrollView hly_setWidth:[self hly_width] - [more hly_width]];
    } else {
        self.scrollView.frame = self.bounds;
    }
    
    [self.bottomBorder hly_setHeight:0.5];
    [self.bottomBorder hly_setWidth:[self hly_width]];
    [self.bottomBorder hly_setLeft:0];
    [self.bottomBorder hly_setBottom:[self hly_height]];
    
    self.cursor.hidden = !self.showCusor;
    [self.cursor hly_setHeight:3];
    [self.cursor hly_setBottom:[self hly_height]];
    
    CGFloat currentX = self.horizPaddingMode == HLYHorizPaddingModeMiddle?0: self.horizPadding;
    NSInteger i = 0;
    NSInteger titleCount = self.titles.count;
    CGFloat itemWidth = self.tabbarContentMode == HLYScrollTabbarModeFixWidth ? self.itemWidth : CGRectGetWidth(self.frame) / self.contentViews.count;
    for (HLYScrollTabbarItem *item in self.contentViews) {
        [item hly_setLeft:currentX];
        [item hly_setHeight:[self.scrollView hly_height] - 2 * self.verticalPadding];
        [item hly_setCenterY:[self.scrollView hly_height] * 0.5];
        if (self.tabbarContentMode != HLYScrollTabbarModeFlexibleWidth) {
            [item hly_setWidth:itemWidth];
        }
        currentX += [item hly_width] + (self.horizPaddingMode == HLYHorizPaddingModeMargin?0:self.horizPadding);
        
        if (self.showBorder && i != titleCount - 1) {
            UIView *border = [self.borders objectAtIndex:i];
            [border hly_setLeft:[item hly_right]];
            [border hly_setHeight:0.5];
            [border hly_setHeight:[self hly_height]];
        }
        
        if ([self.cursor hly_width] != [item hly_width]) {
            [self.cursor hly_setWidth:[item hly_width]];
        }
        
        i++;
    }
    self.scrollView.contentSize = CGSizeMake(currentX, [self.scrollView hly_height]);
}

#pragma mark -
#pragma mark - setters & getters
- (void)setItemWidth:(CGFloat)itemWidth
{
    _itemWidth = itemWidth;
    
    [self setNeedsLayout];
}

- (void)setVerticalPadding:(CGFloat)verticalPadding
{
    _verticalPadding = verticalPadding;
    
    [self setNeedsLayout];
}

- (void)setHorizPadding:(CGFloat)horizPadding
{
    _horizPadding = horizPadding;
    
    [self setNeedsLayout];
}

- (UIFont *)font
{
    return _font ? _font : [self defaultFont];
}

- (void)setShowBottomBorder:(BOOL)showBottomBorder
{
    self.bottomBorder.hidden = !showBottomBorder;
}

- (BOOL)showBottomBorder
{
    return !self.bottomBorder.hidden;
}

- (void)setupTabbarWithTitles:(NSArray *)titles
            tabbarContentMode:(HLYScrollTabbarMode)tabbarContentMode
                   showBorder:(BOOL)showBorder
{
    if (_titles != titles) {
        self.tabbarContentMode = tabbarContentMode;
        [self.contentViews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [self.contentViews removeAllObjects];
        [self.borders makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [self.borders removeAllObjects];
        _titles = titles;
        
        self.showBorder = showBorder;
        
        NSInteger i = 0;
        NSInteger titleCount = titles.count;
        __weak HLYScrollTabbar *safeSelf = self;
        for (NSString *title in titles) {
            HLYScrollTabbarItem *item = [[HLYScrollTabbarItem alloc] initWithTitle:title titleColor:self.titleColor selectedTitleColor:self.selectedTitleColor itemBackgroundImage:self.itemBackgroundImage itemSelectedBackgroundImage:self.itemSelectedBackgroundImage];
            item.didTapped = ^{
                [safeSelf tabbarDidTappedAtIndex:i];
            };
            item.selected = i == 0;
            item.alignment = self.contentAlignment;
            item.font = self.font;
            item.layer.cornerRadius = self.itemCornerRadius;
            item.clipsToBounds = YES;
            item.layer.borderWidth = self.itemborderWidth;
            item.layer.borderColor = [self.itemborderColor CGColor];
            
            [self.scrollView insertSubview:item belowSubview:self.cursor];
            
            if (showBorder && i != titleCount - 1) {
                UIView *border = [[UIView alloc] initWithFrame:CGRectZero];
                border.backgroundColor = self.bottomBorder.backgroundColor;
                [self.scrollView addSubview:border];
                [self.borders addObject:border];
            }
            
            if ([self.cursor hly_width] != [item hly_width]) {
                [self.cursor hly_setWidth:[item hly_width]];
            }
            
            [self.contentViews addObject:item];
            
            i++;
        }
        
        //FIXME: 取消了“更多”提示
        // more...
//        if (currentX > self.width) {
//            if (![self viewWithTag:10010]) {
//                UIView *more = [[UIView alloc] initWithFrame:CGRectMake(self.width - 30, 0, 30, self.height)];
//                more.backgroundColor = [UIColor blueColor];
//                more.tag = 10010;
//                [self addSubview:more];
//                
//            }
//        } else {
//            if ([self viewWithTag:10010]) {
//                [[self viewWithTag:10010] removeFromSuperview];
//            }
//        }
        
        [self setNeedsLayout];
    }
}

- (void)updateTabbarTitleColor:(UIColor *)color atIndex:(NSInteger)index
{
    [self updateTabbarTitleColor:color selectedTitleColor:nil atIndex:index];
}

- (void)updateTabbarTitleColor:(UIColor *)color selectedTitleColor:(UIColor *)selectedColor atIndex:(NSInteger)index
{
    if (index < 0 || index >= self.contentViews.count) {
        return;
    }
    
    HLYScrollTabbarItem *item = [self.contentViews objectAtIndex:index];
    if (![item isKindOfClass:[HLYScrollTabbarItem class]]) {
        return;
    }
    if (color) {
        [item.button setTitleColor:color forState:UIControlStateNormal];
    }
    
    if (selectedColor) {
        [item.button setTitleColor:selectedColor forState:UIControlStateNormal];
    }
}

- (void)setSelectedIndex:(NSInteger)selectedIndex
{
    
    [self tabbarDidTappedAtIndex:selectedIndex withUserInteraction:NO];
}

#pragma mark -
#pragma mark - private
- (UIFont *)defaultFont
{
    return [UIFont boldSystemFontOfSize:15];
}

- (void)tabbarDidTappedAtIndex:(NSInteger)index
{
    [self tabbarDidTappedAtIndex:index withUserInteraction:YES];
}

- (void)tabbarDidTappedAtIndex:(NSInteger)index withUserInteraction:(BOOL)withUserInteraction
{
    _selectedIndex = index;
    
    for (HLYScrollTabbarItem *item in self.contentViews) {
        item.selected = NO;
    }
    
    HLYScrollTabbarItem *currentItem = [self.contentViews objectAtIndex:index];
    currentItem.selected = YES;
    
    CGFloat leftOffset = [currentItem hly_left] - self.scrollView.contentOffset.x;
    CGFloat rightOffset = [currentItem hly_right] - self.scrollView.contentOffset.x - ([self viewWithTag:10010] ? [[self viewWithTag:10010] hly_left] : [self.scrollView hly_right]);
    if (leftOffset < 0) {
        [self.scrollView setContentOffset:CGPointMake([currentItem hly_left], 0) animated:YES];
    } else if (rightOffset > 0) {
        [self.scrollView setContentOffset:CGPointMake(rightOffset + self.scrollView.contentOffset.x, 0) animated:YES];
    }
    
    if (withUserInteraction && self.didTappedAtIndex) {
        self.didTappedAtIndex(index);
    }
    
    //
    [self.cursor hly_setLeft:index * [currentItem hly_width]];
}

@end

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

@interface HLYScrollTabbarItem ()

@property (nonatomic, strong) UIButton *button;

@end

@implementation HLYScrollTabbarItem

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _button = [UIButton buttonWithType:UIButtonTypeCustom];
        [_button addTarget:self action:@selector(buttonDidTapped:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_button];
    }
    return self;
}

- (instancetype)initWithTitle:(NSString *)title
                   titleColor:(UIColor *)titleColor
           selectedTitleColor:(UIColor *)selectedTitleColor
          itemBackgroundImage:(UIImage *)itemBackgroundImage
  itemSelectedBackgroundImage:(UIImage *)itemSelectedBackgroundImage
{
    if (self = [self initWithFrame:CGRectZero]) {
        [self.button setTitle:title forState:UIControlStateNormal];
        [self.button setTitleColor:titleColor forState:UIControlStateNormal];
        [self.button setTitleColor:selectedTitleColor forState:UIControlStateSelected];
        [self.button setBackgroundImage:itemBackgroundImage forState:UIControlStateNormal];
        [self.button setBackgroundImage:itemSelectedBackgroundImage forState:UIControlStateSelected];
        
        // default font
        self.font = [UIFont boldSystemFontOfSize:15];
    }
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.button hly_setWidth:[self hly_width]];
    [self.button hly_setHeight:[self hly_height]];
    
    if (self.alignment == HLYVerticalAlignmentTop) {
        [self.button hly_setTop:0];
    } else if (self.alignment == HLYVerticalAlignmentBottom) {
        [self.button hly_setBottom:[self hly_height]];
    }
}

#pragma mark -
#pragma mark - setters & getters
- (void)setSelected:(BOOL)selected
{
    self.button.selected = selected;
}

- (BOOL)isSelected
{
    return self.button.isSelected;
}

- (void)setFont:(UIFont *)font
{
    self.button.titleLabel.font = font;
    
//    if (self.fixItemWidth) {
////        self.button.width = self.width - 2 * kScrollTabbarItemPaddingH;
//        self.button.width = self.width;
//    } else {
//        CGSize textSize = [[self.button titleForState:UIControlStateNormal] sizeWithFont:self.font];
//        self.button.width = textSize.width;
//        
//        self.width = self.button.width + 2 * kScrollTabbarItemPaddingH;
//    }
//    self.button.height = self.height;
}

- (UIFont *)font
{
    return self.button.titleLabel.font;
}

#pragma mark -
#pragma mark - private
- (void)buttonDidTapped:(UIButton *)sender
{
    if (sender.isSelected) {
        return;
    }
    
    sender.selected = YES;
    
    if (self.didTapped) {
        self.didTapped();
    }
}

@end


////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

@interface HLYMoreIndicatorView : UIView

@end

@implementation HLYMoreIndicatorView

- (void)drawRect:(CGRect)rect
{

}

@end
