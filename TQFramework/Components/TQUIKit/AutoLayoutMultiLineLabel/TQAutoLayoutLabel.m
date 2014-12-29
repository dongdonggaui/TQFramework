//
//  TQAutoLayoutMultiLineLabel.m
//  laohu-dota-assistant
//
//  Created by huangluyang on 14/12/11.
//  Copyright (c) 2014年 wanmei. All rights reserved.
//

#import "TQAutoLayoutLabel.h"

@implementation TQAutoLayoutLabel

- (void)dealloc
{
    [self removeObserver:self forKeyPath:@"preferredMaxLayoutWidth"];
}

- (instancetype)init
{
    if (self = [super init]) {
        [self addObserver:self forKeyPath:@"preferredMaxLayoutWidth" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    }
    
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self addObserver:self forKeyPath:@"preferredMaxLayoutWidth" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
}

- (CGSize)intrinsicContentSize
{
    CGSize size = [super intrinsicContentSize];
    
    size.width = self.preferredMaxLayoutWidth;
    
    return size;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (object == self && [keyPath isEqualToString:@"preferredMaxLayoutWidth"]) {
        CGFloat theNewWidth = [[change objectForKey:NSKeyValueChangeNewKey] floatValue];
        CGFloat theOldWidth = [[change objectForKey:NSKeyValueChangeOldKey] floatValue];
        if (theNewWidth != theOldWidth) {
            [self invalidateIntrinsicContentSize];
        }
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

@end
