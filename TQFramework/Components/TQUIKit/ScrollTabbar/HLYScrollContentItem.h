//
//  HLYScrollContentItem.h
//  laohu
//
//  Created by huangluyang on 14-7-29.
//  Copyright (c) 2014年 wanmei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HLYTableViewPullToRefreshManager.h"
#import "HLYAutoLayoutTableManager.h"

typedef NS_ENUM(NSUInteger, HLYScrollContentItemDataSourceType) {
    HLYScrollContentItemDataSourceTypeSingleSectionArray,
    HLYScrollContentItemDataSourceTypeModel,
};

/**
 *  对“水平滑动式多屏”视图的content的包装，提供数据加载、更新、缓存以及刷新UI的功能，主要包含一个tableView用于显示
 *  数据，一个tableWrapper用于实现下拉刷新/上拉加载更多的效果
 */
@interface HLYScrollContentItem : NSObject <UITableViewDataSource>

// UI
@property (nonatomic, weak, readonly) UITableView *tableView;

// logic
@property (nonatomic, strong, readonly) NSMutableArray *datas;
@property (nonatomic, strong, readonly) NSObject *model;
@property (nonatomic, unsafe_unretained) NSString  *newsCategoryId;
@property (nonatomic, unsafe_unretained) NSInteger currentPageIndex;
@property (nonatomic, unsafe_unretained) NSInteger category;
@property (nonatomic, unsafe_unretained) BOOL      canLoadMore;
@property (nonatomic, unsafe_unretained) HLYScrollContentItemDataSourceType dataSourceType;

@property (nonatomic, strong) HLYTableViewPullToRefreshManager *pullToRefreshManager;
@property (nonatomic, strong) HLYAutoLayoutTableManager *autoLayoutTableManager;

// callback
@property (nonatomic, copy) NSInteger (^numberOfSectionForTableView)(HLYScrollContentItem *, UITableView *);
@property (nonatomic, copy) NSInteger (^numberOfCellForTableViewAtSection)(HLYScrollContentItem *, UITableView *, NSInteger);
@property (nonatomic, copy) NSString * (^headerTitleForTableViewAtSection)(HLYScrollContentItem *, UITableView *, NSInteger);

/**
 *  初始化
 *
 *  @param identifier     缓存标识符
 *  @param dataSourceType 数据源类型
 *
 *  @return 初始化对象
 */
- (instancetype)initWithTableView:(UITableView *)tableView
                  cacheIdentifier:(NSString *)identifier
                   dataSourceType:(HLYScrollContentItemDataSourceType)dataSourceType;

/**
 *  根据缓存标识符加载缓存数据，若无缓存数据或缓存过期则自动刷新数据
 *
 *  @param extendIdentifier 缓存标识符
 */
- (void)loadCacheDatasWithExtendIdentifier:(NSString *)extendIdentifier;

/**
 *  替换现有数据，用于下拉刷新
 *
 *  @param datas 数据源
 */
- (void)updateDatas:(NSArray *)datas withExtendIdentifier:(NSString *)extendIdentifier;

- (void)updateModel:(id)model withExtendIdentifier:(NSString *)extendIdentifier;

/**
 *  扩展现有数据，用于上拉加载更多
 *
 *  @param datas 数据源
 */
- (void)appendDatas:(NSArray *)datas withExtendIdentifier:(NSString *)extendIdentifier;

- (BOOL)needRefreshWithExtendIdentifier:(NSString *)extendIdentifier;

- (void)endLoad;

@end
