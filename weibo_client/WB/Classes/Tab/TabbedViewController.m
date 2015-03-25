//
//  TabbedViewController.m
//  WB
//
//  Created by ziggear on 15-1-28.
//  Copyright (c) 2015年 ziggear. All rights reserved.
//

#import "TabbedViewController.h"
#import "ViewController.h"
#import "MessageViewController.h"
#import "ProfileViewController.h"

@interface TabbedViewController () <UITabBarControllerDelegate>
@property (nonatomic, strong) UINavigationController *weiboViewController;
@property (nonatomic, strong) UINavigationController *messageViewController;
@property (nonatomic, strong) UINavigationController *profileViewController;
@end

@implementation TabbedViewController

- (void)dealloc {
    [self removeObserver:self forKeyPath:@"selectedIndex"];
}

- (instancetype)init {
    if(self = [super init]) {
        ViewController *v = [[ViewController alloc] init];
        UITabBarItem *aBarItem = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemRecents tag:0];
        v.tabBarItem.image = aBarItem.selectedImage;
        v.title = @"微博";
        self.weiboViewController = v;
        
        MessageViewController *m = [[MessageViewController alloc] init];
        UITabBarItem *bBarItem = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemDownloads tag:0];
        m.tabBarItem.image = bBarItem.selectedImage;
        m.title = @"消息";
        self.messageViewController = m;
        
        ProfileViewController *p = [[ProfileViewController alloc] init];
        UITabBarItem *cBarItem = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemContacts tag:0];
        p.tabBarItem.image = cBarItem.selectedImage;
        p.title = @"资料";
        self.profileViewController = p;
        
        [self addChildViewController:self.weiboViewController];
        [self addChildViewController:self.messageViewController];
        [self addChildViewController:self.profileViewController];
        
        self.delegate = self;
        self.title = @"微博";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.edgesForExtendedLayout = UIRectEdgeAll;
    self.automaticallyAdjustsScrollViewInsets = YES;
    self.extendedLayoutIncludesOpaqueBars = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    if([viewController isEqual:self.weiboViewController]) {
        self.title = @"微博";
    } else if ([viewController isEqual:self.messageViewController]) {
        self.title = @"消息";
    } else if ([viewController isEqual:self.profileViewController]) {
        self.title = @"资料";
    }
}

@end
