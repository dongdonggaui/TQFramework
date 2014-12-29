//
//  HLYTableViewPullToRefreshManager.h
//  laohu-dota-assistant
//
//  Created by huangluyang on 14/11/18.
//  Copyright (c) 2014年 wanmei. All rights reserved.
//

#import "HLYPullToRefreshManager.h"

/**
 *  Template:
 
 // property
 @property (nonatomic, strong) HLYTableViewPullToRefreshManager *pullToRefreshManager;
 
 self.pullToRefreshManager = [[HLYTableViewPullToRefreshManager alloc] initWithTableView:<#tableView#>];
 self.pullToRefreshManager.enableLoadMore = <#BOOL#>;
 self.pullToRefreshManager.cellHeightForTableViewAtIndexPath = ^CGFloat (UITableView *tableView, NSIndexPath *indexPath) {
    <#cellHeight#>
 };
 self.pullToRefreshManager.headerViewForTableViewInSection = ^UIView *(UITableView *tableView, NSInteger section) {
    <#headerView#>
 };
 self.pullToRefreshManager.headerViewHeightForTableViewInSection = ^CGFloat (UITableView *tableView, NSInteger section) {
    <#headerHeight#>
 };
 self.pullToRefreshManager.didSelectedTableViewAtIndexPath = ^void (UITableView *tableView, NSIndexPath *indexPath) {
    <#selected#>
 };
 self.pullToRefreshManager.tableViewWillDisplayCellAtIndexPath = ^void (UITableView *tableView, UITableViewCell *cell, NSIndexPath *indexPath)
 {
 <#willDisplayCell#>
 };
 self.pullToRefreshManager.loadNew = ^{
    <#loadNew#>
 };
 self.pullToRefreshManager.loadMore = ^{
    <#loadMore#>
 };
 */
@interface HLYTableViewPullToRefreshManager : HLYPullToRefreshManager <UITableViewDelegate>

@property (nonatomic, strong, readonly) UITableView *tableView;

- (instancetype)initWithTableView:(UITableView *)tableView;

// callback
@property (nonatomic, copy) void (^didSelectedTableViewAtIndexPath)(UITableView *tableView, NSIndexPath *indexPath);
@property (nonatomic, copy) void (^tableViewWillDisplayCellAtIndexPath)(UITableView *tableView, UITableViewCell *cell, NSIndexPath *indexPath);
@property (nonatomic, copy) CGFloat (^cellHeightForTableViewAtIndexPath)(UITableView *tableView, NSIndexPath *indexPath);
@property (nonatomic, copy) CGFloat (^estimatedCellHeightForTableViewAtIndexPath)(UITableView *tableView, NSIndexPath *indexPath);
@property (nonatomic, copy) UIView * (^headerViewForTableViewInSection)(UITableView *tableView, NSInteger section);
@property (nonatomic, copy) CGFloat (^headerViewHeightForTableViewInSection)(UITableView *tableView, NSInteger section);
@property (nonatomic, copy) NSString * (^titleForTableViewInSection)(UITableView *tableView, NSInteger section);
@property (nonatomic, copy) UIView * (^footerViewForTableViewInSection)(UITableView *tableView, NSInteger section);
@property (nonatomic, copy) CGFloat (^footerViewHeightForTableViewInSection)(UITableView *tableView, NSInteger section);

@end
