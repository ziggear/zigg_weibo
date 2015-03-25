//
//  BigImageViewController.m
//  WB
//
//  Created by ziggear on 15-1-28.
//  Copyright (c) 2015年 ziggear. All rights reserved.
//

#import "BigImageViewController.h"
#import "Weibo.h"
#import "UIImageView+WebCache.h"

@interface BigImageViewController ()
@property (nonatomic, strong) Weibo *weibo;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, strong) UIScrollView *scrollView;
@end

@implementation BigImageViewController

- (id)initWithWeibo:(Weibo *)weibo pageIndex:(NSInteger)page {
    if (self = [super init]) {
        self.weibo = weibo;
        self.page = page;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    self.scrollView.pagingEnabled = YES;
    self.scrollView.bounces = YES;
    self.scrollView.scrollEnabled = YES;
    self.scrollView.contentSize = CGSizeMake(320 * self.weibo.picIds.count, self.view.bounds.size.height - 120);
    
    for(NSString *picId in self.weibo.picIds) {
        NSInteger idx = [self.weibo.picIds indexOfObject:picId];
        UIImageView *imgv = [[UIImageView alloc] initWithFrame:CGRectMake(idx * self.scrollView.bounds.size.width, 0, self.view.bounds.size.width, self.view.bounds.size.height - 120)];
        imgv.contentMode = UIViewContentModeScaleAspectFit;
        NSString *largeURL = [picId stringByReplacingOccurrencesOfString:@"/thumbnail/" withString:@"/large/"];
        [imgv sd_setImageWithURL:[NSURL URLWithString:largeURL]];
        [self.scrollView addSubview:imgv];
    }
    
    
    [self.view addSubview:self.scrollView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self.scrollView setContentOffset:CGPointMake(self.page * self.scrollView.bounds.size.width, self.scrollView.contentOffset.y) animated:NO];
}

@end
