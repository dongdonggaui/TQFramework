//
//  NSDate+Display.m
//  HuangLuyang
//
//  Created by huangluyang on 14-7-17.
//  Copyright (c) 2014年 huangluyang. All rights reserved.
//

#import "NSDate+Display.h"

@implementation NSDate (Display)

- (NSString *)HLY_shortDisplayFormat
{
    static NSDateFormatter *df = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!df) {
            df = [[NSDateFormatter alloc] init];
            df.dateFormat = @"yyyy-MM-dd";
        }
    });
    
    return [df stringFromDate:self];
}

@end
