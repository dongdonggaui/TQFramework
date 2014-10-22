//
//  TQTextField.h
//  Hiweido
//
//  Created by huangluyang on 14-9-27.
//  Copyright (c) 2014年 huangluyang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TQInputValidator;

@interface TQTextField : UITextField

@property (nonatomic, strong) TQInputValidator *inputValidator;

@end
