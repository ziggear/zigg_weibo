//
//  Weibo.h
//  WB
//
//  Created by ziggear on 15-1-23.
//  Copyright (c) 2015年 ziggear. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WeiboUser;

@interface Weibo : NSObject

@property (nonatomic, strong) NSString *weiboId;
@property (nonatomic, strong) NSString *weiboContent;
@property (nonatomic, strong) NSString *postTime;
@property (nonatomic, strong) NSString *miniPicURL;
@property (nonatomic, strong) NSArray *picIds;

@property (nonatomic, strong) Weibo *repo;
@property (nonatomic, strong) WeiboUser *user;
@property (nonatomic, assign) BOOL reTweeted;

@property (nonatomic, assign) NSInteger repoNum;
@property (nonatomic, assign) NSInteger commentNum;
@property (nonatomic, assign) NSInteger likedNum;

+ (instancetype) weiboWithDictionary:(NSDictionary *)dict ;

@end
