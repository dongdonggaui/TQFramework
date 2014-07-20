//
//  UITableViewCell+Null.m
//  PlayingNearby
//
//  Created by huangluyang on 14-6-13.
//
//

#import "UITableViewCell+Null.h"

@implementation UITableViewCell (Null)

+ (UITableViewCell *)HLY_nullCell
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"nullCell"];
    cell.textLabel.text = NSLocalizedString(@"暂无数据", @"");
    cell.textLabel.textColor = [UIColor lightGrayColor];
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    
    return cell;
}

@end
