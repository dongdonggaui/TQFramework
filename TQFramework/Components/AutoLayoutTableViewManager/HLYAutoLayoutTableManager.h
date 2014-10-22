//
//  HLYAutoLayoutTableManager.h
//  HuangLuyang
//
//  Created by huangluyang on 14-7-19.
//  Copyright (c) 2014年 huangluyang. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  管理cell的自动布局
 */
@interface HLYAutoLayoutTableManager : NSObject

- (instancetype)initWithTableView:(UITableView *)tableView;

// 配置
@property (nonatomic, copy) UITableViewCell* (^cellAtIndexPath)(NSIndexPath*);
@property (nonatomic, copy) void (^configureCellAtIndexPath)(UITableViewCell *tableViewCell, NSIndexPath *indexPath);

- (void)updateCell:(UITableViewCell *)cell forReuseIdentifier:(NSString *)identifier enforceable:(BOOL)isEnforceable;

// 获取
- (UITableViewCell *)cellAtIndexPath:(NSIndexPath *)indexPath reuseIdentfier:(NSString *)identifier;
- (CGFloat)heightForCellAtIndexPath:(NSIndexPath *)indexPath reuseIdentfier:(NSString *)identifier;

@end