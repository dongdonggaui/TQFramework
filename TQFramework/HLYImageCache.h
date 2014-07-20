//
//  HLYImageCache.h
//  Haoweidao
//
//  Created by huangluyang on 14-3-24.
//  Copyright (c) 2014年 whu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HLYImageCache : NSObject

+ (void)cacheImage:(UIImage *)image withEntityName:(NSString *)entityName;
+ (UIImage *)fetchCachedImageForEntity:(NSString *)entityName;

@end
