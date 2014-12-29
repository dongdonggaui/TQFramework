//
//  TQEmailInputValidator.m
//  Hiweido
//
//  Created by huangluyang on 14/11/20.
//  Copyright (c) 2014年 huangluyang. All rights reserved.
//

#import "TQEmailInputValidator.h"

@implementation TQEmailInputValidator

- (NSString *)regex
{
    return @"^[a-zA-Z0-9_+.-]+@([a-zA-Z0-9-]+.)+[a-zA-Z0-9]{2,4}$";
}

- (NSString *)failedReason
{
    return NSLocalizedString(@"邮箱格式不合法", @"邮箱格式不合法");
}

- (NSUInteger)failedCode
{
    return 1002;
}

@end
