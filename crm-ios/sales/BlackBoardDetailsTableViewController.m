//
//  BlackBoardDetailsTableViewController.m
//  sales
//
//  Created by user on 2017/2/15.
//  Copyright © 2017年 rayootech. All rights reserved.
//

#import "BlackBoardDetailsTableViewController.h"
#import "Config.h"
#import "SalesApi.h"
#import "Comment.h"
#import "CircleDetailsTableViewCell.h"
#import "BlackBoardDetailsHeaderView.h"
#import <MJRefresh.h>
#import <MJExtension.h>
#import <AFNetworking.h>
#import <SDAutoLayout.h>
#import <MBProgressHUD.h>

#define kCircleDetailsTableCellId @"CircleDetailsTableViewCell"

@interface BlackBoardDetailsTableViewController ()
@property (nonatomic, strong) MBProgressHUD *hud;
@property (nonatomic,assign) NSInteger p;
@property (nonatomic,assign) NSInteger isRefresh;
@end

@implementation BlackBoardDetailsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _p = 0;
    _isRefresh = 0;
    self.tableView.separatorColor = [UIColor lightGrayColor];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self getCommentList];
    }];
    BlackBoardDetailsHeaderView *headView = [BlackBoardDetailsHeaderView new];
    headView.model = _blackBoard;
    self.tableView.tableHeaderView = headView;
    [self getCommentList];
    
}
- (void)getCommentList{
    NSString *userId = [NSString stringWithFormat:@"%ld",[Config getOrgUserID]];;
    NSString *token = [Config getToken];
    NSString *dbid = [NSString stringWithFormat:@"%ld",[Config getDbID]];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    
    NSString* urlStr = [NSString stringWithFormat:@"%@%@",BASE_URL,API_BLACKBOARD_COMMENT_LIST];
    NSInteger postid = _blackBoard.id;
    _p = _p + 1;
    NSString *page = [NSString stringWithFormat:@"%ld",_p];
    NSLog(@"page--%@",page);
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"POST" URLString:urlStr parameters:@{@"page":page,@"pagenum":@"10",@"postid":[NSString stringWithFormat:@"%ld",postid]}                                                                                   error:nil];//912
    [request addValue:userId forHTTPHeaderField:@"userId"];
    [request addValue:token forHTTPHeaderField:@"token"];
    [request addValue:dbid forHTTPHeaderField:@"dbid"];
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id _Nonnull responseObject, NSError *error) {
        if (error) {
            NSLog(@"Error:-->%@", error);
            [self.tableView.mj_footer endRefreshing];
        } else {
            NSString *responseString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            NSLog(@"DATA-->%@", responseString);
            if (responseObject) {
                NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
                if ([dictionary[@"result"] intValue] == 1) {
                    NSArray* data = dictionary[@"data"];
                    NSArray* modelArray = [Comment mj_objectArrayWithKeyValuesArray:data];
                    if (modelArray.count < 1) {
                        [self.tableView.mj_footer endRefreshingWithNoMoreData];
                    } else {
                        [self.tableView.mj_footer endRefreshing];
                    }
                    if (_isRefresh == 0) {
                        [self.dataModels removeAllObjects];
                        _isRefresh = 1;
                    }
                    [self.dataModels addObjectsFromArray:modelArray];
                    [self.tableView reloadData];
                }else{
                    [self.tableView.mj_footer endRefreshing];
                }
            }else{
                [self.tableView.mj_footer endRefreshing];
            }
        }
    }];
    [dataTask resume];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)reloadCommentList{
    _p = 0;
    _isRefresh = 0;
    [self getCommentList];
}
#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(self.dataModels.count == 0){
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }else{
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    }
    
    return self.dataModels.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CircleDetailsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCircleDetailsTableCellId];
    if (!cell) {
        cell = [[CircleDetailsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCircleDetailsTableCellId];
    }
    cell.indexPath = indexPath;
    cell.model = self.dataModels[indexPath.row];
    cell.type = 2;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // >>>>>>>>>>>>>>>>>>>>> * cell自适应 * >>>>>>>>>>>>>>>>>>>>>>>>
    id model = self.dataModels[indexPath.row];
    return [self.tableView cellHeightForIndexPath:indexPath model:model keyPath:@"model" cellClass:[CircleDetailsTableViewCell class] contentViewWidth:[self cellContentViewWith]];
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Comment *comment = self.dataModels[indexPath.row];
    if (self.didBlackBoardCommentSelected) {
        self.didBlackBoardCommentSelected(comment);
    }
    
}
- (CGFloat)cellContentViewWith
{
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    
    // 适配ios7横屏
    if ([UIApplication sharedApplication].statusBarOrientation != UIInterfaceOrientationPortrait && [[UIDevice currentDevice].systemVersion floatValue] < 8) {
        width = [UIScreen mainScreen].bounds.size.height;
    }
    return width;
}
- (NSMutableArray *)dataModels {
    if(_dataModels == nil) {
        _dataModels = [NSMutableArray array];
    }
    return _dataModels;
}

#pragma mark - scrollView
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.tableView && self.didScroll) {
        self.didScroll();
    }
}


@end

