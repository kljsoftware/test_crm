//
//  WorkUnreadDetailsTableViewController.m
//  sales
//
//  Created by user on 2017/4/14.
//  Copyright © 2017年 rayootech. All rights reserved.
//

#import "WorkUnreadDetailsTableViewController.h"
#import "CircleDetailsTableViewCell.h"
#define kCircleDetailsTableCellId @"CircleDetailsTableViewCell"
@interface WorkUnreadDetailsTableViewController ()

@property (nonatomic,strong) NSMutableArray     *dataModels;
@property (nonatomic,strong) PreferUtil         *preferUtil;

@end
@implementation WorkUnreadDetailsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"消息详情";
    _preferUtil = [PreferUtil new];
    [_preferUtil initIN];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setWork:(Work *)work{
    _work = work;
    NSString *ids = [NSString new];
    NSArray *inters = work.workCommentsIds;
    int count = (int)inters.count;
    for (int i = count-1 ; i > 0; i--) {
        NSNumber *t = inters[i];
        NSString *id = [NSString stringWithFormat:@"%ld",(long)[t integerValue]];
        ids = [ids stringByAppendingString:id];
        ids = [ids stringByAppendingString:@","];
    }
    NSNumber *num = inters[0];
    ids = [ids stringByAppendingString:[NSString stringWithFormat:@"%ld",(long)[num integerValue]]];
    [self getUnreadWorkReply:ids];
}

- (void)getUnreadWorkReply:(NSString *)ids{
    NSString *userId = [NSString stringWithFormat:@"%ld",(long)[Config getOrgUserID]];;
    NSString *token = [Config getToken];
    NSString *dbid = [NSString stringWithFormat:@"%ld",(long)[Config getDbID]];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    
    NSString* urlStr = [NSString stringWithFormat:@"%@%@",BASE_URL,API_UNREAD_WORK_REPLY];
    
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"POST" URLString:urlStr parameters:@{@"workId":[NSString stringWithFormat:@"%ld",(long)_work.id],@"commentids":ids}                                                                                    error:nil];
    [request addValue:userId forHTTPHeaderField:@"userId"];
    [request addValue:token forHTTPHeaderField:@"token"];
    [request addValue:dbid forHTTPHeaderField:@"dbid"];
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id _Nonnull responseObject, NSError *error) {
        if (error) {
            NSLog(@"Error:-->%@", error);
        } else {
            NSString *responseString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            NSLog(@"DATA UNREAD-->%@", responseString);
            if (responseObject) {
                NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
                if ([dictionary[@"result"] intValue] == 1) {
                    NSArray* data = dictionary[@"data"];
                    NSArray* modelArray = [Comment mj_objectArrayWithKeyValuesArray:data];
                    [self.dataModels addObjectsFromArray:modelArray];
                    [self.tableView reloadData];
                    [self mergerUnread];
                }else if([dictionary[@"result"] integerValue] == 0){
                    [self mergerUnread];
                }
                
            }else{
                
            }
        }
    }];
    [dataTask resume];
}
- (void)mergerUnread{
    NSMutableArray *local = [FileUtils inReadDataFromFile:UnreadWorkList];
    NSInteger count = 0;
    for (int i = 0 ; i < local.count; i++) {
        Comment *t = local[i];
        if (t.id == _work.id) {
            count = t.counts;
            [local removeObject:t];
            break;
        }
    }
    NSInteger c = [_preferUtil getInt:UnreadWorkListCount];
    c = c - count;
    if (c <= 0) {
        c = 0;
    }
    [_preferUtil setInt:UnreadWorkListCount data:c];
    [FileUtils inSaveDataToFile:UnreadWorkList data:local];
    NSNotification *notice = [NSNotification notificationWithName:@"updateUnreadWork" object:nil];
    [[NSNotificationCenter defaultCenter]postNotification:notice];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CircleDetailsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCircleDetailsTableCellId];
    if (!cell) {
        cell = [[CircleDetailsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCircleDetailsTableCellId];
    }
    cell.indexPath = indexPath;
    cell.model = self.dataModels[indexPath.row];
    cell.unread = YES;
    cell.type = 3;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // >>>>>>>>>>>>>>>>>>>>> * cell自适应 * >>>>>>>>>>>>>>>>>>>>>>>>
    id model = self.dataModels[indexPath.row];
    return [self.tableView cellHeightForIndexPath:indexPath model:model keyPath:@"model" cellClass:[CircleDetailsTableViewCell class] contentViewWidth:[self cellContentViewWith]];
    
}
- (CGFloat)cellContentViewWith
{
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    
    // 适配ios7横屏
    if ([UIApplication sharedApplication].statusBarOrientation != UIInterfaceOrientationPortrait && [[UIDevice currentDevice].systemVersion floatValue] < 8) {
        width = [UIScreen mainScreen].bounds.size.height;
    }
    return width;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(self.dataModels.count == 0){
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }else{
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    }
    
    return self.dataModels.count;
}
- (NSMutableArray *)dataModels {
    if(_dataModels == nil) {
        _dataModels = [NSMutableArray array];
    }
    return _dataModels;
}
@end
