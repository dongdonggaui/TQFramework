//
//  TQSimpleGridView.m
//  Hiweido
//
//  Created by huangluyang on 14/11/16.
//  Copyright (c) 2014年 huangluyang. All rights reserved.
//

#import "TQSimpleGridView.h"
#import "UIView+Frame.h"
#import <UIImageView+WebCache.h>

@implementation TQSimpleGridView

- (void)setEntities:(NSArray *)entities
{
    _entities = entities;
    
    NSMutableArray *contentViews = [NSMutableArray arrayWithCapacity:entities.count];
    for (TQSimpleGridContentViewEntity *entity in entities) {
        TQSimpleGridContentView *contentView = [[TQSimpleGridContentView alloc] initWithFrame:CGRectZero];
        contentView.textLabel.text = entity.title;
        [contentView.imageView sd_setImageWithURL:[NSURL URLWithString:entity.imagePath] placeholderImage:entity.placeholder ? : [ThemeImage placeholderImage1]];
        
        [contentViews addObject:contentView];
    }
    
    self.gridCotentViews = contentViews;
}

@end


//////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////

@implementation TQSimpleGridContentView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.clipsToBounds = YES;
        [self addSubview:_imageView];
        
        _textLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _textLabel.backgroundColor = [UIColor clearColor];
        _textLabel.font = [UIFont systemFontOfSize:12];
        [self addSubview:_textLabel];
    }
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat centerX = ceilf([self hly_width] / 2);
    
    CGFloat imageWidth = [self hly_width];
    CGFloat imageHeight = imageWidth * 23 / 30.f;   // 固定宽高比
    
    [self.imageView hly_setHeight:imageHeight];
    [self.imageView hly_setWidth:imageWidth];
    [self.imageView hly_setCenterX:centerX];
    
//    [self.textLabel hly_setHeight:21];
//    [self.textLabel hly_setWidth:[self.imageView hly_width]];
    [self.textLabel sizeToFit];
    [self.textLabel hly_setTop:[self.imageView hly_bottom] + 4];
//    [self.textLabel hly_setBottom:[self hly_height]];
    [self.textLabel hly_setCenterX:centerX];
    
//    self.imageView.layer.cornerRadius = ceilf(imageWidth / 2);
}

- (void)prepareForResuse
{
    [self.imageView sd_cancelCurrentImageLoad];
    self.imageView.image = nil;
    self.textLabel.text = nil;
}

@end

//////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////

@implementation TQSimpleGridContentViewEntity

@end