//
//  OrganizationTableViewController.m
//  sales
//
//  Created by user on 2016/12/30.
//  Copyright © 2016年 rayootech. All rights reserved.
//

#import "OrganizationTableViewController.h"
#import "SalesApi.h"
#import "Config.h"
#import "UIColor+Util.h"
#import "OrganizationTableViewCell.h"
#import "OrganizationViewController.h"
#import "OrganizationInviteDealTableViewController.h"
#import "OrganizationCreateViewController.h"
#import "PreferUtil.h"
#import "OrgInvite.h"
#import <AFNetworking.h>
#import <MJExtension.h>
#import <SDAutoLayout.h>
#import "OrgInvite.h"
#import "FileUtils.h"
#define kOrganizationTableViewCellId @"OrganizationTableViewCell"
@interface OrganizationTableViewController ()
@property (nonatomic,strong) NSMutableArray *dataModels;
@property (nonatomic,strong) NSMutableArray *inviteModels;
@property (nonatomic,strong) UIView *headerView;
@property (nonatomic,strong) UIView *headerItem1;
@property (nonatomic,strong) UIView *headerItem2;
@property (nonatomic,strong) PreferUtil *preferUtil;
@property (nonatomic,strong) UILabel *countLabel;
@end

@implementation OrganizationTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的组织";
    _preferUtil = [PreferUtil new];
    [_preferUtil initOUT];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"创建" style:UIBarButtonItemStylePlain target:self action:@selector(createButtonClicked)];
    self.tableView.rowHeight = [OrganizationTableViewCell fixedHeight];
    _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 640, 74)];
    _headerItem1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 640, 44)];
    [_headerView addSubview:_headerItem1];
    
    _headerItem2 = [[UIView alloc] initWithFrame:CGRectMake(0, 44, 640, 30)];
    _headerItem2.backgroundColor = [UIColor colorWithHex:0xf3f3f3];;
    [_headerView addSubview:_headerItem2];
    
    UILabel *label = [[UILabel alloc] init];
    label.text = @"新邀请";
    label.font = [UIFont systemFontOfSize:14];
    
    _countLabel = [[UILabel alloc] initWithFrame:CGRectMake(90, 7, 20, 20)];
    _countLabel.backgroundColor = [UIColor redColor];
    _countLabel.layer.cornerRadius = _countLabel.bounds.size.width/2;
    _countLabel.layer.masksToBounds = YES;
    _countLabel.textColor = [UIColor whiteColor];
    _countLabel.font = [UIFont systemFontOfSize:12];
    _countLabel.textAlignment = NSTextAlignmentCenter;
    
    [_headerItem1 addSubview:label];
   
    label.sd_layout
    .leftSpaceToView(self.headerItem1, 10)
    .widthIs(60)
    .heightEqualToWidth()
    .centerYEqualToView(self.headerItem1);
    [_headerItem1 addSubview:_countLabel];
    _countLabel.sd_layout
    .leftSpaceToView(label,20).widthIs(20).heightEqualToWidth().centerYEqualToView(self.headerItem1);
    if ([_preferUtil getInt:OrgInviteCount] > 0) {
        _countLabel.hidden = NO;
        _countLabel.text = [NSString stringWithFormat:@"%ld",(long)[_preferUtil getInt:OrgInviteCount]];
        
    }else{
        _countLabel.hidden = YES;
    }
    
    UILongPressGestureRecognizer *gesturRecognizer=[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(newOrganization:)];
    gesturRecognizer.minimumPressDuration = 0;
    [_headerView addGestureRecognizer:gesturRecognizer];
    self.tableView.tableHeaderView = _headerView;
    [self initData];
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(updateOrganizationList) name:@"updateOrganizationList" object:nil];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self getNewInvite];
}

