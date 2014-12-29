//
//  TableTextView.m
//  laohu-dota-assistant
//
//  Created by zhangjia on 14/12/25.
//  Copyright (c) 2014年 wanmei. All rights reserved.
//

#import "TableTextView.h"

@implementation TableTextView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
}

-(float)rowHeight
{
    if (_rowHeight == 0) {
        _rowHeight = 30;
    }
    
    return _rowHeight;
}

-(UIColor *)tableBorderColor
{
    if (!_tableBorderColor) {
        _tableBorderColor = [UIColor blackColor];
    }
    
    return _tableBorderColor;
}

-(float)tableBorderWidth
{
    if (_tableBorderWidth == 0) {
        _tableBorderWidth = 1;
    }
    
    return _tableBorderWidth;
}

-(UIColor *)tableBackgroundColor
{
    if (!_tableBackgroundColor) {
        _tableBackgroundColor = [UIColor blackColor];
    }
    
    return _tableBackgroundColor;
}

-(NSInteger)numberOfRow
{
    if (_numberOfRow == 0) {
        _numberOfRow = 1;
    }
    
    return _numberOfRow;
}

-(NSInteger)numberOfList
{
    if (_numberOfList == 0) {
        _numberOfList = 3;
    }
    
    return _numberOfList;
}

-(float)titleFontSize
{
    if (_titleFontSize == 0) {
        _titleFontSize = 14.f;
    }
    
    return _titleFontSize;
}

-(void)loadTableTextView
{
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // 格子线条颜色
    CGContextSetStrokeColorWithColor(context, self.tableBorderColor.CGColor);
    CGContextBeginPath(context);
    
    NSInteger numRows = self.numberOfRow;
    NSInteger numList = self.numberOfList;
    
    float gridLeft = self.leftMargin;
    float gridTop = 0;
    
    float tableWide = self.width-self.leftMargin-self.rightMargin;
    float gridWidth = tableWide/numList;
    float gridHeight = self.rowHeight;
    float gridTotalHeight = numRows*gridHeight;
    
    // 背景色
    for (int i = 0; i < numRows; i++) {
        
        CGRect rectangleGrid = CGRectMake(gridLeft,gridTop+gridHeight*i,tableWide,gridHeight);
        CGContextAddRect(context, rectangleGrid);
        CGContextSetFillColorWithColor(context, self.tableBackgroundColor.CGColor);
        CGContextFillPath(context);
    }
    
    
    //画格
    int tableNum = MAX(numRows, numList);
    
    for (int i = 0; i < tableNum+1; i++) {
        //columns 列
        if (i <= numList+1)
        {
            CGContextMoveToPoint(context, gridLeft+i*gridWidth, gridTop);
            CGContextAddLineToPoint(context, gridLeft+i*gridWidth, gridTop+gridTotalHeight);
        }
        
        if (i <= numRows+1)
        {
            //rows 行
            CGContextMoveToPoint(context, gridLeft, gridTop+i*gridHeight);
            CGContextAddLineToPoint(context, gridLeft+tableWide, gridTop+i*gridHeight);
        }
    }
    
    CGContextStrokePath(context);
    CGContextSetAllowsAntialiasing(context, YES);
    
    //填充内容
    NSInteger gridNum = numRows * numList;
    for (int i = 0; i < gridNum; i ++) {
        int targetColumn = i%numList;
        int targetRow = i/numList;
        int targetX = gridLeft + targetColumn * gridWidth;
        int targetY =  gridTop + targetRow * gridHeight + (gridHeight-self.titleFontSize)/2;
        
        NSString *gridStr = @"";
        if (self.textAtIndexWithTable) {
            gridStr = self.textAtIndexWithTable(targetRow,targetColumn);
        }
        
        UIColor *fontColor = [UIColor blackColor];
        if (self.textColorAtIndexWithTable) {
            fontColor = self.textColorAtIndexWithTable(targetRow,targetColumn);
        }
        
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >=7.0) {
            
            NSMutableParagraphStyle *textStyle = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
            textStyle.lineBreakMode = NSLineBreakByWordWrapping;
            textStyle.alignment = NSTextAlignmentCenter;
            
            [gridStr drawInRect:CGRectMake(targetX, targetY, gridWidth, gridHeight) withAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:self.titleFontSize],NSForegroundColorAttributeName:fontColor,NSParagraphStyleAttributeName:textStyle}];
        }
        else
        {
            [gridStr drawInRect:CGRectMake(targetX, targetY, gridWidth, gridHeight) withFont:[UIFont systemFontOfSize:self.titleFontSize] lineBreakMode:NSLineBreakByClipping alignment:NSTextAlignmentCenter];
            
            CGContextSetFillColorWithColor(context,fontColor.CGColor);
        }
        
    }
}


@end
