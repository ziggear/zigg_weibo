//
//  OAuthViewController.h
//  WB
//
//  Created by ziggear on 15-1-19.
//  Copyright (c) 2015年 ziggear. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol OAuthViewControllerDelegate <NSObject>

- (void)oauthSuccess;
- (void)oauthFail;
- (void)getAccessToken;
- (void)getAccessTokenFail;

@end

@interface OAuthViewController : UIViewController
@property (nonatomic, weak) id<OAuthViewControllerDelegate> delegate;
@end
