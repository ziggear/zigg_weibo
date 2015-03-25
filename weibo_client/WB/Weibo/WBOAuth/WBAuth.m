//
//  WBAuth.m
//  WB
//
//  Created by ziggear on 15-1-19.
//  Copyright (c) 2015年 ziggear. All rights reserved.
//

#import "WBAuth.h"
#import "OAuthViewController.h"

@interface WBAuth () <OAuthViewControllerDelegate>
@property UINavigationController *othNav;
@end

@implementation WBAuth

+(WBAuth *)sharedAuth {
    static dispatch_once_t pred;
    static WBAuth *shared = nil;
    
    dispatch_once(&pred, ^{
        shared = [[WBAuth alloc] init];
    });
    return shared;
}

-(id)init{
    self = [super init];
    if(self) {
        [self load];
    }
    return self;
}

- (void)dealloc {
    [self save];
}

- (void)load {
    NSString *path = [NSHomeDirectory() stringByAppendingString:@"/Documents/auth.plist"];
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:path];
    if([dict objectForKey:@"oauthCode"]) {
        self.oauthCode = [dict objectForKey:@"oauthCode"];
    }
    
    if([dict objectForKey:@"accessToken"]) {
        self.accessToken = [dict objectForKey:@"accessToken"];
    }
    
    if([dict objectForKey:@"uid"]) {
        self.uid = [dict objectForKey:@"uid"];
    }
}

- (void)save {
    NSString *path = [NSHomeDirectory() stringByAppendingString:@"/Documents/auth.plist"];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    if(self.oauthCode) {
        [dict setObject:self.oauthCode forKey:@"oauthCode"];
    }
    
    if(self.accessToken) {
        [dict setObject:self.accessToken forKey:@"accessToken"];
    }
    
    if(self.uid) {
        [dict setObject:self.uid forKey:@"uid"];
    }
    
    [dict writeToFile:path atomically:YES];
}

- (void)showAuthPage {
    UINavigationController *navc = (UINavigationController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController *vc = navc.topViewController;
    if(vc) {
        OAuthViewController *oth = [[OAuthViewController alloc] init];
        oth.delegate = self;
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:oth];
        [vc presentViewController:nav animated:YES completion:nil];
        
        self.othNav = nav;
    }
}

- (void)getAccessToken {
    if(self.othNav) {
        [self.othNav dismissViewControllerAnimated:YES completion:^{
            self.othNav = nil;
        }];
    }
}

- (void)getAccessTokenFail {
    
}

- (void)oauthSuccess {
    
}

- (void)oauthFail {
    
}

@end
