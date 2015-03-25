//
//  WeiboCell.h
//  WB
//
//  Created by ziggear on 15-1-19.
//  Copyright (c) 2015年 ziggear. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Weibo;

@protocol WeiboCellDelegate <NSObject>
- (void)cellDidClickedImage:(NSInteger)imageIndex withWeibo:(Weibo *)weibo;
@end


@interface WeiboCell : UITableViewCell
@property IBOutlet UIImageView *avatarImage;
@property IBOutlet UILabel *nameLabel;
@property IBOutlet UILabel *timeLabel;
@property IBOutlet UILabel *weiboContent;
@property (nonatomic, strong) Weibo *weibo;
@property (nonatomic, assign) int maxTextWidth;

@property (nonatomic, weak) id<WeiboCellDelegate> delegate;

+ (int)calculateCellHeightForObject:(Weibo *)weibo;
- (void)tapped:(UITapGestureRecognizer *)sender;

@end
