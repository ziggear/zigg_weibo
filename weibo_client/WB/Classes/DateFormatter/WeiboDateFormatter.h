//
//  WeiboDateFormatter.h
//  WB
//
//  Created by ziggear on 15-1-28.
//  Copyright (c) 2015年 ziggear. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WeiboDateFormatter : NSObject

+(WeiboDateFormatter *)sharedFormatter;

- (void)setDateFormatWeiboStatus;
- (void)setDateFormat:(NSString *)dateFormat;

- (NSString *)friendlyStringFromDate:(NSDate *)date;
- (NSString *)stringFromDate:(NSDate *)date;

- (NSDate *)dateFromString:(NSString *)string;

@end
