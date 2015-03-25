//
//  WeiboDateFormatter.m
//  WB
//
//  Created by ziggear on 15-1-28.
//  Copyright (c) 2015年 ziggear. All rights reserved.
//

#import "WeiboDateFormatter.h"

@interface WeiboDateFormatter ()
@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@end

@implementation WeiboDateFormatter

+(WeiboDateFormatter *)sharedFormatter {
    static dispatch_once_t pred;
    static WeiboDateFormatter *shared = nil;
    
    dispatch_once(&pred, ^{
        shared = [[WeiboDateFormatter alloc] init];
    });
    return shared;
}

- (instancetype)init {
    if(self = [super init]) {
        self.dateFormatter = [[NSDateFormatter alloc] init];
        [self.dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Shanghai"]];
    }
    return self;
}

- (void)setDateFormatWeiboStatus {
    [self setDateFormat:@"EEE MMM dd HH:mm:ss Z yyyy"];
}

- (void)setDateFormat:(NSString *)dateFormat {
    [self.dateFormatter setDateFormat:dateFormat];
}

- (NSDate *)dateFromString:(NSString *)string {
    return [self.dateFormatter dateFromString:string];
}

- (NSString *)stringFromDate:(NSDate *)date {
    return [self.dateFormatter stringFromDate:date];
}

- (NSString *)friendlyStringFromDate:(NSDate *)date {
    NSTimeInterval intv = [[NSDate date] timeIntervalSinceDate:date];
    if (intv > 86400) {
        [self.dateFormatter setDateFormat:@"MM DD HH:mm:ss"];
        return [self stringFromDate:date];
    } else if (intv > 3600) {
        [self.dateFormatter setDateFormat:@"今天 HH'点'mm'分'"];
        return [self stringFromDate:date];
    } else if (intv > 60) {
        int mins = intv / 60;
        return [NSString stringWithFormat:@"%d分钟前", mins];
    } else {
        return @"刚刚";
    }
}

@end
