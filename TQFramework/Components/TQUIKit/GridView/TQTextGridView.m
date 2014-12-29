//
//  TQTextGridView.m
//  Hiweido
//
//  Created by huangluyang on 14/11/16.
//  Copyright (c) 2014年 huangluyang. All rights reserved.
//

#import "TQTextGridView.h"
#import "UIView+Frame.h"

@implementation TQTextGridView

- (void)setTexts:(NSArray *)texts
{
    _texts = texts;
    
    NSMutableArray *contentViews = [NSMutableArray arrayWithCapacity:texts.count];
    for (NSString *text in texts) {
        TQTextGridContentView *contentView = [[TQTextGridContentView alloc] initWithFrame:CGRectZero];
        contentView.textLabel.text = text;
        [contentViews addObject:contentView];
    }
    self.gridCotentViews = contentViews;
    
    [self setNeedsLayout];
}

@end

//////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////

@implementation TQTextGridContentView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        _textLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _textLabel.backgroundColor = [UIColor clearColor];
        _textLabel.textAlignment = NSTextAlignmentCenter;
        
        [self addSubview:_textLabel];
    }
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.textLabel.frame = self.bounds;
}

- (void)prepareForResuse
{
    self.textLabel.text = nil;
}

@end