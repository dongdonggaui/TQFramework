//
//  TQDropList.h
//  Hiweido
//
//  Created by huangluyang on 14-8-28.
//  Copyright (c) 2014年 huangluyang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, TQDropListDirection) {
    TQDropListDirectionLeft,
    TQDropListDirectionCenter,
    TQDropListDirectionRight,
};

/**
 *  Template:
 
 self.dropList = [[TQDropList alloc] init];
 [self.dropList setupWithTitles:@[<#title#>, <#title#>, <#title#>, <#title#>] icons:@[<#UIImage#>, <#UIImage#>, <#UIImage#>]];
 self.dropList.cancelBlock = ^void (TQDropList *dropList) {
    <#cancelBlock#>
 };
 self.dropList.didSelectItemAtIndex = ^void (TQDropList *dropList, NSInteger index) {
    <#selectedBlock#>
 };
 self.dropList.willShow = ^void (TQDropList *dropList) {
    <#willShowBlock#>
 };
 self.dropList.willDismissWithIndex = ^void (TQDropList *dropList, NSInteger index) {
    <#willDismiss#>
 };
 self.dropList.itemWidth = <#width#>;
 self.dropList.itemAnchor = <#Anchor#>;
 self.dropList.displayItemCount = <#count#>;
 self.dropList.deselectItemWhenDismiss = <#BOOL#>;
 
 */
@interface TQDropList : UIView

// UI
@property (nonatomic, unsafe_unretained) CGFloat   itemWidth;
@property (nonatomic, unsafe_unretained) CGFloat   itemHeight;
@property (nonatomic, unsafe_unretained) CGFloat   itemAnchor;
@property (nonatomic, unsafe_unretained) NSInteger displayItemCount;
@property (nonatomic, unsafe_unretained) NSInteger selectedIndex;
/**
 *  标识在消失时是否取消item的选中状态
 */
@property (nonatomic, unsafe_unretained) BOOL deselectItemWhenDismiss;

// callback
@property (nonatomic, copy) void (^willShow)(TQDropList *dropList);
@property (nonatomic, copy) void (^willDismissWithIndex)(TQDropList *dropList, NSInteger index);
@property (nonatomic, copy) void (^didSelectItemAtIndex)(TQDropList *dropList, NSInteger index);
@property (nonatomic, copy) void (^cancelBlock)(TQDropList *dropList);

// setup
- (void)setupWithTitles:(NSArray *)titles;
- (void)setupWithTitles:(NSArray *)titles icons:(NSArray *)icons;

// update
- (void)updateItemWithTitle:(NSString *)title
                 titleColor:(UIColor *)titleColor
                       icon:(UIImage *)icon
                    atIndex:(NSInteger)index;

- (NSString *)titleAtIndex:(NSInteger)index;

// action
- (void)showFromHeight:(CGFloat)height;
- (void)dismiss;

@end

//////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////

@interface TQLeftIconButton : UIButton

- (void)tq_setLeftPadding:(CGFloat)leftPadding;
- (void)tq_setRightPadding:(CGFloat)rightPadding;
- (void)tq_setSpaceBetweenImageAndTitle:(CGFloat)space;

@end