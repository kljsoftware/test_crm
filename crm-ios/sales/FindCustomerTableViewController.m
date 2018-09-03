//
//  FindCustomerTableViewController.m
//  sales
//
//  Created by user on 2017/3/3.
//  Copyright © 2017年 rayootech. All rights reserved.
//

#import "FindCustomerTableViewController.h"
#import "Customer.h"
#import "CreaterCustomerDetailsViewController.h"
#import "FindCustomerTableViewCell.h"
#define kMainWidth [UIScreen mainScreen].bounds.size.width
#define kFindCustomerTableCellId @"FindCustomerTableViewCell"
@interface FindCustomerTableViewController () <UITextFieldDelegate>

@property (nonatomic,strong) UIView             *headerView;
@property (nonatomic,strong) UITextField        *searchField;
@property (nonatomic,strong) UIButton           *cancelButton;
@property (nonatomic,strong) NSMutableArray     *dataModels;

@end

@implementation FindCustomerTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithHex:0xf2f2f2];
    _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainWidth, 60)];
    _searchField = [[UITextField alloc] initWithFrame:CGRectMake(20, 10, kMainWidth - 40, 40)];
    _searchField.backgroundColor = UIColor.whiteColor;
    _searchField.borderStyle = UITextBorderStyleNone;
    _searchField.placeholder = @"搜索联系人";
    _searchField.delegate = self;
    _searchField.returnKeyType = UIReturnKeySearch;
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    UIImageView *searchIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"common_search"]];
    searchIcon.frame = CGRectMake((40-17)/2, (40-17)/2, 17, 17);
    [leftView addSubview:searchIcon];
    _searchField.leftViewMode = UITextFieldViewModeAlways;
    _searchField.leftView = leftView;
    [_headerView addSubview:_searchField];
    self.tableView.tableHeaderView = _headerView;
    self.tableView.rowHeight = 60;
    self.tableView.sectionIndexColor = [UIColor lightGrayColor];
    self.tableView.sectionIndexBackgroundColor = [UIColor clearColor];
    self.tableView.tableFooterView = [[UIView alloc] init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
    if(self.dataModels.count == 0) {
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    } else {
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    }
    return self.dataModels.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    FindCustomerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kFindCustomerTableCellId];
    if (!cell) {
        cell = [[FindCustomerTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kFindCustomerTableCellId];
    }
    cell.model = self.dataModels[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Customer" bundle:nil];
    CreaterCustomerDetailsViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"CreaterCustomerDetails"];
    vc.hidesBottomBarWhenPushed = YES;
    vc.customer = self.dataModels[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSString *toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if ([string isEqualToString: @"\n"]) {
        [_searchField resignFirstResponder];
        [self searchCustomer:toBeString];
        return NO;
    }
    return YES;
}

- (void)cancelSearch{
    [self.view endEditing:YES];
    _searchField.text = @"";
    [self.dataModels removeAllObjects];
    [self.tableView reloadData];
}

- (void)searchCustomer:(NSString *)content{
    NSLog(@"string ---- %@",content);
    NSString *userId = [NSString stringWithFormat:@"%ld",[Config getOrgUserID]];;
    NSString *token = [Config getToken];
    NSString *dbid = [NSString stringWithFormat:@"%ld",[Config getDbID]];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    
    NSString* urlStr = [NSString stringWithFormat:@"%@%@",BASE_URL,API_CUSTOMER_SEARCH];
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"POST" URLString:urlStr parameters:@{@"id":content}                                                                                    error:nil];
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
                    NSArray* modelArray = [Customer mj_objectArrayWithKeyValuesArray:data];
                    NSMutableArray *temp;
                    temp = modelArray.mutableCopy;
                    [self.dataModels removeAllObjects];
                    [self.dataModels addObjectsFromArray:temp];
                    [self.tableView reloadData];
                }else{
                    
                }
            }else{
                
            }
        }
    }];
    [dataTask resume];
}

- (NSMutableArray *)dataModels {
    if(_dataModels == nil) {
        _dataModels = [NSMutableArray array];
    }
    return _dataModels;
}
@end
