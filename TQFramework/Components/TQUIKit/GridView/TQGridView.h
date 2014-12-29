//
//  TQGridView.h
//  Hiweido
//
//  Created by huangluyang on 14/11/16.
//  Copyright (c) 2014年 huangluyang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TQGridView : UIView

// config
@property (nonatomic, strong) NSArray *gridCotentViews;
@property (nonatomic, copy) void (^tappedAtIndex)(TQGridView *gridView, NSInteger index);

/**
 *  标识grid高度是否固定，若为YES则根据itemHeight在绘制，itemHeightWidthRate属性无效，否者将根据itemHeightWidthRate自动计算，itemHeight属性无效，默认为NO
 */
@property (nonatomic, assign) BOOL fixedWidth;

/**
 *  固定高度模式设置高度，只在fixWidth为YES时才有效，默认为44
 */
@property (nonatomic, assign) CGFloat itemHeight;

/**
 *  自适应高度模式设置高宽比，只在fixedWidth为NO时才有效，默认为1
 */
@property (nonatomic, assign) CGFloat itemHeightWidthRate;

/**
 *  item间距，默认为3
 */
@property (nonatomic, assign) CGFloat itemSpace;

/**
 *  item行距，默认为3
 */
@property (nonatomic, assign) CGFloat rowSpace;

/**
 *  每行最多显示item个数，默认为3
 */
@property (nonatomic, assign) NSInteger maxItemsPerLine;

/**
 *  重用时做一些回收工作
 */
- (void)prepareForReuse;

@end


//////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////

@interface TQGridViewContentView : UIView

- (void)prepareForResuse;

@end