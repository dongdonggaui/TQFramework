//
//  HLYThemeManager.m
//  TQFramework
//
//  Created by huangluyang on 14-8-25.
//  Copyright (c) 2014年 huangluyang. All rights reserved.
//

#import "HLYThemeManager.h"
#import <UIColor+Hex.h>
#import <UIImage+ImageWithColor.h>

static NSString * const TQThemeManagerUserDefaultsKey = @"com.hly.userdefaults.thememanager";

NSString * const TQThemeManagerDidChangeThemeNotification = @"com.hly.thememanager.notification.didchangetheme";

@interface HLYThemeManager ()

@property (nonatomic, strong) NSString *currentThemeName;
@property (nonatomic, strong) NSString *currentThemePath;
@property (nonatomic, strong) NSDictionary *currentThemeColorPlist;
@property (nonatomic, strong) NSMutableDictionary *currentThemeColors;

@end

@implementation HLYThemeManager

+ (instancetype)sharedInstance
{
    static HLYThemeManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!sharedManager) {
            sharedManager = [[HLYThemeManager alloc] init];
            sharedManager.currentThemeColors = [NSMutableDictionary dictionaryWithCapacity:16];
        }
    });
    
    return sharedManager;
}

#pragma mark -
#pragma mark - public
- (void)configuration
{
    NSString *themeName = [[NSUserDefaults standardUserDefaults] stringForKey:TQThemeManagerUserDefaultsKey];
    if (themeName) {
        [self useTheme:themeName];
    } else {
        [self userDefaultTheme];
    }
}

- (void)useTheme:(NSString *)themeName
{
    if ([themeName isEqualToString:self.currentThemeName]) {
        return;
    }
    
    self.currentThemeName = themeName;
    self.currentThemePath = [[self localThemePath] stringByAppendingPathComponent:themeName];
    
    [self.currentThemeColors removeAllObjects];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:TQThemeManagerDidChangeThemeNotification object:nil];
}

- (UIImage *)imageNamed:(NSString *)iamgeName
{
    NSString *imagePath = [[self currentThemePath] stringByAppendingPathComponent:iamgeName];
    
    return [UIImage imageWithContentsOfFile:imagePath];
}

- (UIImage *)placeholderImage1
{
    return [UIImage imageWithColor:[UIColor yellowColor]];
}

- (UIImage *)placeholderImage2
{
    return nil;
}

- (UIImage *)placeholderImage3
{
    return nil;
}

- (UIImage *)placeholderImage4
{
    return nil;
}

- (UIImage *)placeholderImage5
{
    return nil;
}

- (UIColor *)numberOneColor
{
    return [self colorWithIndex:1];
}

- (UIColor *)numberTwoColor
{
    return [self colorWithIndex:2];
}

- (UIColor *)numberThreeColor
{
    return [self colorWithIndex:3];
}

- (UIColor *)numberFourColor
{
    return [self colorWithIndex:4];
}

- (UIColor *)numberFiveColor
{
    return [self colorWithIndex:5];
}

- (UIColor *)numbersixColor
{
    return [self colorWithIndex:6];
}

- (UIColor *)numberSevenColor
{
    return [self colorWithIndex:7];
}

- (UIColor *)numberEightColor
{
    return [self colorWithIndex:8];
}

- (UIColor *)numberNineColor
{
    return [self colorWithIndex:9];
}

- (UIColor *)numberTenColor
{
    return [self colorWithIndex:10];
}

- (UIColor *)numberElevenColor
{
    return [self colorWithIndex:11];
}

- (UIColor *)numberTwelveColor
{
    return [self colorWithIndex:12];
}

- (UIColor *)numberThirteenColor
{
    return [self colorWithIndex:13];
}

- (UIColor *)numberFourteenColor
{
    return [self colorWithIndex:14];
}

- (UIColor *)numberFifteenColor
{
    return [self colorWithIndex:15];
}

- (UIColor *)numberSixTeenColor
{
    return [self colorWithIndex:16];
}

- (UIFont *)fontWithPixel:(CGFloat)pixel
{
    return [UIFont systemFontOfSize:[self pointFromPixel:pixel]];
}

- (UIFont *)boldFontWithPixel:(CGFloat)pixel
{
    return [UIFont boldSystemFontOfSize:[self pointFromPixel:pixel]];
}

- (CGFloat)pointFromPixel:(CGFloat)pixel
{
    return ceilf(pixel * 88 * 1. / 96);
}

#pragma mark -
#pragma mark - private
- (void)userDefaultTheme
{
    self.currentThemeName = @"Default";
    self.currentThemePath = [[NSBundle mainBundle] bundlePath];
    self.currentThemeColorPlist = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"HWDColors" ofType:@"plist"]];
}

- (NSString *)localThemePath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [paths lastObject];
    path = [path stringByAppendingPathComponent:@"themes"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
        NSError *error = nil;
        BOOL success = [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&error];
        if (success) {
            return path;
        } else {
//            LoggerError(0, @"create error --> %@", error);
        }
    }
    
    return nil;
}

- (UIColor *)colorWithIndex:(NSInteger)index
{
    if (!self.currentThemeColorPlist) {
        return nil;
    }
    
    NSString *colorKey = [NSString stringWithFormat:@"%d", index];
    if ([self.currentThemeColors objectForKey:colorKey]) {
        return [self.currentThemeColors objectForKey:colorKey];
    }
    
    NSString *colorString = [self.currentThemeColorPlist objectForKey:colorKey];
    if (!colorString) {
        return nil;
    }
    
    NSInteger hex = 0;
    NSRange range;
    range.length = 1;
    range.location = 0;
    NSInteger length = colorString.length;
    NSDictionary *dic = @{@"1": @(1), @"2": @(2), @"3": @(3), @"4": @(4),
                          @"5": @(5), @"6": @(6), @"7": @(7), @"8": @(8),
                          @"9": @(9), @"a": @"10", @"b": @"11", @"c": @"12",
                          @"d": @"13", @"e": @"14", @"f": @"15", @"0": @(0)};
    while (range.location < length) {
        NSInteger bitNumber = [[dic objectForKey:[colorString substringWithRange:range]] integerValue];
        NSInteger temp = bitNumber * pow(16, length - range.location - 1);
        hex += temp;
//        NSLog(@"bit --> %@, bit number --> %d, temp --> %d", [colorString substringWithRange:range], bitNumber, temp);
        range.location++;
    }
//    NSLog(@"hex --> %@, decimal --> %d", colorString, hex);
    
    UIColor *color = [UIColor colorWithHex:hex];
    
    [self.currentThemeColors setObject:color forKey:colorKey];
    
    return color;
}

@end
