//
//  NSTimer+Addition.h
//  TQFramework
//
//  Created by huangluyang on 14-1-24.
//  Copyright (c) 2014年 huangluyang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSTimer (Addition)

- (void)tq_pauseTimer;
- (void)tq_resumeTimer;
- (void)tq_resumeTimerAfterTimeInterval:(NSTimeInterval)interval;
@end
