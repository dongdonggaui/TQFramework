//
//  HLYDateFormatManager.m
//  HLYPullToRefreshManager
//
//  Created by huangluyang on 14-8-24.
//  Copyright (c) 2014年 huangluyang. All rights reserved.
//

#import "HLYDateFormatManager.h"

@interface HLYDateFormatManager ()

@property (nonatomic, strong) NSDateFormatter *yearMothDayHourMinuteSecondFormater;

@end

@implementation HLYDateFormatManager

+ (instancetype)sharedInstance
{
    static HLYDateFormatManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!sharedManager) {
            sharedManager = [[HLYDateFormatManager alloc] init];
        }
    });
    
    return sharedManager;
}

#pragma mark -
#pragma mark - setters & getters
- (NSDateFormatter *)yearMothDayHourMinuteSecondFormater
{
    if (!_yearMothDayHourMinuteSecondFormater) {
        _yearMothDayHourMinuteSecondFormater = [[NSDateFormatter alloc] init];
        _yearMothDayHourMinuteSecondFormater.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    }
    
    return _yearMothDayHourMinuteSecondFormater;
}

#pragma mark -
#pragma mark - public
- (NSString *)lapseTimeFormatFromDate:(NSDate *)date
{
    NSDate *now = [NSDate date];
    NSTimeInterval timeLapse = [now timeIntervalSinceDate:date];
    NSString *timeString = NSLocalizedStringFromTableInBundle(@"placeholder_lasttime", @"HLYDateFormatManager", [self hly_bundle], nil);;
    
    if (timeLapse < 180) {
        timeString = [timeString stringByAppendingFormat:@" : %@", NSLocalizedStringFromTableInBundle(@"msg_justnow", @"HLYDateFormatManager", [self hly_bundle], nil)];
    } else if (timeLapse < 3600) {
        NSString *lapse = NSLocalizedStringFromTableInBundle(@"placeholder_minutesbefore", @"HLYDateFormatManager", [self hly_bundle], nil);
        timeString = [timeString stringByAppendingFormat:@" : %d %@", (int)ceilf(timeLapse / 60.), lapse];
    } else {
        timeString = [timeString stringByAppendingFormat:@" : %@", [self.yearMothDayHourMinuteSecondFormater stringFromDate:date]];
    }
    
    return timeString;
}

- (NSString *)longDisplayStringFromDate:(NSDate *)date
{
    return [self.yearMothDayHourMinuteSecondFormater stringFromDate:date];
}

#pragma mark -
#pragma mark - private

- (NSBundle *)hly_bundle
{
    NSString *bundlePath = [[NSBundle mainBundle] pathForResource:@"HLYDateFormatManager" ofType:@"bundle"];
    NSBundle *bundle = [NSBundle bundleWithPath:bundlePath];
    
    return bundle;
}

@end
