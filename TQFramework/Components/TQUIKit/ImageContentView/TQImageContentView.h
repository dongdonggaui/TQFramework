//
//  TQImageContentView.h
//  Hiweido
//
//  Created by huangluyang on 14-9-11.
//  Copyright (c) 2014年 huangluyang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TQImageItemView.h"

@interface TQImageContentView : UIView

@property (nonatomic, strong) NSArray *imagePaths;
@property (nonatomic, copy) void (^tappedAtIndex)(NSInteger);
/**
 *  item间横向间隔
 */
@property (nonatomic, unsafe_unretained) CGFloat itemHorizontalSpace;
/**
 *  item间竖向间隔
 */
@property (nonatomic, unsafe_unretained) CGFloat itemVerticalSpace;

/**
 *  每行item个数
 */
@property (nonatomic, unsafe_unretained) NSInteger maxItemsPerLine;

/**
 *  样式类型
 */
@property (nonatomic, unsafe_unretained) TQImageContentType contentType;
/**
 *  contentType != TQImageContentOnlyImage时有效，文字颜色
 */
@property (nonatomic, strong) UIColor *titleColor;
/**
 *  contentType != TQImageContentOnlyImage时有效，文字背景颜色
 */
@property (nonatomic, strong) UIColor *titlebackgroundColor;

- (void)prepareForReuse;

-(void)updateConstraintsWithImages:(NSArray *)imagePaths titleArrays:(NSArray *)imageTitles;
@end
