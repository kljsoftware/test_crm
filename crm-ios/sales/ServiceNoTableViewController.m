//
//  ServiceNoTableViewController.m
//  sales
//
//  Created by user on 2017/2/8.
//  Copyright © 2017年 rayootech. All rights reserved.
//

#import "ServiceNoTableViewController.h"
#import "ServiceNo.h"
#import "ServiceNoTableViewCell.h"
#import "NoticeDetailsViewController.h"
#import "PaperDetailsViewController.h"
#import "BillTableViewController.h"

#define kServiceNoTableCellId @"ServiceNoTableViewCell"
@interface ServiceNoTableViewController () <ServiceNoCellDelegate>
@property (nonatomic,strong) NSMutableArray *dataModels;
@property (nonatomic, strong) MBProgressHUD *hud;
@property (nonatomic, assign) NSInteger type;
@end

@implementation ServiceNoTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"服务号";
    _type = 0;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"过滤" style:UIBarButtonItemStylePlain target:self action:@selector(filterButtonClicked)];
    
    self.tableView.backgroundColor = [UIColor colorWithHex:0xf2f2f2];    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self getServiceList:YES];
    }];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self getServiceList:NO];
    }];
    [self.tableView.mj_header beginRefreshing];
}

- (void)getServiceList:(BOOL)isRefresh{
    NSString *userId = [NSString stringWithFormat:@"%ld",[Config getOrgUserID]];;
    NSString *token = [Config getToken];
    NSString *dbid = [NSString stringWithFormat:@"%ld",[Config getDbID]];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    
    NSString* urlStr = [NSString stringWithFormat:@"%@%@",BASE_URL,API_SERVICE_LIST];
    NSInteger p = 0;
    p = isRefresh?1:self.dataModels.count / 10 + 1;
//    NSString *page = [NSString stringWithFormat:@"%ld",p];
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"POST" URLString:urlStr parameters:@{@"page":[NSNumber numberWithInteger:p],@"pagenum":@10,@"status":[NSNumber numberWithInteger:_type]}                                                                                    error:nil];
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
                    NSArray* modelArray = [ServiceNo mj_objectArrayWithKeyValuesArray:data];
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
    return self.dataModels.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ServiceNoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kServiceNoTableCellId];
    if (!cell) {
        cell = [[ServiceNoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kServiceNoTableCellId];
    }
    cell.model = self.dataModels[indexPath.row];
    cell.backgroundColor = [UIColor clearColor];
    cell.delegate = self;
    cell.index = indexPath;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat h = [self.tableView cellHeightForIndexPath:indexPath model:self.dataModels[indexPath.row] keyPath:@"model" cellClass:[ServiceNoTableViewCell class] contentViewWidth:[UIScreen mainScreen].bounds.size.width];
    return h;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"---- details");
    BillTableViewController *vc = [[BillTableViewController alloc] init];
    ServiceNo *no = self.dataModels[indexPath.row];
    vc.details = no.detailList;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}
- (NSMutableArray *)dataModels {
    if(_dataModels == nil) {
        _dataModels = [NSMutableArray array];
    }
    return _dataModels;
}
- (void)filterButtonClicked{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction *allAction = [UIAlertAction actionWithTitle:@"全部" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"---quanbu");
        _type = 0;
        [self getServiceList:YES];
    }];
    UIAlertAction *waitAction = [UIAlertAction actionWithTitle:@"待处理" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        _type = 2;
        [self getServiceList:YES];
    }];
    
    UIAlertAction *didAction = [UIAlertAction actionWithTitle:@"已处理" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        _type = 1;
        [self getServiceList:YES];
    }];
    
    [alertController addAction:cancelAction];
    [alertController addAction:allAction];
    [alertController addAction:waitAction];
    [alertController addAction:didAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}
- (void)dealService:(NSIndexPath *)index status:(NSInteger)status{
    ServiceNo *serviceNo = self.dataModels[index.row];    
    NSString *userId = [NSString stringWithFormat:@"%ld",[Config getOrgUserID]];;
    NSString *token = [Config getToken];
    NSString *dbid = [NSString stringWithFormat:@"%ld",[Config getDbID]];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    
    NSString* urlStr = [NSString stringWithFormat:@"%@%@",BASE_URL,API_DEAL_SERVICE];
    //    NSString *page = [NSString stringWithFormat:@"%ld",p];
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"POST" URLString:urlStr parameters:@{@"status":[NSNumber numberWithInteger:status],@"id":[NSNumber numberWithInteger:serviceNo.id]}                                                                                    error:nil];
    [request addValue:userId forHTTPHeaderField:@"userId"];
    [request addValue:token forHTTPHeaderField:@"token"];
    [request addValue:dbid forHTTPHeaderField:@"dbid"];
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id _Nonnull responseObject, NSError *error) {
        if (error) {
            NSLog(@"Error:-->%@", error);
            
        } else {
            NSString *responseString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            NSLog(@"DATA-->%@", responseString);
            if (responseObject) {
                NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
                if ([dictionary[@"result"] intValue] == 1) {
                    serviceNo.status = status;
                }else if([dictionary[@"result"] intValue] == 0){
                    serviceNo.status = 4;
                    _hud = [Utils createHUD];
                    _hud.label.text = @"处理失败";
                    [_hud hideAnimated:YES afterDelay:1];
                }else if([dictionary[@"result"] intValue] == 103){
                    serviceNo.status = 5;
                    _hud = [Utils createHUD];
                    _hud.label.text = @"已处理，请刷新";
                    [_hud hideAnimated:YES afterDelay:1];
                }
                [self.dataModels replaceObjectAtIndex:[index row] withObject:serviceNo];
                [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:index,nil] withRowAnimation:UITableViewRowAnimationNone];
            }else{
                
            }
        }
    }];
    [dataTask resume];

}
@end
