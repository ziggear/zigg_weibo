//
//  WBAPI.m
//  WB
//
//  Created by ziggear on 15-1-19.
//  Copyright (c) 2015年 ziggear. All rights reserved.
//

#import "WBAPI.h"
#import "AFHTTPRequestOperationManager.h"
#import "Weibo.h"

@implementation WBAPI

+ (void)getTimelineWithToken:(NSString *)accessToken page:(int)pageNum completion:(void (^)(id))comp {
    [self getTimelineWithToken:accessToken page:pageNum max:nil completion:comp];
}

+ (void)getTimelineWithToken:(NSString *)accessToken page:(int)pageNum max:(NSString *)maxId completion:(void (^)(id responseObject))comp {
    
    int64_t max = [maxId longLongValue];
    max ++;
    if(maxId == nil) {
        max = 0;
    }
    
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:@"1206738583", @"source",
                            accessToken, @"access_token",
                            [NSString stringWithFormat:@"%lld", max], @"max_id",
                            @"20", @"count",
                            nil];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:@"https://api.weibo.com/2/statuses/friends_timeline.json" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //NSLog(@"JSON: %@", responseObject);
        NSMutableArray *weiboArray = [NSMutableArray array];
        for (NSDictionary *status in [responseObject objectForKey:@"statuses"]) {
            Weibo *w = [Weibo weiboWithDictionary:status];
            if(w) {
                [weiboArray addObject:w];
            }
        }
        comp(weiboArray);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

@end
