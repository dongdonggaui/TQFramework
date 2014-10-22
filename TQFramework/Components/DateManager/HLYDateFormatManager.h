//
//  HLYDateFormatManager.h
//  HLYPullToRefreshManager
//
//  Created by huangluyang on 14-8-24.
//  Copyright (c) 2014年 huangluyang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HLYDateFormatManager : NSObject

+ (instancetype)sharedInstance;

/**
 *  按时间的流逝格式获取时间
 *
 *  @param date 需要转换格式的时间戳
 *
 *  @return 相应格式的时间字符串
 */
- (NSString *)lapseTimeFormatFromDate:(NSDate *)date;

/**
 *  yyyy-MM-dd HH:mm:ss 格式显示时间
 *
 *  @param date 需要转换格式的时间戳
 *
 *  @return 相应格式的时间字符串
 */
- (NSString *)longDisplayStringFromDate:(NSDate *)date;

@end
