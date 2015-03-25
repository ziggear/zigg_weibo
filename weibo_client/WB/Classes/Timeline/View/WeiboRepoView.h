//
//  WeiboRepoView.h
//  WB
//
//  Created by ziggear on 15-1-30.
//  Copyright (c) 2015年 ziggear. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeiboCell.h"

@interface WeiboRepoView : WeiboCell
@property (nonatomic, strong) Weibo *weibo;

+ (int)calculateRepoCellHeightForObject:(Weibo *)weibo;

@end
