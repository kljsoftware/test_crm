//
//  OrganizationInviteDealTableViewController.m
//  sales
//
//  Created by user on 2017/3/16.
//  Copyright © 2017年 rayootech. All rights reserved.
//

#import "OrganizationInviteDealTableViewController.h"
#import "FileUtils.h"
#import "PreferUtil.h"
#import "OrganizationInviteTableViewCell.h"
#import "Config.h"
#import "PreferUtil.h"
#import "SalesApi.h"
#import <AFNetworking.h>
#define kOrganizationInviteTableViewCellId @"OrganizationInviteTableViewCell"
@interface OrganizationInviteDealTableViewController () <OrgInviteCellDelegate>

@property (nonatomic,strong) NSMutableArray *dataModels;
@property (nonatomic,strong) PreferUtil     *preferUtil;
@end

@implementation OrganizationInviteDealTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"组织邀请";
    _preferUtil = [PreferUtil new];
    [_preferUtil initOUT];
    [_preferUtil setInt:OrgInviteCount data:0];
    
    [self initData];
}

- (void)initData{
    _dataModels = [FileUtils readDataFromFile:OrgInviteList];
    [self.tableView reloadData];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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
    
    OrganizationInviteTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kOrganizationInviteTableViewCellId];
    if (!cell) {
        cell = [[OrganizationInviteTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kOrganizationInviteTableViewCellId];
    }
    cell.model = self.dataModels[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.index = indexPath;
    cell.delegate = self;
    return cell;
}

- (BOOL) tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return  YES;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [_dataModels removeObjectAtIndex:indexPath.row];
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationFade];
        [FileUtils saveDataToFile:OrgInviteList data:_dataModels];
    }
}
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
}

- (void)agreeDidClick:(OrgInvite *)orgInvite index:(NSIndexPath *)indexPath{
    NSString *userId = [NSString stringWithFormat:@"%lld",[Config getOwnID]];;
    NSString *token = [Config getToken];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    
    NSString* urlStr = [NSString stringWithFormat:@"%@%@",BASE_URL,API_ORGANIZATION_ACCEPT_INVITE];
    
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"POST" URLString:urlStr parameters:@{@"oid":orgInvite.dbid}                                                                                    error:nil];
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
                    orgInvite.recevied = @"1";
                    NSNotification *notice = [NSNotification notificationWithName:@"updateOrganizationList" object:nil];
                    [[NSNotificationCenter defaultCenter]postNotification:notice];
                    [self.dataModels replaceObjectAtIndex:[indexPath row] withObject:orgInvite];
                    [FileUtils saveDataToFile:OrgInviteList data:self.dataModels];
                    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
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
