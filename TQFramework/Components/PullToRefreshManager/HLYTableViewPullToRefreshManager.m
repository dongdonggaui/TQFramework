//
//  HLYTableViewPullToRefreshManager.m
//  laohu-dota-assistant
//
//  Created by huangluyang on 14/11/18.
//  Copyright (c) 2014年 wanmei. All rights reserved.
//

#import "HLYTableViewPullToRefreshManager.h"

@implementation HLYTableViewPullToRefreshManager

- (instancetype)initWithTableView:(UITableView *)tableView
{
    if (self = [super initWithScrollView:tableView]) {
        _scrollView = tableView;
        tableView.delegate = self;
    }
    
    return self;
}

#pragma mark -
#pragma mark - setters & getters
- (UITableView *)tableView
{
    if (![_scrollView isKindOfClass:[UITableView class]]) {
        return nil;
    }
    
    return (UITableView *)_scrollView;
}

#pragma mark -
#pragma mark - table view
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.didSelectedTableViewAtIndexPath) {
        self.didSelectedTableViewAtIndexPath(tableView, indexPath);
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.cellHeightForTableViewAtIndexPath) {
        return self.cellHeightForTableViewAtIndexPath(tableView, indexPath);
    }
    
    return 44;
}

//- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if (self.estimatedCellHeightForTableViewAtIndexPath) {
//        return self.estimatedCellHeightForTableViewAtIndexPath(tableView, indexPath);
//    }
//
//    return 60;
//}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (self.headerViewForTableViewInSection) {
        return self.headerViewForTableViewInSection(tableView, section);
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (self.headerViewHeightForTableViewInSection) {
        return self.headerViewHeightForTableViewInSection(tableView, section);
    }
    
    return 0;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.tableViewWillDisplayCellAtIndexPath) {
        self.tableViewWillDisplayCellAtIndexPath(tableView, cell, indexPath);
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (self.footerViewHeightForTableViewInSection) {
        return self.footerViewHeightForTableViewInSection(tableView,section);
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section;
{
    if (self.footerViewForTableViewInSection) {
        return  self.footerViewForTableViewInSection(tableView,section);
    }
    return nil;
}

@end
