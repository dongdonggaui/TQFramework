//
//  UIView+Frame.m
//  HuangLuyang
//
//  Created by huangluyang on 14-7-14.
//  Copyright (c) 2014年 huangluyang. All rights reserved.
//

#import "UIView+Frame.h"

@implementation UIView (Frame)

- (CGFloat)hly_top
{
    return self.frame.origin.y;
}

- (CGFloat)hly_bottom
{
    return self.frame.origin.y + self.frame.size.height;
}

- (CGFloat)hly_left
{
    return self.frame.origin.x;
}

- (CGFloat)hly_right
{
    return self.frame.origin.x + self.frame.size.width;
}

- (CGFloat)hly_centerX
{
    return self.center.x;
}

- (CGFloat)hly_centerY
{
    return self.center.y;
}

- (CGFloat)hly_width
{
    return self.frame.size.width;
}

- (CGFloat)hly_height
{
    return self.frame.size.height;
}

- (void)hly_setTop:(CGFloat)top
{
    CGRect frame = self.frame;
    frame.origin.y = top;
    self.frame = frame;
}

- (void)hly_setBottom:(CGFloat)bottom
{
    CGRect frame = self.frame;
    frame.origin.y = bottom - frame.size.height;
    self.frame = frame;
}

- (void)hly_setLeft:(CGFloat)left
{
    CGRect frame = self.frame;
    frame.origin.x = left;
    self.frame = frame;
}

- (void)hly_setRight:(CGFloat)right
{
    CGRect frame = self.frame;
    frame.origin.x = right - frame.size.width;
    self.frame = frame;
}

- (void)hly_setCenterX:(CGFloat)centerX
{
    CGPoint center = self.center;
    center.x = centerX;
    self.center = center;
}

- (void)hly_setCenterY:(CGFloat)centerY
{
    CGPoint center = self.center;
    center.y = centerY;
    self.center = center;
}

- (void)hly_setWidth:(CGFloat)width
{
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (void)hly_setHeight:(CGFloat)height
{
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

@end
