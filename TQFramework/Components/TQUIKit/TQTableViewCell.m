//
//  TQTableViewCell.m
//  Hiweido
//
//  Created by huangluyang on 14/10/28.
//  Copyright (c) 2014年 huangluyang. All rights reserved.
//

#import "TQTableViewCell.h"
#import "UIView+Frame.h"

@interface TQTableViewCell ()

@property (nonatomic, strong) UIView *topLine;
@property (nonatomic, strong) UIView *bottomLine;

@property (nonatomic, strong) NSArray *topLineHeightContraints;
@property (nonatomic, strong) NSArray *topLineLeftContraints;
@property (nonatomic, strong) NSArray *topLineRightContraints;

@property (nonatomic, strong) NSArray *bottomLineHeightContraints;
@property (nonatomic, strong) NSArray *bottomLineLeftContraints;
@property (nonatomic, strong) NSArray *bottomLineRightContraints;

@end

@implementation TQTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self tq_initCell];
    }
    
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self tq_initCell];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if ([UIDevice currentDevice].systemVersion.floatValue < 8) {
        [self.backgroundView hly_setTop:4];
        [self.backgroundView hly_setLeft:8];
        [self.backgroundView hly_setWidth:[self hly_width] - 16];
        [self.backgroundView hly_setHeight:[self hly_height] - 8];
    }
}

#pragma mark -
#pragma mark - setters & getters
- (void)setShowTopSeparatorLine:(BOOL)showTopSeparatorLine
{
    _showTopSeparatorLine = showTopSeparatorLine;
    
    self.topLine.hidden = !showTopSeparatorLine;
}

- (void)setShowBottomSeparatorLine:(BOOL)showBottomSeparatorLine
{
    _showBottomSeparatorLine = showBottomSeparatorLine;
    
    self.bottomLine.hidden = !showBottomSeparatorLine;
}

- (void)setSeparatorLineColor:(UIColor *)separatorLineColor
{
    _separatorLineColor = separatorLineColor;
    
    self.topLine.backgroundColor = separatorLineColor;
    self.bottomLine.backgroundColor = separatorLineColor;
}

- (void)setSeparatorLineSize:(CGFloat)separatorLineSize
{
    if (_separatorLineSize == separatorLineSize) {
        return;
    }
    
    _separatorLineSize = separatorLineSize;
    
    NSDictionary *viewsDic = @{@"topLine": self.topLine,
                               @"bottomLine": self.bottomLine};
    NSDictionary *metricsDic = @{@"height": @(separatorLineSize)};
    
    if (self.topLineHeightContraints) {
        [self.contentView removeConstraints:self.topLineHeightContraints];
    }
    if (self.bottomLineHeightContraints) {
        [self.contentView removeConstraints:self.bottomLineHeightContraints];
    }
    
    self.topLineHeightContraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[topLine(==height)]" options:0 metrics:metricsDic views:viewsDic];
    [self.contentView addConstraints:self.topLineHeightContraints];
    
    self.bottomLineHeightContraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[bottomLine(==height)]" options:0 metrics:metricsDic views:viewsDic];
    [self.contentView addConstraints:self.bottomLineHeightContraints];
    
    [self.contentView setNeedsUpdateConstraints];
}

- (void)setSeparatorLineLeftInsets:(CGFloat)separatorLineLeftInsets
{
    _separatorLineLeftInsets = separatorLineLeftInsets;
    
    NSDictionary *viewsDic = @{@"topLine": self.topLine,
                               @"bottomLine": self.bottomLine};
    NSDictionary *metricsDic = @{@"left": @(separatorLineLeftInsets)};
    
    if (self.topLineLeftContraints) {
        [self.contentView removeConstraints:self.topLineLeftContraints];
    }
    if (self.bottomLineLeftContraints) {
        [self.contentView removeConstraints:self.bottomLineLeftContraints];
    }
    
    self.topLineLeftContraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(left)-[topLine]" options:0 metrics:metricsDic views:viewsDic];
    [self.contentView addConstraints:self.topLineLeftContraints];
    
    self.bottomLineLeftContraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(left)-[bottomLine]" options:0 metrics:metricsDic views:viewsDic];
    [self.contentView addConstraints:self.bottomLineLeftContraints];
    
    [self.contentView setNeedsUpdateConstraints];
}

- (void)setSeparatorLineRightInsets:(CGFloat)separatorLineRightInsets
{
    _separatorLineRightInsets = separatorLineRightInsets;
    
    NSDictionary *viewsDic = @{@"topLine": self.topLine,
                               @"bottomLine": self.bottomLine};
    NSDictionary *metricsDic = @{@"right": @(separatorLineRightInsets)};
    
    if (self.topLineRightContraints) {
        [self.contentView removeConstraints:self.topLineRightContraints];
    }
    if (self.bottomLineRightContraints) {
        [self.contentView removeConstraints:self.bottomLineRightContraints];
    }
    
    self.topLineRightContraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:[topLine]-(right)-|" options:0 metrics:metricsDic views:viewsDic];
    [self.contentView addConstraints:self.topLineRightContraints];
    
    self.bottomLineRightContraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:[bottomLine]-(right)-|" options:0 metrics:metricsDic views:viewsDic];
    [self.contentView addConstraints:self.bottomLineRightContraints];
    
    [self.contentView setNeedsUpdateConstraints];
}

#pragma mark -
#pragma mark - private
- (void)tq_initCell
{
    self.topLine = [[UIView alloc] init];
    [self.contentView addSubview:self.topLine];
    
    self.bottomLine = [[UIView alloc] init];
    [self.contentView addSubview:self.bottomLine];
    
    self.separatorLineColor = [UIColor lightGrayColor];
    
    self.topLine.translatesAutoresizingMaskIntoConstraints = NO;
    self.bottomLine.translatesAutoresizingMaskIntoConstraints = NO;
    NSDictionary *viewsDic = @{@"topLine": self.topLine,
                               @"bottomLine": self.bottomLine};
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[topLine]" options:0 metrics:nil views:viewsDic]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[bottomLine]-0-|" options:0 metrics:nil views:viewsDic]];
    [self.contentView setNeedsUpdateConstraints];
    
    self.separatorLineRightInsets = 0;
    self.separatorLineLeftInsets = 20;
    self.separatorLineSize = 0.5;
    
    self.showBottomSeparatorLine = YES;
    self.showTopSeparatorLine = NO;
    
    self.contentView.backgroundColor = [UIColor clearColor];
    self.backgroundColor = [UIColor clearColor];
}

@end
