//
//  HLYImageCache.m
//  Haoweidao
//
//  Created by huangluyang on 14-3-24.
//  Copyright (c) 2014年 whu. All rights reserved.
//

#import <NSLogger.h>
#import "HLYImageCache.h"
#import "NSString+Encrypt.h"

//static const NSString *kImageBaseUrl = @"http://hiwedo.oss-cn-hangzhou.aliyuncs.com";

static const NSString *kImageCacheVersion = @"kImageCacheVersion";
static const NSInteger kImageStaleSeconds = 30 * 24 * 3600;

@implementation HLYImageCache

static NSMutableDictionary *memoryCache;
static NSMutableArray *recentlyAccessedKeys;
static int kCacheMemoryLimit;

+ (void)initialize
{
    NSString *cacheDirectory = [HLYImageCache cacheDirectory];
    if(![[NSFileManager defaultManager] fileExistsAtPath:cacheDirectory])
    {
        [[NSFileManager defaultManager] createDirectoryAtPath:cacheDirectory
                                  withIntermediateDirectories:YES
                                                   attributes:nil
                                                        error:nil];
    }
    
    double lastSavedCacheVersion = [[NSUserDefaults standardUserDefaults] doubleForKey:(NSString *)kImageCacheVersion];
    double currentAppVersion = [[HLYImageCache appVersion] doubleValue];
    
    if( lastSavedCacheVersion == 0.0f || lastSavedCacheVersion < currentAppVersion)
    {
        // assigning current version to preference
        [HLYImageCache clearCache];
        
        [[NSUserDefaults standardUserDefaults] setDouble:currentAppVersion forKey:(NSString *)kImageCacheVersion];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    memoryCache = [[NSMutableDictionary alloc] init];
    recentlyAccessedKeys = [[NSMutableArray alloc] init];
    
    // you can set this based on the running device and expected cache size
    kCacheMemoryLimit = 20;
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(saveMemoryCacheToDisk:) name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(saveMemoryCacheToDisk:) name:UIApplicationDidEnterBackgroundNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(saveMemoryCacheToDisk:) name:UIApplicationWillTerminateNotification object:nil];
}

+ (void)dealloc
{
    memoryCache = nil;
    
    recentlyAccessedKeys = nil;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidEnterBackgroundNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillTerminateNotification object:nil];
    
}

#pragma mark -
#pragma mark - pbulic

+ (void)cacheImage:(UIImage *)image withEntityName:(NSString *)entityName
{
    NSString *key = [entityName HLY_md5Lowercase];
//    if (entityName.length < kImageBaseUrl.length) {
//        return;
//    }
//    NSString *key = [entityName substringFromIndex:kImageBaseUrl.length];
//    if ([key hasPrefix:@"/"]) {
//        key = [key substringFromIndex:1];
//    } else {
//        key = [key substringFromIndex:8];
//    }
//    NSString *file = [NSString stringWithFormat:@"%@.jpg", key];
//    key = [key stringByReplacingOccurrencesOfString:@"/" withString:@"_"];
    [self cacheData:UIImageJPEGRepresentation(image, 1)
             toFile:key];
}

+ (UIImage *)fetchCachedImageForEntity:(NSString *)entityName
{
    NSString *key = [entityName HLY_md5Lowercase];
//    if (entityName.length < kImageBaseUrl.length) {
//        return nil;
//    }
//    NSString *key = [entityName substringFromIndex:kImageBaseUrl.length];
//    if ([key hasPrefix:@"/"]) {
//        key = [key substringFromIndex:1];
//    } else {
//        key = [key substringFromIndex:8];
//    }
//    NSString *file = [NSString stringWithFormat:@"%@.jpg", key];
//    key = [key stringByReplacingOccurrencesOfString:@"/" withString:@"_"];
//    DLog(@"path = \n%@\n, key = \n %@\n", entityName, key);
    NSData *data = [self dataForFile:key];
    if (data) {
        return [UIImage imageWithData:data];
    }
    
    return nil;
}

