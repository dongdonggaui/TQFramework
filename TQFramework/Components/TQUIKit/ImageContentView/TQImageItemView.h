//
//  TQImageItemView.h
//  laohu-dota-assistant
//
//  Created by zhangjia on 14/12/22.
//  Copyright (c) 2014年 wanmei. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSUInteger, TQImageContentType) {
    TQImageContentOnlyImage,//只有图片
    TQImageContentTitleBottomImage,//有标题和文字，文字在图片下面
    TQImageContentTitleAboveImage//有标题和文字，文字浮在图片上
};

@interface TQImageItemView : UIView

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *titleLabel;

- (id)initWithFrame:(CGRect)frame contentType:(TQImageContentType)contentType;
-(void)cancelCurrentImageLoad;
@end
