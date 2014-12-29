//
//  HLYScrollTabbar.h
//  laohu
//
//  Created by huangluyang on 14-7-28.
//  Copyright (c) 2014年 wanmei. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, HLYVerticalAlignment) {
    HLYVerticalAlignmentTop,
    HLYVerticalAlignmentCenter,
    HLYVerticalAlignmentBottom,
};

typedef NS_ENUM(NSUInteger, HLYScrollTabbarMode) {
    HLYScrollTabbarModeFlexibleWidth,   /// 自适应宽度，总宽度不限制
    HLYScrollTabbarModeFixWidth,        /// 固定宽度，总宽度不限制
    HLYScrollTabbarModeScaleToFill,     /// 根据tabbar宽度等分item宽度
};

typedef NS_ENUM(NSUInteger, HLYHorizPaddingMode) {
    HLYHorizPaddingModeAll,          /// 横向都有间隔
    HLYHorizPaddingModeMargin,       /// 只两端需要，item间不需要
    HLYHorizPaddingModeMiddle        /// 两端不需要，item间需要
};

/**
 *  可滑动的tabbar
 */
@interface HLYScrollTabbar : UIView

// setting
@property (nonatomic, strong, readonly) NSArray *titles;
@property (nonatomic, strong) UIFont *font;
@property (nonatomic, assign) BOOL showBottomBorder;
@property (nonatomic, assign) HLYVerticalAlignment contentAlignment;
@property (nonatomic, assign) HLYScrollTabbarMode tabbarContentMode;
@property (nonatomic, assign) CGFloat itemWidth;
@property (nonatomic, assign) CGFloat itemCornerRadius;
@property (nonatomic, assign) CGFloat verticalPadding;
@property (nonatomic, assign) CGFloat horizPadding;
@property (nonatomic, assign) BOOL showCusor;
@property (nonatomic, assign) CGFloat itemborderWidth;
@property (nonatomic, assign) UIColor *itemborderColor;
@property (nonatomic, assign) HLYHorizPaddingMode horizPaddingMode;
// state
@property (nonatomic, unsafe_unretained) NSInteger selectedIndex;

// callback
@property (nonatomic, copy) void (^didTappedAtIndex)(NSInteger index);

/**
 *  初始化，初始化之后需要调用setupTabbarWithTitles:fixItemWidth:方法来配置每个tab
 *
 *  @param frame                       frame
 *  @param backgroundImage             背景图片，可为空
 *  @param titleColor                  tab正常状态下文字颜色，可为空，默认为0x666666
 *  @param selectedTitleColor          tab选中状态下文字颜色，可为空，默认为RGBCOLOR(254.f, 143.f, 63.f)
 *  @param itemBackgroundImage         tab正常状态下背景图片，可为空
 *  @param itemSelectedBackgroundImage tab选中状态下背景图片，可为空
 *  @param cursorColor                 item底部光标颜色，可为空，为空则不显示
 *
 *  @return 初始化实例
 */
- (instancetype)initWithFrame:(CGRect)frame
              backgroundImage:(UIImage *)backgroundImage
                   titleColor:(UIColor *)titleColor
           selectedTitleColor:(UIColor *)selectedTitleColor
          itemBackgroundImage:(UIImage *)itemBackgroundImage
  itemSelectedBackgroundImage:(UIImage *)itemSelectedBackgroundImage
                  cursorColor:(UIColor *)cursorColor;

/**
 *  配置tabbar，用来初始化每个tabItem
 *
 *  @param titles             每个tab的标题组成的集合
 *  @param tabbarContentMode  内容填充模式，用来标识每个tab是否为固定宽度，若固定则默认宽度为80，否则将根据title字符串长度自适应
 *  @param showBorder         用来标识是否显示item边框
 */
- (void)setupTabbarWithTitles:(NSArray *)titles
            tabbarContentMode:(HLYScrollTabbarMode)tabbarContentMode
                   showBorder:(BOOL)showBorder;

- (void)updateTabbarTitleColor:(UIColor *)color atIndex:(NSInteger)index;
- (void)updateTabbarTitleColor:(UIColor *)color selectedTitleColor:(UIColor *)selectedColor atIndex:(NSInteger)index;

@end

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

/**
 *  组成可滑动的tabbar的item
 */
@interface HLYScrollTabbarItem : UIView

// setting
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) UIFont   *font;
@property (nonatomic, unsafe_unretained) HLYVerticalAlignment alignment;

// state
@property (nonatomic, unsafe_unretained, getter = isSelected) BOOL selected;

@property (nonatomic, strong, readonly) UIButton *button;

// callback
@property (nonatomic, copy) void (^didTapped)();

/**
 *  初始化
 *
 *  @param title                       title
 *  @param titleColor                  tab正常状态下文字颜色，不能为空
 *  @param selectedTitleColor          tab选中状态下文字颜色，不能为空
 *  @param itemBackgroundImage         tab正常状态下背景图片，不能为空
 *  @param itemSelectedBackgroundImage tab选中状态下背景图片，不能为空
 *  @param fixItemWidth                用来标识此item是否固定宽度还是自适应宽度
 *
 *  @return 初始化实例
 */
- (instancetype)initWithTitle:(NSString *)title
                   titleColor:(UIColor *)titleColor
           selectedTitleColor:(UIColor *)selectedTitleColor
          itemBackgroundImage:(UIImage *)itemBackgroundImage
  itemSelectedBackgroundImage:(UIImage *)itemSelectedBackgroundImage;

@end
