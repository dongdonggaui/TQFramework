//
//  UITextField+HitTest.m
//  laohu-dota-assistant
//
//  Created by huangluyang on 14/11/3.
//  Copyright (c) 2014年 wanmei. All rights reserved.
//

#import "UITextField+HitTest.h"

@implementation UITextField (HitTest)

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    BOOL flag = [super pointInside:point withEvent:event];
    
    if (!flag) {
        [self resignFirstResponder];
    }
    
    return flag;
}

@end
