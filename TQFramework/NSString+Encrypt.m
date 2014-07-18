//
//  NSString+Encrypt.m
//  WanmeiAD
//
//  Created by huangluyang on 14-7-4.
//  Copyright (c) 2014年 huangluyang. All rights reserved.
//

#import <CommonCrypto/CommonCrypto.h>
#import "NSString+Encrypt.h"

@implementation NSString (Encrypt)

- (NSString *)HLY_md5Lowercase
{
    const char *cStr = [self UTF8String];
    unsigned char result[16];
    
    CC_MD5(cStr, strlen(cStr), result);
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}

- (NSString *)HLY_md5Uppercase
{
    const char *cStr = [self UTF8String];
    unsigned char result[16];
    
    CC_MD5(cStr, strlen(cStr), result);
    return [NSString stringWithFormat:
            @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}

- (NSString *)HLY_base64
{
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    
    NSString *base64 = [UIDevice currentDevice].systemVersion.floatValue < 7 ? [data base64Encoding] : [data base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
    
    return base64;
}

@end
