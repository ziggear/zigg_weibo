//
//  WBAPI.h
//  WB
//
//  Created by ziggear on 15-1-19.
//  Copyright (c) 2015年 ziggear. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WBAPI : NSObject
+ (void)getTimelineWithToken:(NSString *)accessToken page:(int)pageNum completion:(void (^)(id responseObject))comp;
+ (void)getTimelineWithToken:(NSString *)accessToken page:(int)pageNum max:(NSString *)maxId completion:(void (^)(id responseObject))comp;
@end
