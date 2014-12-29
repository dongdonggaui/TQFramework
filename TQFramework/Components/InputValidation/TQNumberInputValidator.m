//
//  TQNumberInputValidator.m
//  Hiweido
//
//  Created by huangluyang on 14/11/20.
//  Copyright (c) 2014年 huangluyang. All rights reserved.
//

#import "TQNumberInputValidator.h"

@implementation TQNumberInputValidator

- (NSString *)regex
{
    return @"^[0-9]+(.[0-9]{0,2})?$";
}

- (NSString *)failedReason
{
    return NSLocalizedString(@"只能包含数字", @"只能包含数字");
}

- (NSUInteger)failedCode
{
    return 1002;
}

@end
