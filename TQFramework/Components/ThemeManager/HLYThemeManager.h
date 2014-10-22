//
//  HLYThemeManager.h
//  TQFramework
//
//  Created by huangluyang on 14-8-25.
//  Copyright (c) 2014年 huangluyang. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifndef ThemeImage
#define ThemeImage [HLYThemeManager sharedInstance]
#endif

#ifndef ThemeColor
#define ThemeColor [HLYThemeManager sharedInstance]
#endif

#ifndef ThemeFont
#define ThemeFont [HLYThemeManager sharedInstance]
#endif

@interface HLYThemeManager : NSObject

@property (nonatomic, strong, readonly) NSString *currentThemeName;
@property (nonatomic, strong, readonly) NSString *currentThemePath;

+ (instancetype)sharedInstance;

- (void)configuration;

- (void)useTheme:(NSString *)themeName;

- (UIImage *)imageNamed:(NSString *)iamgeName;

- (UIImage *)placeholderImage1;
- (UIImage *)placeholderImage2;
- (UIImage *)placeholderImage3;
- (UIImage *)placeholderImage4;
- (UIImage *)placeholderImage5;

- (UIColor *)numberOneColor;
- (UIColor *)numberTwoColor;
- (UIColor *)numberThreeColor;
- (UIColor *)numberFourColor;
- (UIColor *)numberFiveColor;
- (UIColor *)numbersixColor;
- (UIColor *)numberSevenColor;
- (UIColor *)numberEightColor;
- (UIColor *)numberNineColor;
- (UIColor *)numberTenColor;
- (UIColor *)numberElevenColor;
- (UIColor *)numberTwelveColor;
- (UIColor *)numberThirteenColor;
- (UIColor *)numberFourteenColor;
- (UIColor *)numberFifteenColor;
- (UIColor *)numberSixTeenColor;

- (UIFont *)fontWithPixel:(CGFloat)pixel;
- (UIFont *)boldFontWithPixel:(CGFloat)pixel;

- (CGFloat)pointFromPixel:(CGFloat)pixel;

@end

extern NSString * const TQThemeManagerDidChangeThemeNotification;