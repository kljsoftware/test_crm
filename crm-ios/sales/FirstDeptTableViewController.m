//
//  FirstDeptTableViewController.m
//  sales
//
//  Created by user on 2017/4/17.
//  Copyright © 2017年 rayootech. All rights reserved.
//

#import "FirstDeptTableViewController.h"
#import "CreateFirstViewController.h"
#import "Dept.h"
#import "SecondDeptTableViewController.h"
#import "DeptTableViewCell.h"

#define kDeptTableCellId @"DeptTableViewCell"
@interface FirstDeptTableViewController ()

@property (nonatomic,strong) NSMutableArray             *dataModels;

@end

@implementation FirstDeptTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"部门";
    self.tableView.rowHeight = 60;
    self.tableView.sectionIndexColor = [UIColor lightGrayColor];
    self.tableView.sectionIndexBackgroundColor = [UIColor clearColor];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(updateDept) name:@"updateDept" object:nil];
    [self getDept];
    OrgUserInfo *info = [Config getOrgUser];
    if(info.id == 1){
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd                                            target:self action:@selector(addFirstDept)];
        [center addObserver:self selector:@selector(getDept) name:@"refreshFirstDept" object:nil];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)updateDept{
    [self.tableView reloadData];
}
- (void)getDept{
    NSString *userId = [NSString stringWithFormat:@"%ld",[Config getOrgUserID]];;
    NSString *token = [Config getToken];
    NSString *dbid = [NSString stringWithFormat:@"%ld",[Config getDbID]];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    
    NSString* urlStr = [NSString stringWithFormat:@"%@%@",BASE_URL,API_DEPT_DEPTINFO];
    
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"POST" URLString:urlStr parameters:@{@"parentid":@"-1"}                                                                                    error:nil];
    [request addValue:userId forHTTPHeaderField:@"userId"];
    [request addValue:token forHTTPHeaderField:@"token"];
    [request addValue:dbid forHTTPHeaderField:@"dbid"];
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id _Nonnull responseObject, NSError *error) {
        if (error) {
        } else {
            NSString *responseString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            NSLog(@"DATA-->%@", responseString);
            if (responseObject) {
                NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
                if ([dictionary[@"result"] intValue] == 1) {
                    NSArray* data = dictionary[@"data"];
                    NSArray* modelArray = [Dept mj_objectArrayWithKeyValuesArray:data];
                    [self.dataModels removeAllObjects];
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
    if(self.dataModels.count == 0){
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }else{
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    }
    
    return self.dataModels.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    DeptTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kDeptTableCellId];
    if (!cell) {
        cell = [[DeptTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kDeptTableCellId];
    }
    cell.model = self.dataModels[indexPath.row];
    cell.type = 1;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SecondDeptTableViewController *vc = [[SecondDeptTableViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.view.backgroundColor = [UIColor whiteColor];
    vc.dept = self.dataModels[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)addFirstDept {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"IMe" bundle:nil];
    CreateFirstViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"CreateFirst"];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (NSMutableArray *)dataModels {
    if(_dataModels == nil) {
        _dataModels = [NSMutableArray array];
    }
    return _dataModels;
}

@end
