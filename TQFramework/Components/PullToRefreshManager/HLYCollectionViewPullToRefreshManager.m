//
//  HLYCollectionPullToRefreshManager.m
//  laohu-dota-assistant
//
//  Created by huangluyang on 14/11/18.
//  Copyright (c) 2014年 wanmei. All rights reserved.
//

#import "HLYCollectionViewPullToRefreshManager.h"

@implementation HLYCollectionViewPullToRefreshManager

- (instancetype)initWithCollectionView:(UICollectionView *)collectionView
{
    if (self = [super initWithScrollView:collectionView]) {
        _scrollView = collectionView;
        collectionView.delegate = self;
    }
    
    return self;
}

#pragma mark -
#pragma mark - setters & getters
- (UICollectionView *)collectionView
{
    if (![_scrollView isKindOfClass:[UITableView class]]) {
        return nil;
    }
    
    return (UICollectionView *)_scrollView;
}

#pragma mark -
#pragma mark - collection delegate
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.collectionViewSizeForItemAtIndexPath) {
        return self.collectionViewSizeForItemAtIndexPath(collectionView, indexPath);
    }
    
    return CGSizeZero;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    if (self.collectionViewInsetsForSectionAtIndex) {
        return self.collectionViewInsetsForSectionAtIndex(collectionView, section);
    }
    
    return UIEdgeInsetsZero;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    if (self.collectionViewMinimumLineSpacingForSectionAtIndex) {
        return self.collectionViewMinimumLineSpacingForSectionAtIndex(collectionView, section);
    }
    
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    if (self.collectionViewMinimumInteritemSpacingForSectionAtIndex) {
        return self.collectionViewMinimumInteritemSpacingForSectionAtIndex(collectionView, section);
    }
    
    return 0;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.didSelectedCollectionViewAtIndexPath) {
        self.didSelectedCollectionViewAtIndexPath(collectionView, indexPath);
    }
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.didDeselectedCollectionViewAtIndexPath) {
        self.didDeselectedCollectionViewAtIndexPath(collectionView, indexPath);
    }
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.collectionViewWillDisplayCellAtIndexPath) {
        self.collectionViewWillDisplayCellAtIndexPath(collectionView, cell, indexPath);
    }
}

@end
