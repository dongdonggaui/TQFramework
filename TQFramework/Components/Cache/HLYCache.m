//
//  HLYCache.m
//  laohu
//
//  Created by huangluyang on 14-7-29.
//  Copyright (c) 2014年 wanmei. All rights reserved.
//

#import <CommonCrypto/CommonDigest.h>
#import "HLYCache.h"

static NSString* const kCacheVersion      = @"kCacheVersion";
static NSInteger const kCacheStaleSeconds = 30 * 24 * 3600;     // 设置缓存有效时间

@implementation HLYCache

static NSMutableDictionary *memoryCache;
static NSMutableArray *recentlyAccessedKeys;
static int kCacheMemoryLimit;

+ (void)initialize
{
    NSString *cacheDirectory = [self cacheDirectory];
    if(![[NSFileManager defaultManager] fileExistsAtPath:cacheDirectory])
    {
        [[NSFileManager defaultManager] createDirectoryAtPath:cacheDirectory
                                  withIntermediateDirectories:YES
                                                   attributes:nil
                                                        error:nil];
    }
    
    double lastSavedCacheVersion = [[NSUserDefaults standardUserDefaults] doubleForKey:kCacheVersion];
    double currentAppVersion = [[self appVersion] doubleValue];
    
    if( lastSavedCacheVersion == 0.0f || lastSavedCacheVersion < currentAppVersion)
    {
        // 升级后清除缓存
        [self clearCache];
        
        [[NSUserDefaults standardUserDefaults] setDouble:currentAppVersion forKey:kCacheVersion];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    // 设定内存缓存容量
    kCacheMemoryLimit = 30;
    
    memoryCache = [NSMutableDictionary dictionaryWithCapacity:kCacheMemoryLimit];
    recentlyAccessedKeys = [NSMutableArray arrayWithCapacity:kCacheMemoryLimit];
    
    // 注册系统通知
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

+ (void)cacheObject:(id)object withEntityName:(NSString *)entityName
{
    NSString *key = [self upperMd5FromString:entityName];
    
    [self cacheData:[NSKeyedArchiver archivedDataWithRootObject:object]
             toFile:key];
    [self updateRefreshDateForEntity:entityName];
}

+ (id)fetchCachedObjectForEntity:(NSString *)entityName
{
    NSString *key = [self upperMd5FromString:entityName];
    
    NSData *data = [self dataForFile:key];
    if (data) {
        return [NSKeyedUnarchiver unarchiveObjectWithData:data];
    }
    
    return nil;
}

+ (BOOL)needRefreshForEntity:(NSString *)entityName
{
    if (!entityName || entityName.length == 0) {
        return NO;
    }
    
    // 以每天凌晨为刷新时间点，凌晨之后未刷新过则需要刷新，否则不刷新
    NSDate *date = [[NSUserDefaults standardUserDefaults] objectForKey:entityName];
    if (!date) {
        return YES;
    }
    
    NSDate *now = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *nowComponents = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:now];
    
    // 获取当天凌晨时间
    NSDateComponents *starComponets = [[NSDateComponents alloc] init];
    starComponets.year = nowComponents.year;
    starComponets.month = nowComponents.month;
    starComponets.day = nowComponents.day;
    starComponets.hour = 0;
    starComponets.minute = 0;
    starComponets.second = 0;
    NSDate *startDate = [calendar dateFromComponents:starComponets];
    
    // 凌晨之后未刷新过
    if ([date timeIntervalSinceDate:startDate] < 0) {
        return YES;
    }
    
    return NO;
}

+ (void)updateRefreshDateForEntity:(NSString *)entityName
{
    if (!entityName || entityName.length == 0) {
        return;
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:entityName];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark -
#pragma mark - private

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
    NSString *imageCache = [cachesDirectory stringByAppendingPathComponent:@"LaohuCache"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:imageCache]) {
        NSError *error = nil;
        [[NSFileManager defaultManager] createDirectoryAtPath:imageCache withIntermediateDirectories:YES attributes:nil error:&error];
        if (error) {
            DLog(@"create error --> %@", error);
        }
    }
	return imageCache;
}

+ (BOOL)isCacheStaleForEntity:(NSString *)entityName
{
    // if it is in memory cache, it is not stale
    NSString *key = [self upperMd5FromString:entityName];
    if([recentlyAccessedKeys containsObject:[NSString stringWithFormat:@"%@.archive", key]])
        return NO;
    
	NSString *archivePath = [[self cacheDirectory] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.archive", entityName]];
    
    NSTimeInterval stalenessLevel = [[[[NSFileManager defaultManager] attributesOfItemAtPath:archivePath error:nil] fileModificationDate] timeIntervalSinceNow];
    
    return stalenessLevel > kCacheStaleSeconds;
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
        NSString *archivePath = [[self cacheDirectory] stringByAppendingPathComponent:leastRecentlyUsedDataFilename];
        BOOL rect = [leastRecentlyUsedCacheData writeToFile:archivePath atomically:YES];
        DLog(@"write path --> %@, success --> %@", archivePath, rect ? @"YES" : @"NO");
        
        [recentlyAccessedKeys removeLastObject];
        [memoryCache removeObjectForKey:leastRecentlyUsedDataFilename];
    }
}

+ (NSData *)dataForFile:(NSString*)fileName
{
    NSData *data = [memoryCache objectForKey:fileName];
    if(data)
        return data; // data is present in memory cache
    
	NSString *archivePath = [[self cacheDirectory] stringByAppendingPathComponent:fileName];
    data = [NSData dataWithContentsOfFile:archivePath];
    
    if(data)
        [self cacheData:data toFile:fileName]; // put the recently accessed data to memory cache
    
    return data;
}

+ (void)saveMemoryCacheToDisk:(NSNotification *)notification
{
    DLog(@"image cache did receive notification --> %@", notification.name);
    for(NSString *filename in [memoryCache allKeys])
    {
        NSString *archivePath = [[self cacheDirectory] stringByAppendingPathComponent:filename];
        NSData *cacheData = [memoryCache objectForKey:filename];
        [cacheData writeToFile:archivePath atomically:YES];
    }
    
    [memoryCache removeAllObjects];
}

+ (void)clearCache
{
    NSArray *cachedItems = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:[self cacheDirectory] error:nil];
    
    for(NSString *path in cachedItems)
        [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
    
    [memoryCache removeAllObjects];
}

+ (NSString*)upperMd5FromString:(NSString *)theString
{
    const char *str = [theString UTF8String];
    unsigned char result[16];
    CC_MD5(str, strlen(str), result);
    NSMutableString *hash = [NSMutableString string];
    for (int i = 0; i < 16; i++) {
        [hash appendFormat:@"%02X", result[i]];
    }
    return [hash uppercaseString];
}

@end
