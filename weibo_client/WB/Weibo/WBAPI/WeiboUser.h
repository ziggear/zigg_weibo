//
//  WeiboUser.h
//  WB
//
//  Created by ziggear on 15-1-23.
//  Copyright (c) 2015年 ziggear. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WeiboUser : NSObject

@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *profileImage;

+ (instancetype)userWithDictionary:(NSDictionary *)dict;

@end
