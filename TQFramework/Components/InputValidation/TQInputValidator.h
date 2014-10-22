//
//  TQInputValidator.h
//  Hiweido
//
//  Created by huangluyang on 14-9-27.
//  Copyright (c) 2014年 huangluyang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TQInputValidator : NSObject

- (BOOL)validateInput:(UITextField *)input error:(NSError **)error;

@end
