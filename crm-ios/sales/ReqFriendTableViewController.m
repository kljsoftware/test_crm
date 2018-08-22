//
//  ReqFriendTableViewController.m
//  sales
//
//  Created by user on 2017/3/9.
//  Copyright © 2017年 rayootech. All rights reserved.
//

#import "ReqFriendTableViewController.h"
#import "ReqFriendDbUtil.h"
#import "ReqFriendTableViewCell.h"
#define kReqFriendTableCellId @"ReqFriendTableViewCell"
@interface ReqFriendTableViewController () <ReqFriendCellDelegate>

@property (nonatomic,strong) ReqFriendDbUtil *reqDb;
@property (nonatomic,strong) NSMutableArray* dataModels;

@end

@implementation ReqFriendTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"新朋友";
    self.tableView.rowHeight = 45;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    _reqDb = [[ReqFriendDbUtil alloc] init];
    [self getLocalData];
}

- (void)getLocalData{
    NSMutableArray *temp = [_reqDb selectAll];
    self.dataModels = temp.mutableCopy;
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
    
    ReqFriendTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kReqFriendTableCellId];
    if (!cell) {
        cell = [[ReqFriendTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kReqFriendTableCellId];
    }
    cell.model = self.dataModels[indexPath.row];
    cell.delegate = self;
    cell.index = indexPath;
    return cell;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
}

- (BOOL) tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return  YES;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        Contact *c = self.dataModels[indexPath.row];
        [_reqDb deleteContactById:c.id];
        [_dataModels removeObjectAtIndex:indexPath.row];
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationFade];
    }
}
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
}

- (void)agreeDidClick:(Contact *)contact index:(NSIndexPath *)indexPath{
    [[RCIMClient sharedRCIMClient] removeFromBlacklist:[@"out_" stringByAppendingString:[NSString stringWithFormat:@"%ld",contact.id]] success:^{
        [self acceptFriendReq:contact index:indexPath];
    } error:^(RCErrorCode status) {
        
    }];
}

- (void)acceptFriendReq:(Contact *)contact index:(NSIndexPath *)indexPath{
    NSString *userId = [NSString stringWithFormat:@"%lld",[Config getOwnID]];;
    NSString *token = [Config getToken];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    
    NSString* urlStr = [NSString stringWithFormat:@"%@%@",BASE_URL,API_ACCEPT_FRIEND_REQ];
    
    NSString *fid = [NSString stringWithFormat:@"%ld",contact.id];
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"POST" URLString:urlStr parameters:@{@"fid":fid,@"action":@"1"}                                                                                    error:nil];
    [request addValue:userId forHTTPHeaderField:@"userId"];
    [request addValue:token forHTTPHeaderField:@"token"];
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id _Nonnull responseObject, NSError *error) {
        if (error) {
            NSLog(@"Error:-->%@", error);
            
        } else {
            NSString *responseString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            //            NSLog(@"DATA-->%@", responseString);
            if (responseObject) {
                NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
                if ([dictionary[@"result"] intValue] == 1) {
                    contact.recevied = 1;
                    NSNotification *notice = [NSNotification notificationWithName:@"updateContact" object:nil];
                    [[NSNotificationCenter defaultCenter]postNotification:notice];
                    [_reqDb updateContact:contact];
                    [self.dataModels replaceObjectAtIndex:[indexPath row] withObject:contact];
                    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
                }else{
                    
                }
            }else{
               
            }
        }
    }];
    [dataTask resume];
}
@end
