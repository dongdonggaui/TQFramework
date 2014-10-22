//
//  UIView+Frame.h
//  HuangLuyang
//
//  Created by huangluyang on 14-7-14.
//  Copyright (c) 2014年 huangluyang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Frame)

- (CGFloat)hly_top;
- (CGFloat)hly_bottom;
- (CGFloat)hly_left;
- (CGFloat)hly_right;
- (CGFloat)hly_centerX;
- (CGFloat)hly_centerY;

- (CGFloat)hly_width;
- (CGFloat)hly_height;

- (void)hly_setTop:(CGFloat)top;
- (void)hly_setBottom:(CGFloat)bottom;
- (void)hly_setLeft:(CGFloat)left;
- (void)hly_setRight:(CGFloat)right;
- (void)hly_setCenterX:(CGFloat)centerX;
- (void)hly_setCenterY:(CGFloat)centerY;

- (void)hly_setWidth:(CGFloat)width;
- (void)hly_setHeight:(CGFloat)height;

@end
