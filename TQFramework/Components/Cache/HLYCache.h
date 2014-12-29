//
//  HLYCache.h
//  laohu
//
//  Created by huangluyang on 14-7-29.
//  Copyright (c) 2014年 wanmei. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  缓存工具类
 */
@interface HLYCache : NSObject

/**
 *  写缓存
 *
 *  @param object     缓存对象
 *  @param entityName 缓存对你标识符
 */
+ (void)cacheObject:(id)object withEntityName:(NSString *)entityName;

/**
 *  读缓存
 *
 *  @param entityName 缓存对象标识符
 *
 *  @return 已缓存的对象
 */
+ (id)fetchCachedObjectForEntity:(NSString *)entityName;

/**
 *  验证缓存对象是否有效，是否需要刷新，默认是每天自动刷新一次
 *
 *  @param entityName 缓存对象标识符
 *
 *  @return 缓存是否需要刷新
 */
+ (BOOL)needRefreshForEntity:(NSString *)entityName;

/**
 *  更新有效时间
 *
 *  @param entityName 缓存对象标识符
 */
+ (void)updateRefreshDateForEntity:(NSString *)entityName;

@end
