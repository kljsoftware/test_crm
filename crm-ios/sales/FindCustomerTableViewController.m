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
    _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainWidth, 50)];
    _searchField = [[UITextField alloc] initWithFrame:CGRectMake(5, 5, kMainWidth - 60, 30)];
    _searchField.borderStyle = UITextBorderStyleRoundedRect;
    _cancelButton = [[UIButton alloc] init];
    [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [_cancelButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_cancelButton addTarget:self action:@selector(cancelSearch) forControlEvents:UIControlEventTouchUpInside];
    _cancelButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [_headerView addSubview:_cancelButton];
    [_headerView addSubview:_searchField];
    
    _searchField.sd_layout
    .centerYEqualToView(_headerView);
    _cancelButton.sd_layout
    .centerYEqualToView(_headerView).leftSpaceToView(_searchField,5).heightIs(40).widthIs(50);
    
    _searchField.delegate = self;
    _searchField.returnKeyType = UIReturnKeySearch;
    self.tableView.tableHeaderView = _headerView;
    self.tableView.rowHeight = [FindCustomerTableViewCell fixedHeight];
    self.tableView.sectionIndexColor = [UIColor lightGrayColor];
    self.tableView.sectionIndexBackgroundColor = [UIColor clearColor];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(self.dataModels.count == 0){
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }else{
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
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Customer" bundle:nil];
    CreaterCustomerDetailsViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"CreaterCustomerDetails"];
    vc.hidesBottomBarWhenPushed = YES;
    vc.view.backgroundColor = [UIColor whiteColor];
    vc.customer = self.dataModels[indexPath.row];
    //    vc.contact = self.sectionArray[indexPath.section][indexPath.row];
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
