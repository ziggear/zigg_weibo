//
//  WeiboCell.m
//  WB
//
//  Created by ziggear on 15-1-19.
//  Copyright (c) 2015年 ziggear. All rights reserved.
//

#import "WeiboCell.h"
#import "Weibo.h"
#import "WeiboUser.h"
#import "UIImageView+WebCache.h"
#import <QuartzCore/QuartzCore.h>

#import "UIImage+ImageEffects.h"
#import "WeiboRepoView.h"

@interface WeiboCell () <WeiboCellDelegate, UIGestureRecognizerDelegate>
@property (nonatomic, strong) WeiboCell *repoCell;
@end

@implementation WeiboCell

- (void)awakeFromNib {
    // Initialization code
    //self.avatarImage.layer.cornerRadius = 15;
    self.avatarImage.clipsToBounds = YES;
    self.avatarImage.layer.borderWidth = 1;
    self.avatarImage.layer.borderColor = [UIColor colorWithRed:0.0f/255.0f green:118.0f/255.0f blue:255.0f/255.0f alpha:0.2].CGColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#define CONTENT_PAD         8
#define IMAGE_WIDTH         64
#define SINGLE_IMAGE_WIDTH  167
#define SINGLE_IMAGE_HEIGHT 103
#define REPO_WIDTH          160

- (void)setWeibo:(Weibo *)weibo {
    _weibo = weibo;
    
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
    CGSize textSize = [weibo.weiboContent sizeWithFont:[UIFont systemFontOfSize:12] constrainedToSize:CGSizeMake(304, self.maxTextWidth) lineBreakMode:NSLineBreakByTruncatingTail];
    basicHeight += textSize.height;
    
    if(weibo.picIds.count == 1) {
        
        NSInteger index = 0;
        NSInteger row = (NSInteger)(index / 3);
        NSInteger col = (NSInteger)(index % 3);
        
        UIImageView *imgv = [[UIImageView alloc] initWithFrame:CGRectMake(CONTENT_PAD + col * (IMAGE_WIDTH + CONTENT_PAD), basicHeight + row * (IMAGE_WIDTH + CONTENT_PAD) + CONTENT_PAD, SINGLE_IMAGE_WIDTH, SINGLE_IMAGE_HEIGHT)];
        imgv.backgroundColor = [UIColor lightGrayColor];
        imgv.contentMode = UIViewContentModeScaleAspectFill;
        imgv.clipsToBounds = YES;
        imgv.tag = index;
        [imgv sd_setImageWithURL:[NSURL URLWithString:[weibo.picIds objectAtIndex:0]]];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
        tap.delegate = self;
        [imgv addGestureRecognizer:tap];
        imgv.userInteractionEnabled = YES;
        
        [self addSubview:imgv];
    } else if(weibo.picIds.count > 1) {
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
    
    if(weibo.repo) {
        if(self.repoCell) {
            [self.repoCell removeFromSuperview];
        }
        
        WeiboRepoView *repoCell = [[[NSBundle mainBundle] loadNibNamed:@"WeiboRepoView" owner:self options:nil] objectAtIndex:0];
        repoCell.weibo = weibo.repo;
        repoCell.delegate = self;
        repoCell.frame = CGRectMake(10, [WeiboCell calculateCellBasicHeightForObject:weibo], repoCell.frame.size.width, repoCell.frame.size.height);
        self.repoCell = repoCell;
        [self.contentView addSubview:repoCell];
    } else {
        if(self.repoCell) {
            [self.repoCell removeFromSuperview];
        }
    }
    
    self.frame = CGRectMake(0, 0, self.frame.size.width, [WeiboCell calculateCellHeightForObject:weibo]);
}

+ (int)calculateCellBasicHeightForObject:(Weibo *)weibo {
    int basicHeight = 48;
    CGSize textSize = [weibo.weiboContent sizeWithFont:[UIFont systemFontOfSize:12] constrainedToSize:CGSizeMake(304, MAXFLOAT) lineBreakMode:NSLineBreakByTruncatingTail];
    basicHeight += textSize.height + CONTENT_PAD;
    if(weibo.picIds.count == 1) {
        int imageHeight = (SINGLE_IMAGE_HEIGHT + CONTENT_PAD);
        basicHeight += imageHeight + CONTENT_PAD;
    } else if(weibo.picIds && weibo.picIds.count > 1) {
        int rows = (weibo.picIds.count % 3 == 0) ? (int)(weibo.picIds.count / 3) : (int)((weibo.picIds.count / 3) + 1);
        int imageHeight = rows * (IMAGE_WIDTH + CONTENT_PAD);
        basicHeight += imageHeight + CONTENT_PAD;
    }
    return basicHeight;
}

+ (int)calculateCellHeightForObject:(Weibo *)weibo {
    //int basicHeight = [self calculateCellBasicHeightForObject:weibo textWidth:200];
    int basicHeight = 48;
    CGSize textSize = [weibo.weiboContent sizeWithFont:[UIFont systemFontOfSize:12] constrainedToSize:CGSizeMake(304, MAXFLOAT) lineBreakMode:NSLineBreakByTruncatingTail];
    basicHeight += textSize.height + CONTENT_PAD;
    if(weibo.picIds.count == 1) {
        int imageHeight = (SINGLE_IMAGE_HEIGHT + CONTENT_PAD);
        basicHeight += imageHeight + CONTENT_PAD;
    } else if(weibo.picIds && weibo.picIds.count > 1) {
        int rows = (weibo.picIds.count % 3 == 0) ? (int)(weibo.picIds.count / 3) : (int)((weibo.picIds.count / 3) + 1);
        int imageHeight = rows * (IMAGE_WIDTH + CONTENT_PAD);
        basicHeight += imageHeight + CONTENT_PAD;
    }
    
    if(weibo.repo) {
        basicHeight += [WeiboRepoView calculateRepoCellHeightForObject:weibo.repo];
    } else {
        basicHeight += CONTENT_PAD;
    }

    return basicHeight + CONTENT_PAD;
}

- (NSString *)reuseIdentifier {
    return @"WeiboCell";
}

- (void)tapped:(UITapGestureRecognizer *)sender {
    if([self.delegate respondsToSelector:@selector(cellDidClickedImage:withWeibo:)]) {
        [self.delegate cellDidClickedImage:sender.view.tag withWeibo:self.weibo];
    }
}

#pragma mark - RepoCell Delegate 

- (void)cellDidClickedImage:(NSInteger)imageIndex withWeibo:(Weibo *)weibo {
    if([self.delegate respondsToSelector:@selector(cellDidClickedImage:withWeibo:)]) {
        [self.delegate cellDidClickedImage:imageIndex withWeibo:weibo];
    }
}

#pragma mark - Gesture Delegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if([touch.view isKindOfClass:[UIImageView class]]) {
        return YES;
    }
    return NO;
}

@end
