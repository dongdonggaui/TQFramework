//
//  UIImage+Convenience.m
//  Haoweidao
//
//  Created by huangluyang on 13-12-27.
//  Copyright (c) 2013年 whu. All rights reserved.
//

#import "UIImage+Convenience.h"

@implementation UIImage (Convenience)

+ (instancetype)HLY_defaultAvatar
{
    return [UIImage imageNamed:@"avatar_placehold"];
}

+ (instancetype)HLY_placeholderDefault
{
    return [UIImage imageNamed:@"entertainment_default"];
}

+ (instancetype)HLY_placeholder1
{
    return [UIImage imageNamed:@"food_default"];
}

+ (instancetype)HLY_placeholder2
{
    return [UIImage imageNamed:@"hotel_default"];
}

+ (instancetype)HLY_placeholder3
{
    return [UIImage imageNamed:@"entertainment_default"];
}

+ (instancetype)HLY_placeholderSmall
{
    return [UIImage imageNamed:@"loading_small"];
}

+ (instancetype)HLY_placeholderBig
{
    return [UIImage imageNamed:@"loading_big"];
}

+ (instancetype)HLY_placeholderTall
{
    return [UIImage imageNamed:@"loading_480"];
}

+ (instancetype)HLY_errorImage
{
    return [UIImage imageNamed:@"avatar_placehold"];
}

@end
