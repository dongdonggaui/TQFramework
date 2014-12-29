//
//  HLYGridView.h
//  laohu-dota-assistant
//
//  Created by huangluyang on 14-7-31.
//  Copyright (c) 2014年 wanmei. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  网格视图（用来实现六个模拟器入口）
 */
@interface HLYGridView : UIView

@property (nonatomic, unsafe_unretained) NSInteger columnCount;
@property (nonatomic, unsafe_unretained) CGFloat rowHeight;
@property (nonatomic, strong) NSArray *items;

@end

/**
 *  网格视图显示单元基类
 */
@interface HLYGridViewItem : UIView

@property (nonatomic, strong, readonly) UIView *contentView;

@end

/**
 * 带标题图标的网格显示单元
 */
@interface GridViewSimpleItem : HLYGridViewItem

/**
 *  初始化网格显示单元
 *
 *  @param title           网格标题
 *  @param icon            网格图标
 *  @param highlightedIcon 网格高亮图标
 *  @param tapped          点击事件回调
 *
 */
- (instancetype)initWithTitle:(NSString *)title
                         icon:(UIImage *)icon
              highlightedIcon:(UIImage *)highlightedIcon
                       tapped:(void (^)(GridViewSimpleItem *))tapped;
/**
 *  显示更新标识符
 */
- (void)showBadge;

/**
 *  隐藏更新标识符
 */
- (void)hideBadge;

@end
