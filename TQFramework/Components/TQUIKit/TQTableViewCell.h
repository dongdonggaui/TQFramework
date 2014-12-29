//
//  TQTableViewCell.h
//  Hiweido
//
//  Created by huangluyang on 14/10/28.
//  Copyright (c) 2014年 huangluyang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TQTableViewCell : UITableViewCell

@property (nonatomic, strong) UIColor *separatorLineColor;
@property (nonatomic, unsafe_unretained) BOOL showTopSeparatorLine;
@property (nonatomic, unsafe_unretained) BOOL showBottomSeparatorLine;
@property (nonatomic, unsafe_unretained) CGFloat separatorLineSize;
@property (nonatomic, unsafe_unretained) CGFloat separatorLineLeftInsets;
@property (nonatomic, unsafe_unretained) CGFloat separatorLineRightInsets;

@end
