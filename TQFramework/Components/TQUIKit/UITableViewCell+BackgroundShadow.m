//
//  UITableViewCell+BackgroundShadow.m
//  Hiweido
//
//  Created by huangluyang on 14/10/28.
//  Copyright (c) 2014年 huangluyang. All rights reserved.
//

#import "UITableViewCell+BackgroundShadow.h"

@implementation UITableViewCell (BackgroundShadow)

- (void)tq_addBackgroundShadow
{
    [self tq_addBackgroundShadowWithTop:nil left:nil bottom:nil right:nil];
}

- (void)tq_addBackgroundShadowWithTop:(NSNumber *)top left:(NSNumber *)left bottom:(NSNumber *)bottom right:(NSNumber *)right
{
    self.backgroundView = [[UIView alloc] initWithFrame:CGRectZero];
    self.backgroundView.backgroundColor = [UIColor whiteColor];
    self.backgroundView.layer.shadowColor = [UIColor grayColor].CGColor;
    self.backgroundView.layer.shadowOffset = CGSizeMake(0, 1);
    self.backgroundView.layer.shadowRadius = 1;
    self.backgroundView.layer.cornerRadius = 3.0f;
    self.backgroundView.layer.masksToBounds = YES;
    self.backgroundView.layer.shadowOpacity = 0.5;
    if ([UIDevice currentDevice].systemVersion.floatValue >= 8) {
        self.backgroundView.translatesAutoresizingMaskIntoConstraints = NO;
        NSDictionary *viewsDic = @{@"backgroundView": self.backgroundView};
        NSDictionary *metricsDic = @{@"top": top ? : @(4),
                                     @"left": left ? : @(8),
                                     @"bottom": bottom ? : @(4),
                                     @"right": right ? : @(8)};
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(left)-[backgroundView]-(right)-|" options:0 metrics:metricsDic views:viewsDic]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(top)-[backgroundView]-(bottom)-|" options:0 metrics:metricsDic views:viewsDic]];
        
        [self setNeedsUpdateConstraints];
    }
}

@end
