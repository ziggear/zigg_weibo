//
//  ViewController.m
//  WB
//
//  Created by ziggear on 15-1-19.
//  Copyright (c) 2015年 ziggear. All rights reserved.
//

#import "ViewController.h"
#import "OAuthViewController.h"
#import "WBAuth.h"
#import "WBAPI.h"
#import "WeiboCell.h"

#import "Weibo.h"
#import "BigImageViewController.h"

#import "EGORefreshTableHeaderView.h"

@interface ViewController () <UITableViewDataSource, UITableViewDelegate, WeiboCellDelegate, EGORefreshTableHeaderDelegate>

@property NSMutableArray *responseData;
@property IBOutlet UITableView *weiboTable;
@property (nonatomic, assign) int curpage;
@property (nonatomic, strong) EGORefreshTableHeaderView *tableHeader;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.edgesForExtendedLayout = UIRectEdgeAll;
    self.automaticallyAdjustsScrollViewInsets = YES;
    self.extendedLayoutIncludesOpaqueBars = NO;
    
    self.title = @"微博";
    self.weiboTable.delegate = self;
    self.weiboTable.dataSource = self;
    self.weiboTable.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    
    self.tableHeader = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0, -self.weiboTable.bounds.size.height, self.weiboTable.bounds.size.width, self.weiboTable.bounds.size.height)];
    self.tableHeader.delegate = self;
    [self.weiboTable addSubview:self.tableHeader];
}

static BOOL loadOnce = NO;
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if([WBAuth sharedAuth].accessToken == nil) {
        [[WBAuth sharedAuth] showAuthPage];
    } else if (loadOnce == NO){
        [self loadNew];
        loadOnce = YES;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.responseData ? self.responseData.count : 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    NSArray *stats = self.responseData;
    Weibo *weibo = [stats objectAtIndex:indexPath.row];

    WeiboCell *theCell = [tableView dequeueReusableCellWithIdentifier:@"WeiboCell"];
    if(!theCell) {
        [tableView registerNib:[UINib nibWithNibName:@"WeiboCell" bundle:nil] forCellReuseIdentifier:@"WeiboCell"];
        theCell = [tableView dequeueReusableCellWithIdentifier:@"WeiboCell"];
    }
    
    theCell.maxTextWidth = 200;
    [theCell setWeibo:weibo];
    theCell.delegate = self;
    cell = theCell;
    
    if ([[stats lastObject] isEqual:weibo]) {
        [self loadNext];
    }

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [WeiboCell calculateCellHeightForObject:[self.responseData objectAtIndex:indexPath.row]];
}

- (void)loadNew {
    [WBAPI getTimelineWithToken:[WBAuth sharedAuth].accessToken page:1 completion:^(id responseObject) {
        self.curpage = 1;
        self.responseData = responseObject;
        [self.weiboTable reloadData];
    }];
}

- (void)loadNext {
    if(self.responseData) {
        NSArray *oldStats = self.responseData;
        Weibo *weibo = [oldStats lastObject];
        NSString *s = [NSString stringWithFormat:@"%@", weibo.weiboId];
        [WBAPI getTimelineWithToken:[WBAuth sharedAuth].accessToken page:(self.curpage+1) max:s completion:^(id responseObject) {
            self.curpage += 1;
            
            NSMutableArray *arr = [NSMutableArray arrayWithArray:oldStats];
            [arr addObjectsFromArray:responseObject];
            
            self.responseData = arr;
            [self.weiboTable reloadData];
            
            UIAlertView *al = [[UIAlertView alloc] initWithTitle:@"微信安全支付" message:@"继续流量，请支付章颢1元" delegate:self cancelButtonTitle:@"关闭并支付" otherButtonTitles:@"确定并支付", nil];
            [al show];
        }];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)cellDidClickedImage:(NSInteger)imageIndex withWeibo:(Weibo *)weibo {
    BigImageViewController *bm = [[BigImageViewController alloc] initWithWeibo:weibo pageIndex:imageIndex];
    [self.navigationController pushViewController:bm animated:YES];
}

#pragma mark - 

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.tableHeader egoRefreshScrollViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self.tableHeader egoRefreshScrollViewDidEndDragging:scrollView];
}

- (void) scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    //[self.tableHeader egoRefreshScrollViewWillBeginDragging:scrollView];
}

#pragma mark - 


static BOOL loading;

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView *)view {
    return loading;
}

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView *)view {
    loading = YES;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        sleep(2);
        dispatch_async(dispatch_get_main_queue(), ^{
            loading = NO;
        });
    });
}



@end
