//
//  BigImageViewController.h
//  WB
//
//  Created by ziggear on 15-1-28.
//  Copyright (c) 2015年 ziggear. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Weibo;
@interface BigImageViewController : UIViewController
- (id)initWithWeibo:(Weibo *)weibo pageIndex:(NSInteger)page;
@end
