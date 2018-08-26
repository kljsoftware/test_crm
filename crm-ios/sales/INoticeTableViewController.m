//
//  INoticeTableViewController.m
//  sales
//
//  Created by user on 2017/1/17.
//  Copyright © 2017年 rayootech. All rights reserved.
//

#import "INoticeTableViewController.h"
#import "Notice.h"
#import "NoticeTableViewCell.h"
#import "NoticeDetailsViewController.h"
#import "PaperDetailsViewController.h"
#define kNoticeTableCellId @"NoticeTableViewCell"
@interface INoticeTableViewController ()

@property (nonatomic,strong) NSMutableArray *dataModels;

@end

@implementation INoticeTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.backgroundColor = [UIColor colorWithHex:0xf2f2f2];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView.rowHeight = 60;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self getNoticeList:YES];
    }];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self getNoticeList:NO];
    }];
    self.tableView.mj_header.automaticallyChangeAlpha = YES;
    [self.tableView.mj_header beginRefreshing];
}
- (void)getNoticeList:(BOOL)isRefresh{
    NSString *userId = [NSString stringWithFormat:@"%ld",[Config getOrgUserID]];;
    NSString *token = [Config getToken];
    NSString *dbid = [NSString stringWithFormat:@"%ld",[Config getDbID]];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    
    NSString* urlStr = [NSString stringWithFormat:@"%@%@",BASE_URL,API_NOTICE_LIST];
    NSInteger p = 0;
    p = isRefresh?1:self.dataModels.count / 10 + 1;
    NSString *page = [NSString stringWithFormat:@"%ld",p];
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"POST" URLString:urlStr parameters:@{@"page":page,@"pagenum":@"10"}                                                                                    error:nil];
    [request addValue:userId forHTTPHeaderField:@"userId"];
    [request addValue:token forHTTPHeaderField:@"token"];
    [request addValue:dbid forHTTPHeaderField:@"dbid"];
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id _Nonnull responseObject, NSError *error) {
        if (error) {
            NSLog(@"Error:-->%@", error);
            if (isRefresh) {
                [self.tableView.mj_header endRefreshing];
            } else{
                [self.tableView.mj_footer endRefreshing];
            }
        } else {
            NSString *responseString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            NSLog(@"DATA-->%@", responseString);
            if (responseObject) {
                NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
                if ([dictionary[@"result"] intValue] == 1) {
                    
                    if (isRefresh) {//下拉得到的数据
                        [self.dataModels removeAllObjects];
                    }
                    
                    NSArray* data = dictionary[@"data"];
                    NSArray* modelArray = [Notice mj_objectArrayWithKeyValuesArray:data];
                    [self.dataModels addObjectsFromArray:modelArray];
                    if (isRefresh) {
                        [self.tableView.mj_header endRefreshing];
                        if(modelArray.count < 10){
                            [self.tableView.mj_footer endRefreshingWithNoMoreData];
                        }
                    } else {
                        if (modelArray.count < 10) {
                            [self.tableView.mj_footer endRefreshingWithNoMoreData];
                        } else {
                            [self.tableView.mj_footer endRefreshing];
                        }
                    }
                    NSLog(@"-----%ld",self.dataModels.count);
                    [self.tableView reloadData];
                }else{
                    if (isRefresh) {
                        [self.tableView.mj_header endRefreshing];
                    } else {
                        [self.tableView.mj_footer endRefreshing];
                    }
                }
            }else{
                if (isRefresh) {
                    [self.tableView.mj_header endRefreshing];
                } else {
                    [self.tableView.mj_footer endRefreshing];
                }
            }
        }
    }];
    [dataTask resume];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    
    NoticeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kNoticeTableCellId];
    if (!cell) {
        cell = [[NoticeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kNoticeTableCellId];
    }
    cell.model = self.dataModels[indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NoticeDetailsViewController *vc = [[NoticeDetailsViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.notice = self.dataModels[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}
- (NSMutableArray *)dataModels {
    if(_dataModels == nil) {
        _dataModels = [NSMutableArray array];
    }
    return _dataModels;
}

@end
