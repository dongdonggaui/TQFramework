//
//  HLYAutoLayoutTableManager.h
//  HuangLuyang
//
//  Created by huangluyang on 14-7-19.
//  Copyright (c) 2014年 huangluyang. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  管理cell的自动布局管理器
 *  
 *  使用方法：
 *
 *  1、使用相关tableView初始化
 *
 *  2、配置好cellAtIndexPath和configureCellAtIndexPath
 *
 *  3、在tableView的DataSource方法tableView:cellForRowAtIndexPath:方法中调用cellAtIndexPath
 *  和configureCellAtIndexPath
 *
 *  4、在tableView的Delegate方法tableView:heightForRowAtIndexPath:方法中调用
 *  heightForCellAtIndexPath:reuseIdentifier方法返回计算好的高度
 *
 
 Template:
 
 // cell identifier
 static NSString * const <#prefix#>CellIdentifier = @"<#string#>";
 
 // property
 @property (nonatomic, strong) HLYAutoLayoutTableManager *autoLayoutTableManager;
 
 // table init
 self.tableView = [[UITableView alloc] initWithFrame:CGRectZero];
 self.tableView.dataSource = self;
 self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
 [self.view addSubview:self.tableView];
 
 // rigister nib
 [self.tableView registerNib:[UINib nibWithNibName:@"<#nibName#>" bundle:nil] forCellReuseIdentifier:<#cellIdentifier#>];
 
 // constraints
 self.tableView.translatesAutoresizingMaskIntoConstraints = NO;
 NSDictionary *viewsDic = @{@"tableView": self.tableView};
 [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[tableView]-0-|" options:0 metrics:nil views:viewsDic]];
 [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[tableView]-0-|" options:0 metrics:nil views:viewsDic]];
 
 // auto layout
 self.autoLayoutTableManager = [[HLYAutoLayoutTableManager alloc] initWithTableView:<#tableView#>];
 self.autoLayoutTableManager.cellAtIndexPath = ^UITableViewCell *(UITableView *tableView, NSIndexPath *indexPath) {
    <#cell#>
 };
 self.autoLayoutTableManager.configureCellAtIndexPath = ^void (UITableViewCell *tableViewCell, NSIndexPath *indexPath, BOOL forHeightCaculate) {
    <#configureCell#>
 };
 
 // data source
 - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
 {
    UITableViewCell *cell = nil;
    if (self.autoLayoutTableManager.cellAtIndexPath) {
        cell = self.autoLayoutTableManager.cellAtIndexPath(tableView, indexPath);
        if (cell && self.autoLayoutTableManager.configureCellAtIndexPath) {
            self.autoLayoutTableManager.configureCellAtIndexPath(cell, indexPath, NO);
        }
    }
 
    return cell;
 }
 
 */
@interface HLYAutoLayoutTableManager : NSObject

- (instancetype)initWithTableView:(UITableView *)tableView;

/**
 *  获取cell
 */
@property (nonatomic, copy) UITableViewCell* (^cellAtIndexPath)(UITableView *, NSIndexPath*);

/**
 *  完善cell布局所需要的数据
 */
@property (nonatomic, copy) void (^configureCellAtIndexPath)(UITableViewCell *tableViewCell, NSIndexPath *indexPath, BOOL forHeightCaculate);

/**
 *  获取根据cell配置的数据和约束计算后的高度
 */
- (CGFloat)heightForCellAtIndexPath:(NSIndexPath *)indexPath reuseIdentfier:(NSString *)identifier;

@end