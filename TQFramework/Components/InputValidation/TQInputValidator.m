//
//  TQInputValidator.m
//  Hiweido
//
//  Created by huangluyang on 14-9-27.
//  Copyright (c) 2014年 huangluyang. All rights reserved.
//

#import "TQInputValidator.h"

@implementation TQInputValidator

- (BOOL)validateInput:(UITextField *)input error:(NSError **)error
{
    if (error) {
        *error = nil;
    }
    
    return NO;
}

@end
