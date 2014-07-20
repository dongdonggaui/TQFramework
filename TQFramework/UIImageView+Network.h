//
//  UIImageView+Network.h
//  DaBanShi
//
//  Created by huangluyang on 14-3-13.
//  Copyright (c) 2014年 huangluyang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (Network)

- (void)HLY_loadNetworkImageAtPath:(NSString *)imagePath withPlaceholder:(UIImage *)placeholder errorImage:(UIImage *)errorImage activityIndicator:(UIActivityIndicatorView *)juhua;
- (void)HLY_loadNetworkImageAtPath:(NSString *)imagePath;

@end
