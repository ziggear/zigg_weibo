//
//  WeiboUser.m
//  WB
//
//  Created by ziggear on 15-1-23.
//  Copyright (c) 2015年 ziggear. All rights reserved.
//

#import "WeiboUser.h"

@implementation WeiboUser

+ (instancetype)userWithDictionary:(NSDictionary *)dict {
    WeiboUser *user = [[WeiboUser alloc] init];
    if([dict objectForKey:@"profile_image_url"]) {
        user.profileImage = [dict objectForKey:@"profile_image_url"];
        user.userName = [dict objectForKey:@"name"];
    }
    return user;
}

@end