+ (NSString *)appVersion
{
	CFStringRef versStr = (CFStringRef)CFBundleGetValueForInfoDictionaryKey(CFBundleGetMainBundle(), kCFBundleVersionKey);
	NSString *version = [NSString stringWithUTF8String:CFStringGetCStringPtr(versStr,kCFStringEncodingMacRoman)];
	
	return version;
}

+ (NSString *)cacheDirectory
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachesDirectory = [paths lastObject];
    NSString *imageCache = [cachesDirectory stringByAppendingPathComponent:@"HWDImageCache"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:imageCache]) {
        NSError *error = nil;
        [[NSFileManager defaultManager] createDirectoryAtPath:imageCache withIntermediateDirectories:YES attributes:nil error:&error];
        if (error) {
            LoggerError(1, @"create error --> %@", error);
        }
    }
	return imageCache;
}

+ (BOOL)isImageStaleForEntity:(NSString *)entityName
{
    // if it is in memory cache, it is not stale
    NSString *key = [entityName HLY_md5Lowercase];
    if([recentlyAccessedKeys containsObject:[NSString stringWithFormat:@"%@.archive", key]])
        return NO;
    
	NSString *archivePath = [[HLYImageCache cacheDirectory] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.archive", entityName]];
    
    NSTimeInterval stalenessLevel = [[[[NSFileManager defaultManager] attributesOfItemAtPath:archivePath error:nil] fileModificationDate] timeIntervalSinceNow];
    
    return stalenessLevel > kImageStaleSeconds;
}

#pragma mark -
#pragma mark - private

+ (void)cacheData:(NSData*)data toFile:(NSString*)fileName
{
    [memoryCache setObject:data forKey:fileName];
    if([recentlyAccessedKeys containsObject:fileName])
    {
        [recentlyAccessedKeys removeObject:fileName];
    }
    
    [recentlyAccessedKeys insertObject:fileName atIndex:0];
    
    if([recentlyAccessedKeys count] > kCacheMemoryLimit)
    {
        NSString *leastRecentlyUsedDataFilename = [recentlyAccessedKeys lastObject];
        NSData *leastRecentlyUsedCacheData = [memoryCache objectForKey:leastRecentlyUsedDataFilename];
        NSString *archivePath = [[HLYImageCache cacheDirectory] stringByAppendingPathComponent:leastRecentlyUsedDataFilename];
        BOOL rect = [leastRecentlyUsedCacheData writeToFile:archivePath atomically:YES];
        NSLog(@"write path --> %@, success --> %@", archivePath, rect ? @"YES" : @"NO");
        
        [recentlyAccessedKeys removeLastObject];
        [memoryCache removeObjectForKey:leastRecentlyUsedDataFilename];
    }
}

+ (NSData *)dataForFile:(NSString*)fileName
{
    NSData *data = [memoryCache objectForKey:fileName];
    if(data)
        return data; // data is present in memory cache
    
	NSString *archivePath = [[HLYImageCache cacheDirectory] stringByAppendingPathComponent:fileName];
    data = [NSData dataWithContentsOfFile:archivePath];
    
    if(data)
        [self cacheData:data toFile:fileName]; // put the recently accessed data to memory cache
    
    return data;
}

+ (void)saveMemoryCacheToDisk:(NSNotification *)notification
{
    NSLog(@"image cache did receive notification --> %@", notification.name);
    for(NSString *filename in [memoryCache allKeys])
    {
        NSString *archivePath = [[HLYImageCache cacheDirectory] stringByAppendingPathComponent:filename];
        NSData *cacheData = [memoryCache objectForKey:filename];
        [cacheData writeToFile:archivePath atomically:YES];
    }
    
    [memoryCache removeAllObjects];
}

+ (void)clearCache
{
    NSArray *cachedItems = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:[HLYImageCache cacheDirectory] error:nil];
    
    for(NSString *path in cachedItems)
        [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
    
    [memoryCache removeAllObjects];
}


@end
