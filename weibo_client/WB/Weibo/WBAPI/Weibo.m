//
//  Weibo.m
//  WB
//
//  Created by ziggear on 15-1-23.
//  Copyright (c) 2015年 ziggear. All rights reserved.
//

#import "Weibo.h"
#import "WeiboUser.h"
#import "WeiboDateFormatter.h"

@implementation Weibo

+ (instancetype)weiboWithDictionary:(NSDictionary *)dict {
    return [self weiboWithDictionary:dict isRepo:NO];
}

+ (instancetype)weiboWithDictionary:(NSDictionary *)dict isRepo:(BOOL)re {
    Weibo *wb = [[Weibo alloc] init];
    wb.reTweeted = NO;
    if([dict objectForKey:@"text"]) {
        wb.weiboId = [dict objectForKey:@"id"];
        wb.weiboContent = [dict objectForKey:@"text"];
        wb.postTime = [dict objectForKey:@"created_at"];
        wb.miniPicURL = [dict objectForKey:@"thumbnail_pic"] ? [dict objectForKey:@"thumbnail_pic"] : nil;

        if([dict objectForKey:@"created_at"]) {
            [[WeiboDateFormatter sharedFormatter] setDateFormatWeiboStatus];
            NSDate *postDate = [[WeiboDateFormatter sharedFormatter] dateFromString:[dict objectForKey:@"created_at"]];
            wb.postTime = [[WeiboDateFormatter sharedFormatter] friendlyStringFromDate:postDate];
        }
        
        if([dict objectForKey:@"pic_urls"]) {
            NSMutableArray *pirURLArray = [NSMutableArray array];
            for(NSDictionary *d in [dict objectForKey:@"pic_urls"]) {
                NSString *picURL = [d objectForKey:@"thumbnail_pic"];
                if(picURL) {
                    [pirURLArray addObject:picURL];
                }
            }
            wb.picIds = pirURLArray;
        } else {
            wb.picIds = nil;
        }
        
        wb.user = [WeiboUser userWithDictionary:[dict objectForKey:@"user"]];
        if([dict objectForKey:@"retweeted_status"] && re == NO) {
            wb.repo = [Weibo weiboWithDictionary:[dict objectForKey:@"retweeted_status"] isRepo:YES];
            wb.repo.reTweeted = YES;
        }
        
        wb.repoNum = [[dict objectForKey:@"reposts_count"] integerValue];
        wb.commentNum = [[dict objectForKey:@"comments_count"] integerValue];
        wb.likedNum = [[dict objectForKey:@"attitudes_count"] integerValue];
    } else {
        return nil;
    }
    return wb;
}

@end
