//
//  INewsTableViewController.m
//  sales
//
//  Created by user on 2017/1/18.
//  Copyright © 2017年 rayootech. All rights reserved.
//

#import "INewsTableViewController.h"
#import "NewsDetailsViewController.h"
#import "News.h"
#import "NewsTableViewCell.h"
@interface INewsTableViewController () <FSPagerViewDelegate, FSPagerViewDataSource>

@property (nonatomic,strong) NSMutableArray *dataModels;

@property (nonatomic, strong) NSMutableArray *bannerModels;
@property (nonatomic, strong) FSPagerView *pagerView;
@property (nonatomic, strong) FSPageControl *pageControl;

@end

static NSString * const kNewsTableViewCellId = @"NewsTableViewCell";

@implementation INewsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.backgroundColor = [UIColor colorWithHex:0xf2f2f2];
    self.tableView.rowHeight = 110;
    self.tableView.tableHeaderView = self.pagerView;
    self.tableView.tableFooterView = [UIView new];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([NewsTableViewCell class]) bundle:nil] forCellReuseIdentifier:kNewsTableViewCellId];

    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self getNewsList:YES];
    }];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self getNewsList:NO];
    }];
    self.tableView.mj_header.automaticallyChangeAlpha = YES;
    [self.tableView.mj_header beginRefreshing];
}

- (void)getNewsList:(BOOL)isRefresh {
    
    NSString* urlStr = [NSString stringWithFormat:@"%@%@",BASE_URL,API_NEWS_LIST];
    NSInteger p = isRefresh ? 1 : self.dataModels.count / 10 + 1;
    NSDictionary *requestHeader = @{@"userId":[NSString stringWithFormat:@"%lld",[Config getOwnID]], @"token":[Config getToken], @"dbid":[NSString stringWithFormat:@"%ld",[Config getDbID]]};
    [NetWorkManager request:POST_METHOD URL:urlStr requestHeader:requestHeader parameters:@{@"page":[NSString stringWithFormat:@"%ld",p], @"pagenum":@"10"} success:^(NSURLSessionDataTask *task, id responseObject) {
        
        if (isRefresh) { // 下拉得到的数据
            [self.dataModels removeAllObjects];
        }
        NSArray* data = responseObject[@"data"];
        NSArray* modelArray = [News mj_objectArrayWithKeyValuesArray:data];
        [self.dataModels addObjectsFromArray:modelArray];
        if (isRefresh) {
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
        }
        if (modelArray.count < 10) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
        _pagerView.hidden = self.bannerModels.count == 0;
        [self.pagerView reloadData];
        [self.tableView reloadData];
        
    } failure:^(NSURLSessionDataTask *task, BIUPError *error) {
        
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataModels.count;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NewsDetailsViewController *vc = [[NewsDetailsViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    News *paper = self.dataModels[indexPath.row];
    vc.url = paper.source;
    [self.navigationController pushViewController:vc animated:YES];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NewsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kNewsTableViewCellId];
    if (!cell) {
        cell = [[NewsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kNewsTableViewCellId];
    }
    News *model = self.dataModels[indexPath.row];
    cell.model = model;
    return cell;
}
- (NSMutableArray *)dataModels {
    if(_dataModels == nil) {
        _dataModels = [NSMutableArray array];
    }
    return _dataModels;
}

// MARK: - ======= FSPagerView 相关 =======
// 懒加载
- (FSPagerView *)pagerView {
    if (!_pagerView) {
        _pagerView = [[FSPagerView alloc] initWithFrame:CGRectMake(0, 0, KSCREEN_WIDTH, 180)];
        _pagerView.automaticSlidingInterval = 3.0;
        _pagerView.isInfinite = true;
        _pagerView.itemSize = CGSizeMake(KSCREEN_WIDTH-36, 160);
        _pagerView.interitemSpacing = 10;
        _pagerView.delegate = self;
        _pagerView.dataSource = self;
        [_pagerView registerClass:[FSPagerViewCell class] forCellWithReuseIdentifier:@"kFSPagerViewCell"];
        _pagerView.hidden = true;
        
        _pageControl = [[FSPageControl alloc] initWithFrame:CGRectMake(KSCREEN_WIDTH-100, 180-40, 100, 30)];
        _pageControl.numberOfPages = 5;
        _pageControl.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        _pageControl.contentInsets = UIEdgeInsetsMake(0, 20, 0, 30);
        [_pagerView addSubview:_pageControl];
    }
    return _pagerView;
}

- (NSMutableArray *)bannerModels {
    if (!_bannerModels) {
        _bannerModels = [[NSMutableArray alloc] init];
    }
    return _bannerModels;
}

// FSPagerView 代理
- (NSInteger)numberOfItemsInPagerView:(FSPagerView *)pagerView {
    return self.bannerModels.count;
}

- (FSPagerViewCell *)pagerView:(FSPagerView *)pagerView cellForItemAtIndex:(NSInteger)index {
    FSPagerViewCell *cell = [pagerView dequeueReusableCellWithReuseIdentifier:@"kFSPagerViewCell" atIndex:index];
//     = self.bannerModels[index];
    cell.imageView.contentMode = UIViewContentModeScaleAspectFill;
    cell.imageView.clipsToBounds = true;
    cell.imageView.layer.cornerRadius = 5;
    cell.imageView.layer.masksToBounds = true;
    cell.textLabel.font = SYSTEM_FONT(14);
    return cell;
}

- (void)pagerView:(FSPagerView *)pagerView didSelectItemAtIndex:(NSInteger)index {
    [pagerView deselectItemAtIndex:index animated:true];
    [pagerView scrollToItemAtIndex:index animated:true];
    self.pageControl.currentPage = index;
    //     = self.bannerModels[index];
}

- (void)pagerViewDidScroll:(FSPagerView *)pagerView {
    if (self.pageControl.currentPage != pagerView.currentIndex) {
        self.pageControl.currentPage = pagerView.currentIndex;
    }
}

@end
