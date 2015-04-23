//
//  BaseViewController+Share.h
//  laohu
//
//  Created by huangluyang on 14/10/22.
//  Copyright (c) 2014年 wanmei. All rights reserved.
//

#import <UIKit/UIkit.h>

@interface UIViewController (Share)

- (void)tq_showShareChooserWithTitle:(NSString *)title
                              detail:(NSString *)detail
                               image:(UIImage *)image
                            imageUrl:(NSURL *)imageUrl
                         relativeUrl:(NSURL *)relativeUrl
                      tappedCallback:(void (^)())tappedCallback;

@end
