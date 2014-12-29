//
//  TQSimpleGridView.h
//  Hiweido
//
//  Created by huangluyang on 14/11/16.
//  Copyright (c) 2014年 huangluyang. All rights reserved.
//

#import "TQGridView.h"

/**
 *  带图片与文本的grid view
 */
@interface TQSimpleGridView : TQGridView

@property (nonatomic, strong) NSArray *entities;

@end

//////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////

@interface TQSimpleGridContentView : TQGridViewContentView

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *textLabel;

- (void)prepareForResuse;

@end

//////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////

@interface TQSimpleGridContentViewEntity : NSObject

@property (nonatomic, strong) NSString *imagePath;
@property (nonatomic, strong) UIImage *placeholder;
@property (nonatomic, strong) NSString *title;

@end