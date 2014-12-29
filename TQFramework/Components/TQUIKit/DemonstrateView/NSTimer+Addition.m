//
//  NSTimer+Addition.m
//  TQFramework
//
//  Created by huangluyang on 14-1-24.
//  Copyright (c) 2014年 huangluyang. All rights reserved.
//

#import "NSTimer+Addition.h"

@implementation NSTimer (Addition)

-(void)tq_pauseTimer
{
    if (![self isValid]) {
        return ;
    }
    [self setFireDate:[NSDate distantFuture]];
}


-(void)tq_resumeTimer
{
    if (![self isValid]) {
        return ;
    }
    [self setFireDate:[NSDate date]];
}

- (void)tq_resumeTimerAfterTimeInterval:(NSTimeInterval)interval
{
    if (![self isValid]) {
        return ;
    }
    [self setFireDate:[NSDate dateWithTimeIntervalSinceNow:interval]];
}

@end
