//
//  TQShareActionSheet.h
//  laohu
//
//  Created by huangluyang on 14/10/21.
//  Copyright (c) 2014年 wanmei. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TQShareActionSheetItem;

/**
 *  分享选择器
 */
@interface TQShareActionSheet : UIView

@property (nonatomic, copy) void (^willDismissBlock)();

- (instancetype)initWithTitle:(NSString *)title cancelButtonTitle:(NSString *)cancelButtonTitle;

- (void)addShareItem:(TQShareActionSheetItem *)item;

- (void)showShareActionSheet;
- (void)dismissShareActionSheet;

@end

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

typedef void(^TQShareActionSheetItemTappedBlock)(void);

@interface TQShareActionSheetItem : UIButton

@property (nonatomic, copy) TQShareActionSheetItemTappedBlock tappedAction;

+ (instancetype)itemWithIcon:(UIImage *)icon
                       title:(NSString *)title
                selectedIcon:(UIImage *)selectedIcon
               selectedTitle:(NSString *)selectedTitle
                      tapped:(TQShareActionSheetItemTappedBlock)tapped;

@end
