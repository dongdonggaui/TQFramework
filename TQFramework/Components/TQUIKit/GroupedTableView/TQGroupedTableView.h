//
//  TQGroupedTableView.h
//  Hiweido
//
//  Created by huangluyang on 14/11/11.
//  Copyright (c) 2014年 huangluyang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TQGroupedTableView : UITableView

@property (nonatomic, assign) CGFloat horizPadding;

/**
 *  在iOS6及以前中，cell会覆盖Group背景，故需在UITableViewDelegate的
 *  tableView:willDisplayCell:forRowAtIndexPath:方法中将Group背景
 *  sendSubViewToBack
 *
 *  @param section 指定section
 *
 *  @return 该section的Group背景
 */
- (UIView *)backgroundViewForSection:(NSInteger)section;

@end
