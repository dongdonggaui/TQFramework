//
//  UIImageView+HWD.m
//  Haoweidao
//
//  Created by huangluyang on 14-3-13.
//  Copyright (c) 2014年 huangluyang. All rights reserved.
//

#import "UIImageView+AFNetworking.h"

#import "UIImageView+Network.h"
#import "UIImage+Convenience.h"
#import "HLYImageCache.h"

@implementation UIImageView (Network)

- (void)HLY_loadNetworkImageAtPath:(NSString *)imagePath withPlaceholder:(UIImage *)placeholder errorImage:(UIImage *)errorImage activityIndicator:(UIActivityIndicatorView *)juhua
{
    if (!imagePath) {
        self.image = placeholder;
        return;
    }
    if (juhua && [juhua isAnimating]) {
        [juhua stopAnimating];
    }
    // 本地图片
    UIImage *image = [UIImage imageNamed:imagePath];
    if (image) {
        self.image = image;
        return;
    }
    
    // 缓存图片
    image = [HLYImageCache fetchCachedImageForEntity:imagePath];
    if (image) {
        self.image = image;
        return;
    }
    
    // 加载网络图片
    NSURL *url = [NSURL URLWithString:imagePath];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    if (juhua && !juhua.isAnimating) {
        [juhua startAnimating];
    }
    
    if (placeholder) {
        self.image = placeholder;
    }
    
    __weak UIImageView *safeSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT , 0), ^{
        [safeSelf setImageWithURLRequest:request placeholderImage:placeholder success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                safeSelf.image = image;
                if (juhua != nil && juhua.isAnimating) {
                    [juhua stopAnimating];
                }
                
            });
            
            [HLYImageCache cacheImage:image withEntityName:imagePath];
            
        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                safeSelf.image = errorImage;
                if (juhua != nil && juhua.isAnimating) {
                    [juhua stopAnimating];
                }
            });
        }];
    });
    
}

- (void)HLY_loadNetworkImageAtPath:(NSString *)imagePath
{
    [self HLY_loadNetworkImageAtPath:imagePath withPlaceholder:[UIImage HLY_placeholderDefault] errorImage:[UIImage HLY_errorImage] activityIndicator:nil];
}

@end
