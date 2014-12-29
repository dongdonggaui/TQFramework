//
//  TQInputValidator.m
//  Hiweido
//
//  Created by huangluyang on 14-9-27.
//  Copyright (c) 2014年 huangluyang. All rights reserved.
//

#import "TQInputValidator.h"

NSString * const TQInputValidationErrorDomain = @"tq.error.input";

@implementation TQInputValidator

- (BOOL)validateInput:(UITextField *)input error:(NSError **)error
{
    if (![self regex]) {
        *error = [NSError errorWithDomain:TQInputValidationErrorDomain code:1001 userInfo:@{NSLocalizedDescriptionKey: NSLocalizedString(@"内部错误", @"内部错误"),NSLocalizedFailureReasonErrorKey: NSLocalizedString(@"缺少验证规则", @"缺少验证规则")}];
                                                                                            
        return NO;
    }
    
    NSString *text = [input.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    NSError *regError = nil;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:[self regex] options:NSRegularExpressionAnchorsMatchLines error:&regError];
    NSUInteger numberOfMatches = [regex numberOfMatchesInString:text options:NSMatchingAnchored range:NSMakeRange(0, text.length)];
    
    if (numberOfMatches == 0) {
        NSString *description = [self failedDescription];
        NSString *reason = [self failedReason];
        NSArray *objArr = @[description, reason];
        NSArray *keyArr = @[NSLocalizedDescriptionKey, NSLocalizedFailureReasonErrorKey];
        
        NSDictionary *userInfo = [NSDictionary dictionaryWithObjects:objArr forKeys:keyArr];
        *error = [NSError errorWithDomain:TQInputValidationErrorDomain code:[self failedCode] userInfo:userInfo];
        
        return NO;
    }
    
    return YES;
}

- (NSString *)regex
{
    return nil;
}

- (NSString *)failedDescription
{
    return NSLocalizedString(@"输入验证失败", @"输入验证失败");
}

- (NSString *)failedReason
{
    return @"未知错误";
}

- (NSUInteger)failedCode
{
    return 1001;    // 内部错误
}

@end
