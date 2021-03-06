//
//  CustomerDupTableViewController.m
//  sales
//
//  Created by user on 2017/3/22.
//  Copyright © 2017年 rayootech. All rights reserved.
//
// 客户查重
#import "CustomerDupTableViewController.h"
#import "CustomerDupTableViewCell.h"
#define kCustomerDupTableCellId @"CustomerDupTableViewCell"
@interface CustomerDupTableViewController ()

@property (nonatomic,strong) NSMutableArray *dataModels;

@end

@implementation CustomerDupTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"客户查重";
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self getCustomerDup];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)getCustomerDup{
    NSString *userId = [NSString stringWithFormat:@"%ld",[Config getOrgUserID]];;
    NSString *token = [Config getToken];
    NSString *dbid = [NSString stringWithFormat:@"%ld",[Config getDbID]];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    
    NSString* urlStr = [NSString stringWithFormat:@"%@%@",BASE_URL,API_CUSTOMER_DUP];
    
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"POST" URLString:urlStr parameters:@{@"tel":_customer.mobile}                                                                                    error:nil];
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
                    [self.dataModels removeAllObjects];
                    NSArray* data = dictionary[@"data"];
                    NSArray* modelArray = [Customer mj_objectArrayWithKeyValuesArray:data];
                    [self.dataModels addObjectsFromArray:modelArray];
                    [self.tableView reloadData];
                }else{
                    
                }
            }else{
                
            }
        }
    }];
    [dataTask resume];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataModels.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CustomerDupTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCustomerDupTableCellId];
    if (!cell) {
        cell = [[CustomerDupTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCustomerDupTableCellId];
    }
    cell.model = self.dataModels[indexPath.row];
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat h = [self.tableView cellHeightForIndexPath:indexPath model:self.dataModels[indexPath.row] keyPath:@"model" cellClass:[CustomerDupTableViewCell class] contentViewWidth:[UIScreen mainScreen].bounds.size.width];
    return h;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}
- (NSMutableArray *)dataModels {
    if(_dataModels == nil) {
        _dataModels = [NSMutableArray array];
    }
    return _dataModels;
}

@end
