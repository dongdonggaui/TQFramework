//
//  UITableViewCell+BackgroundShadow.h
//  Hiweido
//
//  Created by huangluyang on 14/10/28.
//  Copyright (c) 2014年 huangluyang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableViewCell (BackgroundShadow)

- (void)tq_addBackgroundShadow;

- (void)tq_addBackgroundShadowWithTop:(NSNumber *)top
                                 left:(NSNumber *)left
                               bottom:(NSNumber *)bottom
                                right:(NSNumber *)right;

@end
