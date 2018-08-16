//
//  CircleUnreadDetailsTableViewController.m
//  sales
//
//  Created by user on 2017/3/14.
//  Copyright © 2017年 rayootech. All rights reserved.
//

#import "CircleUnreadDetailsTableViewController.h"
#import "CircleDetailsTableViewCell.h"
#import "SalesApi.h"
#import "Config.h"
#import "PreferUtil.h"
#import <AFNetworking.h>
#import <MJExtension.h>
#import <SDAutoLayout.h>
#define kCircleDetailsTableCellId @"CircleDetailsTableViewCell"
@interface CircleUnreadDetailsTableViewController ()

@property (nonatomic,strong) NSMutableArray *dataModels;
@property (nonatomic,strong) PreferUtil     *preferUtil;

@end

@implementation CircleUnreadDetailsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"消息详情";
    _preferUtil = [PreferUtil new];
    [_preferUtil initOUT];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (void)setComment:(Comment *)comment{
    _comment = comment;
    NSString *ids = [NSString new];
    NSArray *inters = comment.integerList;
    int count = (int)inters.count;
    for (int i = count-1 ; i > 0; i--) {
        NSNumber *t = inters[i];
        NSString *id = [NSString stringWithFormat:@"%ld",[t integerValue]];
        ids = [ids stringByAppendingString:id];
        ids = [ids stringByAppendingString:@","];
    }
    NSNumber *num = inters[0];
    ids = [ids stringByAppendingString:[NSString stringWithFormat:@"%ld",[num integerValue]]];
    [self getUnreadCircleReply:ids];
}

- (void)getUnreadCircleReply:(NSString *)ids{
    NSString *userId = [NSString stringWithFormat:@"%lld",[Config getOwnID]];;
    NSString *token = [Config getToken];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    
    NSString* urlStr = [NSString stringWithFormat:@"%@%@",BASE_URL,API_UNREAD_CIRCLE_REPLY];
    
    NSNumber *num = [NSNumber numberWithInteger:_comment.id];
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"POST" URLString:urlStr parameters:@{@"opostId":num,@"commentids":ids}                                                                                    error:nil];
    [request addValue:userId forHTTPHeaderField:@"userId"];
    [request addValue:token forHTTPHeaderField:@"token"];
    
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
                }else if([dictionary[@"result"] intValue] == 0){
                    [self mergerUnread];
                }
                
            }else{
                
            }
        }
    }];
    [dataTask resume];
}
- (void)mergerUnread{
    NSMutableArray *local = [self readDataFromFile];
    NSInteger count = 0;
    for (int i = 0 ; i < local.count; i++) {
        Comment *t = local[i];
        if (t.id == _comment.id) {
            count = t.counts;
            [local removeObject:t];
            break;
        }
    }
    NSInteger c = [_preferUtil getInt:UnreadCircleListCount];
    c = c - count;
    if (c <= 0) {
        c = 0;
    }
    [_preferUtil setInt:UnreadCircleListCount data:c];
    [self saveDataToFile:local];
    NSNotification *notice = [NSNotification notificationWithName:@"updateUnreadCircle" object:nil];
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

#define PATH_OF_DOCUMENT    [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]

- (void)saveDataToFile:(NSMutableArray *)local{
    NSString *filename = [UnreadCircleList stringByAppendingString:[NSString stringWithFormat:@"%lld",[Config getOwnID]]];
    filename = [PATH_OF_DOCUMENT stringByAppendingPathComponent:filename];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:local];
    [data writeToFile:filename atomically:YES];
}
- (NSMutableArray *)readDataFromFile{
    NSString *filename = [UnreadCircleList stringByAppendingString:[NSString stringWithFormat:@"%lld",[Config getOwnID]]];
    filename = [PATH_OF_DOCUMENT stringByAppendingPathComponent:filename];
    NSData *tempData = [NSData dataWithContentsOfFile:filename options:0 error:NULL];
    NSMutableArray *temp = [NSKeyedUnarchiver unarchiveObjectWithData:tempData];
    if (temp == nil) {
        temp = [NSMutableArray new];
    }
    return temp;
}
@end
