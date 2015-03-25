//
//  WeiboRepoView.m
//  WB
//
//  Created by ziggear on 15-1-30.
//  Copyright (c) 2015年 ziggear. All rights reserved.
//

#import "WeiboRepoView.h"
#import "Weibo.h"
#import "WeiboUser.h"
#import "UIImageView+WebCache.h"
#import "UIImage+ImageEffects.h"

#define CONTENT_PAD 8
#define IMAGE_WIDTH 64
#define REPO_WIDTH  160

@implementation WeiboRepoView
@synthesize weibo;

- (void)awakeFromNib {
    [super awakeFromNib];
    
    //self.layer.cornerRadius = 2;
    self.clipsToBounds = YES;
    self.maxTextWidth = 280;
}

- (void)setWeibo:(Weibo *)_weibo {
    weibo = _weibo;
    
    for(UIView *v in self.subviews) {
        if([v isKindOfClass:[UIImageView class]]) {
            [v removeFromSuperview];
        }
    }
    
    [self.avatarImage sd_setImageWithURL:[NSURL URLWithString:weibo.user.profileImage]];
    self.nameLabel.text = weibo.user.userName;
    self.weiboContent.text = weibo.weiboContent;
    self.timeLabel.text = weibo.postTime;
    
    int basicHeight = 48;
    CGSize textSize = [weibo.weiboContent sizeWithFont:[UIFont systemFontOfSize:12] constrainedToSize:CGSizeMake(280, self.maxTextWidth) lineBreakMode:NSLineBreakByTruncatingTail];
    basicHeight += textSize.height;
    
    if(weibo.picIds && weibo.picIds.count > 0) {
        for(NSString *picURL in weibo.picIds) {
            NSInteger index = [weibo.picIds indexOfObject:picURL];
            NSInteger row = (NSInteger)(index / 3);
            NSInteger col = (NSInteger)(index % 3);
            
            UIImageView *imgv = [[UIImageView alloc] initWithFrame:CGRectMake(CONTENT_PAD + col * (IMAGE_WIDTH + CONTENT_PAD), basicHeight + row * (IMAGE_WIDTH + CONTENT_PAD) + CONTENT_PAD, IMAGE_WIDTH, IMAGE_WIDTH)];
            imgv.backgroundColor = [UIColor lightGrayColor];
            imgv.contentMode = UIViewContentModeScaleAspectFill;
            imgv.clipsToBounds = YES;
            imgv.tag = index;
            [imgv sd_setImageWithURL:[NSURL URLWithString:picURL]];
            
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
            tap.delegate = self;
            [imgv addGestureRecognizer:tap];
            imgv.userInteractionEnabled = YES;
            
            [self addSubview:imgv];
        }
    }
    
    self.backgroundColor = [UIColor colorWithRed:229/255.0 green:227/255.0 blue:227/255.0 alpha:1];
    self.frame = CGRectMake(0, 0, self.frame.size.width, [WeiboRepoView calculateRepoCellHeightForObject:weibo]);
}

+ (int)calculateRepoCellHeightForObject:(Weibo *)weibo {
    int basicHeight = 48;
    CGSize textSize = [weibo.weiboContent sizeWithFont:[UIFont systemFontOfSize:12] constrainedToSize:CGSizeMake(280, MAXFLOAT) lineBreakMode:NSLineBreakByTruncatingTail];
    basicHeight += textSize.height + CONTENT_PAD;
    if(weibo.picIds && weibo.picIds.count > 0) {
        int rows = (weibo.picIds.count % 3 == 0) ? (int)(weibo.picIds.count / 3) : (int)((weibo.picIds.count / 3) + 1);
        int imageHeight = rows * (IMAGE_WIDTH + CONTENT_PAD);
        basicHeight += imageHeight + CONTENT_PAD;
    }
    return basicHeight;
}

@end