- (void)getNewInvite{
    NSString *userId = [NSString stringWithFormat:@"%lld",[Config getOwnID]];;
    NSString *token = [Config getToken];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    
    NSString* urlStr = [NSString stringWithFormat:@"%@%@",BASE_URL,API_NEW_INVITE];
    
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"POST" URLString:urlStr parameters:@{@"userId":userId,@"dbid":@""}                                                                                    error:nil];
    [request addValue:userId forHTTPHeaderField:@"userId"];
    [request addValue:token forHTTPHeaderField:@"token"];
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id _Nonnull responseObject, NSError *error) {
        if (error) {
            NSLog(@"Error:-->%@", error);
            
        } else {
            NSString *responseString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            NSLog(@"DATA-->%@", responseString);
            if (responseObject) {
                NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
                if ([dictionary[@"result"] intValue] == 1) {
                    
                    NSArray* data = dictionary[@"data"];
                    NSArray* modelArray = [OrgInvite mj_objectArrayWithKeyValuesArray:data];
                    [self.inviteModels addObjectsFromArray:modelArray];
                    OrgInvite *orgInvite;
                    for (int i = 0; i < self.inviteModels.count; i++) {
                        
                        orgInvite = self.inviteModels[i];
                    
                        orgInvite.recevied = @"0";
                        [self dealOrgInvite:orgInvite];
                    }
                    if ([_preferUtil getInt:OrgInviteCount] > 0) {
                        _countLabel.hidden = NO;
                        _countLabel.text = [NSString stringWithFormat:@"%ld",(long)[_preferUtil getInt:OrgInviteCount]];
                        
                    }
                }else{
                    
                }
            }else{
                
            }
        }
    }];
    [dataTask resume];
}


- (void)updateOrganizationList{
    [self.dataModels removeAllObjects];
    [self initData];
}

- (void)initData{
    NSString *userId = [NSString stringWithFormat:@"%lld",[Config getOwnID]];;
    NSString *token = [Config getToken];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    
    NSString* urlStr = [NSString stringWithFormat:@"%@%@",BASE_URL,API_ORGANIZATION_LIST];

    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"POST" URLString:urlStr parameters:@{}                                                                                    error:nil];
    [request addValue:userId forHTTPHeaderField:@"userId"];
    [request addValue:token forHTTPHeaderField:@"token"];
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id _Nonnull responseObject, NSError *error) {
        if (error) {
            NSLog(@"Error:-->%@", error);
           
        } else {
            NSString *responseString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            NSLog(@"DATA-->%@", responseString);
            if (responseObject) {
                NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
                if ([dictionary[@"result"] intValue] == 1) {
                   
                    NSArray* data = dictionary[@"data"];
                    NSArray* modelArray = [Organizations mj_objectArrayWithKeyValuesArray:data];
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
    
    OrganizationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kOrganizationTableViewCellId];
    if (!cell) {
        cell = [[OrganizationTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kOrganizationTableViewCellId];
    }
    cell.model = self.dataModels[indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"OMeViewController" bundle:nil];
    OrganizationViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"OrganizationDetails"];
    vc.hidesBottomBarWhenPushed = YES;
    vc.view.backgroundColor = [UIColor whiteColor];
    vc.organizations = self.dataModels[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}

- (NSMutableArray *)dataModels {
    if(_dataModels == nil) {
        _dataModels = [NSMutableArray array];
    }
    return _dataModels;
}

- (NSMutableArray *)inviteModels {
    if(_inviteModels == nil){
        _inviteModels = [NSMutableArray array];
    }
    return _inviteModels;
}
- (void)newOrganization:(UITapGestureRecognizer *)rec{
    if (rec.state == UIGestureRecognizerStateBegan) {
        _headerView.backgroundColor = [UIColor lightGrayColor];
    }else if(rec.state == UIGestureRecognizerStateEnded){
        _headerView.backgroundColor = [UIColor whiteColor];
        OrganizationInviteDealTableViewController *vc = [[OrganizationInviteDealTableViewController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        vc.view.backgroundColor = [UIColor whiteColor];
        [self.navigationController pushViewController:vc animated:YES];
        _countLabel.hidden = YES;
    }
}

- (void)createButtonClicked{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"OMeViewController" bundle:nil];
    OrganizationCreateViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"OrganizationCreate"];
    
    vc.hidesBottomBarWhenPushed = YES;
    vc.view.backgroundColor = [UIColor whiteColor];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)dealOrgInvite:(OrgInvite *)invite{
    NSMutableArray *local = [FileUtils readDataFromFile:OrgInviteList];
    if (local == nil) {
        local = [NSMutableArray new];
    }
    for(int i = 0; i < local.count;i++){
        OrgInvite *temp = local[i];
        if ([temp.dbid isEqualToString:invite.dbid]) {
            return;
        }
    }
    if (_preferUtil == nil) {
        _preferUtil = [PreferUtil new];
    }
    [_preferUtil initOUT];
    
    NSInteger count = [_preferUtil getInt:OrgInviteCount];
    count++;
    [_preferUtil setInt:OrgInviteCount data:count];
    [local addObject:invite];
    [FileUtils saveDataToFile:OrgInviteList data:local];
}
@end
