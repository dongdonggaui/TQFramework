//
//  HLYAutoLayoutTableManager.m
//  HuangLuyang
//
//  Created by huangluyang on 14-7-19.
//  Copyright (c) 2014年 huangluyang. All rights reserved.
//

#import "HLYAutoLayoutTableManager.h"

@interface HLYAutoLayoutTableManager ()

@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, strong) NSMutableDictionary *cellCache;

@end

@implementation HLYAutoLayoutTableManager

- (void)dealloc
{
    self.cellCache = nil;
}

- (instancetype)init
{
    if (self = [super init]) {
        _cellCache = [NSMutableDictionary dictionary];
    }
    
    return self;
}

- (instancetype)initWithTableView:(UITableView *)tableView
{
    if (self = [self init]) {
        _tableView = tableView;
    }
    
    return self;
}

- (void)updateCell:(UITableViewCell *)cell forReuseIdentifier:(NSString *)identifier enforceable:(BOOL)isEnforceable
{
    if (!cell || !identifier || identifier.length == 0) {
        return;
    }
    
    UITableViewCell *cachedCell = [self.cellCache objectForKey:identifier];
    if (!cachedCell || isEnforceable) {
        [self.cellCache setObject:cell forKey:identifier];
    }
}

- (UITableViewCell *)cellAtIndexPath:(NSIndexPath *)indexPath reuseIdentfier:(NSString *)identifier
{
    if (!indexPath) {
        return nil;
    }
    
    UITableViewCell *cell = [self.cellCache objectForKey:identifier];
    if (!cell && self.cellAtIndexPath) {
        cell = self.cellAtIndexPath(indexPath);
        [self updateCell:cell forReuseIdentifier:identifier enforceable:YES];
    }
    
    return cell;
}

- (CGFloat)heightForCellAtIndexPath:(NSIndexPath *)indexPath reuseIdentfier:(NSString *)identifier
{
    UITableViewCell *cell = [self cellAtIndexPath:indexPath reuseIdentfier:identifier];
    
    if (self.configureCellAtIndexPath) {
        self.configureCellAtIndexPath(cell, indexPath);
    }
    
    // Make sure the constraints have been added to this cell, since it may have just been created from scratch
    [cell setNeedsUpdateConstraints];
    [cell updateConstraintsIfNeeded];
    
    // The cell's width must be set to the same size it will end up at once it is in the table view.
    // This is important so that we'll get the correct height for different table view widths, since our cell's
    // height depends on its width due to the multi-line UILabel word wrapping. Don't need to do this above in
    // -[tableView:cellForRowAtIndexPath:] because it happens automatically when the cell is used in the table view.
    cell.bounds = CGRectMake(0, 0, self.tableView.bounds.size.width, cell.bounds.size.height);
    // NOTE: if you are displaying a section index (e.g. alphabet along the right side of the table view), or
    // if you are using a grouped table view style where cells have insets to the edges of the table view,
    // you'll need to adjust the cell.bounds.size.width to be smaller than the full width of the table view we just
    // set it to above. See http://stackoverflow.com/questions/3647242 for discussion on the section index width.
    
    // Do the layout pass on the cell, which will calculate the frames for all the views based on the constraints
    // (Note that the preferredMaxLayoutWidth is set on multi-line UILabels inside the -[layoutSubviews] method
    // in the UITableViewCell subclass
    [cell setNeedsLayout];
    [cell layoutIfNeeded];
    
    // Get the actual height required for the cell
    CGSize size = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    CGFloat height = size.height;
    
    // Add an extra point to the height to account for the cell separator, which is added between the bottom
    // of the cell's contentView and the bottom of the table view cell.
    height += 1;
    
    NSLog(@"height in manager --> %f", height);
    
    return height;
}

/*
 - (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // If you are just returning a constant value from this method, you should instead just set the table view's
 // estimatedRowHeight property (in viewDidLoad or similar), which is even faster as the table view won't
 // have to call this method for every row in the table view.
 //
 // Only implement this method if you have row heights that vary by extreme amounts and you notice the scroll indicator
 // "jumping" as you scroll the table view when using a constant estimatedRowHeight. If you do implement this method,
 // be sure to do as little work as possible to get a reasonably-accurate estimate.
 
 // NOTE for iOS 7.0.x ONLY, this bug has been fixed by Apple as of iOS 7.1:
 // A constraint exception will be thrown if the estimated row height for an inserted row is greater
 // than the actual height for that row. In order to work around this, we need to return the actual
 // height for the the row when inserting into the table view - uncomment the below 3 lines of code.
 // See: https://github.com/caoimghgin/TableViewCellWithAutoLayout/issues/6
 //    if (self.isInsertingRow) {
 //        return [self tableView:tableView heightForRowAtIndexPath:indexPath];
 //    }
 
 return UITableViewAutomaticDimension;
 }
 */

@end
