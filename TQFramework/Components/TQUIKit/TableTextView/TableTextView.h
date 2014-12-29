//
//  TableTextView.h
//  laohu-dota-assistant
//
//  Created by zhangjia on 14/12/25.
//  Copyright (c) 2014年 wanmei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TableTextView : UIView

/*
 表格左边距
 */
@property (nonatomic,assign) float leftMargin;

/*
 表格右边距
 */
@property (nonatomic,assign) float rightMargin;

/*
 表格行高度
 */
@property (nonatomic,assign) float rowHeight;

/*
 表格边框颜色
 */
@property (nonatomic,strong) UIColor* tableBorderColor;

/*
 表格边框宽度
 */
@property (nonatomic,assign) float tableBorderWidth;

/*
 表格背景色
 */
@property (nonatomic,strong) UIColor* tableBackgroundColor;

/*
 表格行数
 */
@property (nonatomic,assign) NSInteger numberOfRow;

/*
 表格列数
 */
@property (nonatomic,assign) NSInteger numberOfList;

/*
 表格内容文本字号
 */
@property (nonatomic,assign) float titleFontSize;

/*
 表格内填充文本内容
 */
@property (nonatomic, copy) NSString* (^textAtIndexWithTable)(int row,int list);

/*
 表格内填充文本颜色
 */
@property (nonatomic, copy) UIColor* (^textColorAtIndexWithTable)(int row,int list);

-(void)loadTableTextView;
@end
