//
//  TQGroupedTableView.m
//  Hiweido
//
//  Created by huangluyang on 14/11/11.
//  Copyright (c) 2014年 huangluyang. All rights reserved.
//

#import "TQGroupedTableView.h"

@interface TQGroupedTableView ()

@end

@implementation TQGroupedTableView

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.horizPadding = 9;
}

- (void)reloadData
{
    [super reloadData];
    
    NSInteger sectionCount = self.numberOfSections;
    for (int i = 0; i < sectionCount; i++) {
        CGRect sectionRect = [self rectForSection:i];
        CGRect headerRect = [self rectForHeaderInSection:i];
        CGRect footerRect = [self rectForFooterInSection:i];
        UIView *sectionBackgroundView = [self viewWithTag:10000 + i];
        if (!sectionBackgroundView) {
            sectionBackgroundView = [[UIView alloc] initWithFrame:CGRectZero];
            sectionBackgroundView.tag = 10000 + i;
//            sectionBackgroundView.clipsToBounds = YES;    // 不能设置，设置之后shadow相关的设置无效
            sectionBackgroundView.layer.cornerRadius = 2;
            sectionBackgroundView.layer.shadowOffset = CGSizeMake(0, 0);
            sectionBackgroundView.layer.shadowRadius = 0.5;
            sectionBackgroundView.layer.shadowOpacity = 1;
            sectionBackgroundView.backgroundColor = [UIColor whiteColor];
            [self insertSubview:sectionBackgroundView atIndex:0];
        }
        [self sendSubviewToBack:sectionBackgroundView];
        sectionBackgroundView.frame = CGRectMake(self.horizPadding, headerRect.origin.y + headerRect.size.height + 2, sectionRect.size.width - 2 * self.horizPadding, sectionRect.size.height - headerRect.size.height - footerRect.size.height - 4);
//        [self.sectionBackgroundViews addObject:sectionBackgroundView];
    }
}

- (UIView *)backgroundViewForSection:(NSInteger)section
{
    return [self viewWithTag:10000 + section];
}

@end
