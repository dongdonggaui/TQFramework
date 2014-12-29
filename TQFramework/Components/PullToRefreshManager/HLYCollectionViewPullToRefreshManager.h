//
//  HLYCollectionPullToRefreshManager.h
//  laohu-dota-assistant
//
//  Created by huangluyang on 14/11/18.
//  Copyright (c) 2014年 wanmei. All rights reserved.
//

#import "HLYPullToRefreshManager.h"

/**
 *  Template：
 
 // property
 @property (nonatomic, strong) HLYCollectionViewPullToRefreshManager *pullToRefreshManager;
 
 self.pullToRefreshManager = [[HLYCollectionViewPullToRefreshManager alloc] initWithCollectionView:<#collectionView#>];
 self.pullToRefreshManager.enableLoadMore = <#BOOL#>;
 self.pullToRefreshManager.collectionViewSizeForItemAtIndexPath = ^CGSize (UICollectionView *collectionView, NSIndexPath *indexPath)
 {
    <#size#>
 };
 self.pullToRefreshManager.collectionViewInsetsForSectionAtIndex = ^UIEdgeInsets (UICollectionView *collectionView, NSInteger section) {
    <#insets#>
 };
 self.pullToRefreshManager.collectionViewMinimumLineSpacingForSectionAtIndex = ^CGFloat (UICollectionView *collectionView, NSInteger section) {
    <#lineSpacing#>
 };
 self.pullToRefreshManager.collectionViewMinimumInteritemSpacingForSectionAtIndex = ^CGFloat (UICollectionView *collectionView, NSInteger section) {
    <#itemSpacing#>
 };
 self.pullToRefreshManager.didSelectedCollectionViewAtIndexPath = ^void (UICollectionView *collectionView, NSIndexPath *indexPath) {
    <#selected#>
 };
 self.pullToRefreshManager.didDeselectedCollectionViewAtIndexPath = ^void (UICollectionView *collectionView, NSIndexPath *indexPath) {
    <#Deselected#>
 };
 self.pullToRefreshManager.loadNew = ^{
    <#loadNew#>
 };
 self.pullToRefreshManager.loadMore = ^{
    <#loadMore#>
 };
 
 */
@interface HLYCollectionViewPullToRefreshManager : HLYPullToRefreshManager <UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong, readonly) UICollectionView *collectionView;

- (instancetype)initWithCollectionView:(UICollectionView *)collectionView;

// callbacks
@property (nonatomic, copy) CGSize (^collectionViewSizeForItemAtIndexPath)(UICollectionView *collectionView, NSIndexPath *indexPath);
@property (nonatomic, copy) UIEdgeInsets (^collectionViewInsetsForSectionAtIndex)(UICollectionView *collectionView, NSInteger section);
@property (nonatomic, copy) CGFloat (^collectionViewMinimumLineSpacingForSectionAtIndex)(UICollectionView *collectionView, NSInteger section);
@property (nonatomic, copy) CGFloat (^collectionViewMinimumInteritemSpacingForSectionAtIndex)(UICollectionView *collectionView, NSInteger section);

@property (nonatomic, copy) void (^didSelectedCollectionViewAtIndexPath)(UICollectionView *collectionView, NSIndexPath *indexPath);
@property (nonatomic, copy) void (^didDeselectedCollectionViewAtIndexPath)(UICollectionView *collectionView, NSIndexPath *indexPath);
@property (nonatomic, copy) void (^collectionViewWillDisplayCellAtIndexPath)(UICollectionView *collectionView, UICollectionViewCell *cell, NSIndexPath *indexPath);

@end
