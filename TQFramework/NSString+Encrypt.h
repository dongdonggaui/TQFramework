//
//  NSString+Encrypt.h
//  WanmeiAD
//
//  Created by huangluyang on 14-7-4.
//  Copyright (c) 2014年 huangluyang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Encrypt)

- (NSString *)HLY_md5Lowercase;
- (NSString *)HLY_md5Uppercase;
- (NSString *)HLY_base64;

@end
