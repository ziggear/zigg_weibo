//
//  WBAuth.h
//  WB
//
//  Created by ziggear on 15-1-19.
//  Copyright (c) 2015年 ziggear. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface WBAuth : NSObject
@property NSString *oauthCode;
@property NSString *accessToken;
@property NSString *uid;
+(WBAuth *)sharedAuth;
- (void)showAuthPage;
- (void)load;
- (void)save;
@end
