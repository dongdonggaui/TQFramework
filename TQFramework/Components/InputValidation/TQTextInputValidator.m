//
//  TQTextInputValidator.m
//  Hiweido
//
//  Created by huangluyang on 14/11/20.
//  Copyright (c) 2014年 huangluyang. All rights reserved.
//

#import "TQTextInputValidator.h"

@implementation TQTextInputValidator

- (NSString *)regex
{
    return @"^[A-Za-z0-9]+$";
}

- (NSString *)failedReason
{
    return NSLocalizedString(@"只能包含英文字母和数字", @"只能包含英文字母和数字");
}

- (NSUInteger)failedCode
{
    return 1002;
}

@end
