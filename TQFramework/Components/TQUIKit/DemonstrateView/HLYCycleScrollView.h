//
//  HLYCycleScrollView.h
//  Hiweido
//
//  Created by huangluyang on 14-1-23.
//  Copyright (c) 2014年 Apple Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HLYCycleScrollView : UIView

@property (strong, nonatomic , readonly) UIScrollView *scrollView;
/**
 *  初始化
 *
 *  @param frame             frame
 *  @param animationDuration 自动滚动的间隔时长。如果<=0，不自动滚动。
 *
 *  @return instance
 */
- (id)initWithFrame:(CGRect)frame animationDuration:(NSTimeInterval)animationDuration;

/**
 数据源：获取总的page个数，必须在fetchContentAtIndex之后设置，否则显示不正常
 **/
@property (nonatomic , copy) NSInteger (^totalPagesCount)(void);
/**
 数据源：获取第pageIndex个位置的contentView，必须在totalPagesCount之前设置，否则显示不正常
 **/
@property (nonatomic , copy) UIView *(^fetchContentViewAtIndex)(NSInteger pageIndex);
/**
 当点击的时候，执行的block
 **/
@property (nonatomic , copy) void (^tapActionBlock)(NSInteger pageIndex);
/**
 当视图滚动的时候，执行的block
 **/
@property (nonatomic , copy) void (^didEndScrolledBlock)(NSInteger pageIndex);

@end