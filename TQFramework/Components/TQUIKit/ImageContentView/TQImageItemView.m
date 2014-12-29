//
//  TQImageItemView.m
//  laohu-dota-assistant
//
//  Created by zhangjia on 14/12/22.
//  Copyright (c) 2014年 wanmei. All rights reserved.
//

#import "TQImageItemView.h"

@implementation TQImageItemView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


- (id)initWithFrame:(CGRect)frame contentType:(TQImageContentType)contentType{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        self.imageView = [[UIImageView alloc]initWithFrame:CGRectZero];
        self.imageView.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:self.imageView];
        
        self.titleLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        self.titleLabel.numberOfLines = 2;
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:self.titleLabel];
        // Constrain
        NSDictionary *viewDict = NSDictionaryOfVariableBindings(_imageView, _titleLabel);
        
        // Constrain elements horizontally
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_imageView]-0-|" options:0 metrics:nil views:viewDict]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_titleLabel]-0-|" options:0 metrics:nil views:viewDict]];
        
        // Constrain elements vertically·
        if (contentType == TQImageContentTitleAboveImage) {
            [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_imageView]-0-|" options:0 metrics:nil views:viewDict]];
            [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_titleLabel(15)]-0-|" options:0 metrics:nil views:viewDict]];
        }else{
            [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_imageView]-0-[_titleLabel(>=0)]-0-|" options:0 metrics:nil views:viewDict]];
        }
        
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_imageView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:_imageView attribute:NSLayoutAttributeWidth multiplier:1 constant:0]];
    }
    return self;
}

-(void)cancelCurrentImageLoad
{
    [self.imageView sd_cancelCurrentImageLoad];
}

@end
