//
//  CustomerDistTableViewController.m
//  sales
//
//  Created by user on 2017/3/23.
//  Copyright © 2017年 rayootech. All rights reserved.
//

#import "CustomerDistTableViewController.h"
#import "OrgUserInfoDbUtil.h"
#import "SelectColleauesTableViewCell.h"

@interface CustomerDistTableViewController ()
@property (nonatomic,strong) OrgUserInfoDbUtil  *dbUtil;
@property (nonatomic,strong) NSMutableArray     *dataModels;
@property (nonatomic,strong) NSMutableArray     *sectionArray;
@property (nonatomic,strong) NSMutableArray     *sectionTitlesArray;
@property (nonatomic,strong) NSMutableArray     *selectedArray;
@property (nonatomic,strong) MBProgressHUD      *hud;
@end

@implementation CustomerDistTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"客户分配";
    _dbUtil = [[OrgUserInfoDbUtil alloc] init];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(selectFinishBtn)];
    
    self.tableView.rowHeight = [SelectColleauesTableViewCell fixedHeight];
    self.tableView.sectionIndexColor = [UIColor lightGrayColor];
    self.tableView.sectionIndexBackgroundColor = [UIColor clearColor];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    [self getLocalData];
}
- (NSMutableArray *)selectedArray {
    if(_selectedArray == nil) {
        _selectedArray = [NSMutableArray array];
    }
    return _selectedArray;
}
- (void)getLocalData{
    NSMutableArray *temp = [_dbUtil selectAll];
    self.dataModels = temp.mutableCopy;
    [self setUpTableSection];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (void) setUpTableSection {
    UILocalizedIndexedCollation *collation = [UILocalizedIndexedCollation currentCollation];
    
    //create a temp sectionArray
    NSUInteger numberOfSections = [[collation sectionTitles] count];
    NSMutableArray *newSectionArray =  [[NSMutableArray alloc]init];
    for (NSUInteger index = 0; index<numberOfSections; index++) {
        [newSectionArray addObject:[[NSMutableArray alloc]init]];
    }
    
    // insert Persons info into newSectionArray
    for (OrgUserInfo *model in self.dataModels) {
        NSUInteger sectionIndex = [collation sectionForObject:model collationStringSelector:@selector(name)];
        [newSectionArray[sectionIndex] addObject:model];
    }
    
    //sort the person of each section
    for (NSUInteger index=0; index<numberOfSections; index++) {
        NSMutableArray *personsForSection = newSectionArray[index];
        NSArray *sortedPersonsForSection = [collation sortedArrayFromArray:personsForSection collationStringSelector:@selector(name)];
        newSectionArray[index] = sortedPersonsForSection;
    }
    
    NSMutableArray *temp = [NSMutableArray new];
    self.sectionTitlesArray = [NSMutableArray new];
    
    [newSectionArray enumerateObjectsUsingBlock:^(NSArray *arr, NSUInteger idx, BOOL *stop) {
        if (arr.count == 0) {
            [temp addObject:arr];
        } else {
            [self.sectionTitlesArray addObject:[collation sectionTitles][idx]];
        }
    }];
    
    [newSectionArray removeObjectsInArray:temp];
    
    self.sectionArray = newSectionArray;
    [self.tableView reloadData];
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.sectionTitlesArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if([self.sectionArray[section] count] == 0){
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }else{
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    }
    
    return [self.sectionArray[section] count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    static NSString *ID = @"Contacts";
    SelectColleauesTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[SelectColleauesTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    NSUInteger section = indexPath.section;
    NSUInteger row = indexPath.row;
    OrgUserInfo *model = self.sectionArray[section][row];
    cell.model = model;
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return [self.sectionTitlesArray objectAtIndex:section];
}


- (NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    return self.sectionTitlesArray;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    OrgUserInfo *info = self.sectionArray[indexPath.section][indexPath.row];
    
    if (info.status == 9) {
        info.status = 0;
        [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryNone;
        [self.selectedArray removeObject:info];
    }else{
        info.status = 9;
        [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryCheckmark;
        [self.selectedArray addObject:info];
    }
    
}

- (void)setCustomer:(Customer *)customer{
    _customer = customer;
}

- (void)selectFinishBtn{
    _hud = [Utils createHUD];
    if (self.selectedArray.count <= 0) {
        _hud.label.text = @"至少选择一个对象";
        [_hud hideAnimated:YES afterDelay:1];
        return;
    }
    NSString *ids = @"";
    for (int i = 0; i < self.selectedArray.count-1; i++) {
        OrgUserInfo *info = self.selectedArray[i];
        ids = [ids stringByAppendingString:[NSString stringWithFormat:@"%ld",info.id]];
        ids = [ids stringByAppendingString:@","];
    }
    OrgUserInfo *infos = self.selectedArray[self.selectedArray.count - 1];
    ids = [ids stringByAppendingString:[NSString stringWithFormat:@"%ld",infos.id]];
    NSString *userId = [NSString stringWithFormat:@"%ld",[Config getOrgUserID]];;
    NSString *token = [Config getToken];
    NSString *dbid = [NSString stringWithFormat:@"%ld",[Config getDbID]];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    
    NSString* urlStr = [NSString stringWithFormat:@"%@%@",BASE_URL,API_CUSTOMER_DIST];
    
    
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"POST" URLString:urlStr parameters:@{@"tel":_customer.mobile,@"duid":ids}                                                                                    error:nil];
    [request addValue:userId forHTTPHeaderField:@"userId"];
    [request addValue:token forHTTPHeaderField:@"token"];
    [request addValue:dbid forHTTPHeaderField:@"dbid"];
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id _Nonnull responseObject, NSError *error) {
        if (error) {
            _hud.label.text = @"请检测网络";
            [_hud hideAnimated:YES afterDelay:1];
        } else {
            NSString *responseString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            NSLog(@"DATA-->%@", responseString);
            
            if (responseObject) {
                NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
                if ([dictionary[@"result"] intValue] == 1) {
                    _hud.label.text = @"分配成功";
                    [_hud hideAnimated:YES afterDelay:1];
                    if (self.navigationController.viewControllers.count <= 1) {
                        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
                    } else {
                        [self.navigationController popViewControllerAnimated:YES];
                    }
                }else{
                    _hud.label.text = @"请先锁定";
                    [_hud hideAnimated:YES afterDelay:1];
                }
            }else{
                _hud.label.text = @"分配失败";
                [_hud hideAnimated:YES afterDelay:1];
            }
            
        }
    }];
    [dataTask resume];
}
@end
