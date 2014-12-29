//
//  TQTextField.m
//  Hiweido
//
//  Created by huangluyang on 14-9-27.
//  Copyright (c) 2014年 huangluyang. All rights reserved.
//

#import "TQTextField.h"
#import "TQInputValidator.h"

@implementation TQTextField

- (BOOL)validate
{
    return [self validateWithPrompt:nil];
}

- (BOOL)validateWithPrompt:(NSString *)prompt
{
    NSError *error = nil;
    BOOL validateResult = [self.inputValidator validateInput:self error:&error];
    if (!validateResult) {
        NSString *reason = [error.userInfo objectForKey:NSLocalizedFailureReasonErrorKey];
        NSString *msg = prompt ? [NSString stringWithFormat:@"%@：%@", prompt, reason] : reason;
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:msg delegate:nil cancelButtonTitle:NSLocalizedString(@"确定", @"确定") otherButtonTitles:nil];
        [alert show];
    }
    
    return validateResult;
}

@end
