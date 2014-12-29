//
//  HLYScrollContentItem.m
//  laohu
//
//  Created by huangluyang on 14-7-29.
//  Copyright (c) 2014年 wanmei. All rights reserved.
//

#import "HLYScrollContentItem.h"
#import "LHNewsDetailViewController.h"
#import "DANewsTableViewCell.h"
#import "HLYCache.h"

@interface HLYScrollContentItem ()

@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *datas;
@property (nonatomic, strong) NSObject *model;
@property (nonatomic, strong) NSString *cacheIdentifier;

@end

@implementation HLYScrollContentItem

- (void)dealloc
{
    if (self.tableView) {
        self.tableView.dataSource = nil;
    }
    
    self.datas = nil;
    self.model = nil;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _datas = [NSMutableArray array];
    }
    return self;
}

- (instancetype)initWithTableView:(UITableView *)tableView cacheIdentifier:(NSString *)identifier dataSourceType:(HLYScrollContentItemDataSourceType)dataSourceType
{
    if (self = [self init]) {
        _tableView = tableView;
        _tableView.dataSource = self;
        _cacheIdentifier = identifier;
        _dataSourceType = dataSourceType;
    }
    return self;
}

#pragma mark -
#pragma mark - public
- (void)loadCacheDatasWithExtendIdentifier:(NSString *)extendIdentifier
{
    if (self.dataSourceType == HLYScrollContentItemDataSourceTypeModel) {
        NSObject *model = [HLYCache fetchCachedObjectForEntity:[self cacheIdentifierWithExtendIdentifer:extendIdentifier]];
        
        self.model = model;
        
    } else if (self.dataSourceType == HLYScrollContentItemDataSourceTypeSingleSectionArray) {
        NSArray *cacheDatas = [HLYCache fetchCachedObjectForEntity:[self cacheIdentifierWithExtendIdentifer:extendIdentifier]];
        
        [self.datas removeAllObjects];
        [self.datas addObjectsFromArray:cacheDatas];
        
        self.canLoadMore = self.datas.count >= 10;
    }
    
    [self reloadTableViewDataWithFinishLoading:NO];
    
    // 如果缓存过期则立即更新
    if ([HLYCache needRefreshForEntity:[self cacheIdentifierWithExtendIdentifer:extendIdentifier]]) {
        if (self.pullToRefreshManager) {
            [self.pullToRefreshManager triggerLoadNew];
        }
    }
}

- (void)appendDatas:(NSArray *)datas withExtendIdentifier:(NSString *)extendIdentifier
{
    [self.datas addObjectsFromArray:datas];
    [HLYCache cacheObject:self.datas withEntityName:[self cacheIdentifierWithExtendIdentifer:extendIdentifier]];
}

- (void)updateDatas:(NSArray *)datas withExtendIdentifier:(NSString *)extendIdentifier
{
    [self.datas removeAllObjects];
    [self.datas addObjectsFromArray:datas];
    
    // 缓存数据
    [HLYCache cacheObject:self.datas withEntityName:[self cacheIdentifierWithExtendIdentifer:extendIdentifier]];
    
    [self reloadTableViewDataWithFinishLoading:NO];
}

- (void)updateModel:(id)model withExtendIdentifier:(NSString *)extendIdentifier
{
    // 缓存数据
    self.model = model;
    
    [HLYCache cacheObject:model withEntityName:[self cacheIdentifierWithExtendIdentifer:extendIdentifier]];
    
    [self reloadTableViewDataWithFinishLoading:NO];
}

- (BOOL)needRefreshWithExtendIdentifier:(NSString *)extendIdentifier
{
    return [HLYCache needRefreshForEntity:[self cacheIdentifierWithExtendIdentifer:extendIdentifier]];
}

- (void)endLoad
{
    [self reloadTableViewDataWithFinishLoading:YES];
}

#pragma mark -
#pragma mark - private
- (NSString *)cacheIdentifierWithExtendIdentifer:(NSString *)extendIdentifier
{
    NSString *cacheIdentifier = self.cacheIdentifier;
    if (extendIdentifier) {
        cacheIdentifier = [cacheIdentifier stringByAppendingString:extendIdentifier];
    }
    
    return cacheIdentifier;
}

/// 刷新tableView数据源，以及是否结束“下拉刷新/上拉加载”功能
- (void)reloadTableViewDataWithFinishLoading:(BOOL)finishLoading
{
    if (self.pullToRefreshManager) {
        [self.pullToRefreshManager.tableView reloadData];
        
        if (finishLoading) {
            [self.pullToRefreshManager endLoad];
        }
    }
}

/// 请求新数据
- (void)loadNewCompleleted:(void (^)(void))completed
{
    
}

/// 加载更多数据
- (void)loadMoreCompleleted:(void (^)(void))completed
{
    
}

#pragma mark -
#pragma mark - table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.dataSourceType == HLYScrollContentItemDataSourceTypeModel && self.numberOfSectionForTableView) {
        return self.numberOfSectionForTableView(self, tableView);
    }
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.dataSourceType == HLYScrollContentItemDataSourceTypeSingleSectionArray && self.datas) {
        return self.datas.count;
    } else if (self.dataSourceType == HLYScrollContentItemDataSourceTypeModel && self.numberOfCellForTableViewAtSection) {
        return self.numberOfCellForTableViewAtSection(self, tableView, section);
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    
    if (self.autoLayoutTableManager) {
        cell = self.autoLayoutTableManager.cellAtIndexPath(tableView, indexPath);
        if (self.autoLayoutTableManager.configureCellAtIndexPath) {
            self.autoLayoutTableManager.configureCellAtIndexPath(cell, indexPath, NO);
        }
    }
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (self.headerTitleForTableViewAtSection) {
        return self.headerTitleForTableViewAtSection(self, tableView, section);
    }
    
    return nil;
}

@end
