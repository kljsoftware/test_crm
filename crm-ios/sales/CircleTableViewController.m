//
//  CircleTableViewController.m
//  sales
//
//  Created by user on 2016/11/3.
//  Copyright © 2016年 rayootech. All rights reserved.
//

#import "CircleTableViewController.h"
#import "Circle.h"
#import "CircleTableCell.h"
#import "CircleDetailsTableViewController.h"
#import "CircleDetailsBottomBarViewController.h"
#import "CircleUnreadTableViewController.h"
#define kMainWidth [UIScreen mainScreen].bounds.size.width
#define kCircleTableCellId @"CircleTableCell"

@interface CircleTableViewController ()<CircleCellDelegate>

@property (nonatomic,strong) NSMutableArray *dataModels;
@property (nonatomic,strong) UIView         *headerView;
@property (nonatomic,strong) UILabel        *unreadLabel;
@property (nonatomic,strong) PreferUtil     *preferUtil;
@property (nonatomic,strong) NSMutableArray *unreadDatas;

@end

@implementation CircleTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _preferUtil = [PreferUtil new];
    [_preferUtil initOUT];
    _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainWidth, 50)];
    _unreadLabel = [[UILabel alloc] init];
    _unreadLabel.text = @"1条未读消息";
    _unreadLabel.textAlignment = NSTextAlignmentCenter;
    [_headerView addSubview:_unreadLabel];
    _unreadLabel.sd_layout.centerXEqualToView(_headerView).centerYEqualToView(_headerView).widthIs(200).heightIs(21);
    
    UILongPressGestureRecognizer *gesturRecognizer=[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(unreadClicked:)];
    gesturRecognizer.minimumPressDuration = 0;
    
    [_headerView addGestureRecognizer:gesturRecognizer];
    self.tableView.separatorColor = [UIColor lightGrayColor];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self getCircleList:YES];
        [self getUnreadCircle];
    }];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self getCircleList:NO];
    }];
    [self.tableView.mj_header beginRefreshing];
//    self.navigationController.tabBarItem.badgeValue = @"1";
    
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(getUnreadCircle) name:@"updateUnreadCircle" object:nil];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    [cell setSeparatorInset:UIEdgeInsetsZero];
    [cell setLayoutMargins:UIEdgeInsetsZero];
}

- (void)getCircleList:(BOOL)isRefresh{
    NSString *userId = [NSString stringWithFormat:@"%lld",[Config getOwnID]];
    NSString *token = [Config getToken];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    
    NSString* urlStr = [NSString stringWithFormat:@"%@%@",BASE_URL,API_CIRCLE_LIST];
    NSInteger p = 0;
    p = isRefresh?1:self.dataModels.count / 10 + 1;
    NSString *page = [NSString stringWithFormat:@"%ld",p];
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"POST" URLString:urlStr parameters:@{@"page":page,@"pagenum":@"10"}                                                                                    error:nil];
    [request addValue:userId forHTTPHeaderField:@"userId"];
    [request addValue:token forHTTPHeaderField:@"token"];
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id _Nonnull responseObject, NSError *error) {
        if (error) {
            NSLog(@"Error:-->%@", error);
            if (isRefresh) {
                [self.tableView.mj_header endRefreshing];
            } else{
                [self.tableView.mj_footer endRefreshing];
            }
        } else {
            NSString *responseString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
//            NSLog(@"DATA-->%@", responseString);
            if (responseObject) {
                NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
                if ([dictionary[@"result"] intValue] == 1) {
                    
                    if (isRefresh) {//下拉得到的数据
                        [self.dataModels removeAllObjects];
                    }
                    
                    NSArray* data = dictionary[@"data"];
                    NSArray* modelArray = [Circle mj_objectArrayWithKeyValuesArray:data];
                    [self.dataModels addObjectsFromArray:modelArray];
                    if (isRefresh) {
                        [self.tableView.mj_header endRefreshing];
                        if(modelArray.count < 10){
                            [self.tableView.mj_footer endRefreshingWithNoMoreData];
                        }
                    } else {
                        if (modelArray.count < 10) {
                            [self.tableView.mj_footer endRefreshingWithNoMoreData];
                        } else {
                            [self.tableView.mj_footer endRefreshing];
                        }
                    }
                    [_preferUtil setInt:LastUnreadCircleTime data:[dictionary[@"lasttime"] longValue]];
                    [self.tableView reloadData];
                }else{
                    if (isRefresh) {
                        [self.tableView.mj_header endRefreshing];
                    } else {
                        [self.tableView.mj_footer endRefreshing];
                    }
                }
            }else{
                if (isRefresh) {
                    [self.tableView.mj_header endRefreshing];
                } else {
                    [self.tableView.mj_footer endRefreshing];
                }
            }
        }
    }];
    [dataTask resume];
}

- (void)getUnreadCircle{
    NSString *userId = [NSString stringWithFormat:@"%lld",[Config getOwnID]];;
    NSString *token = [Config getToken];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    
    NSString* urlStr = [NSString stringWithFormat:@"%@%@",BASE_URL,API_CIRCLE_UNREAD];
    NSInteger time = [_preferUtil getInt:LastUnreadCircleTime];
    NSDate *date = [NSDate new];
    NSLog(@"---time %@",[NSString stringWithFormat:@"%ld",(long)[date timeIntervalSince1970]]);
    if (time == 0) {
        time = (long)[date timeIntervalSince1970];
        [_preferUtil setInt:LastUnreadCircleTime data:time];
    }else{}
    NSString *lasttime = [NSString stringWithFormat:@"%ld",time];
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"POST" URLString:urlStr parameters:@{@"lasttime":lasttime}                                                                                    error:nil];
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
                    [self.unreadDatas removeAllObjects];
                    [self.unreadDatas addObjectsFromArray:modelArray];
//                    [self saveDateToFile];
                    [self mergeData];
                }else{
                    NSInteger count = [_preferUtil getInt:UnreadCircleListCount];
                    [self.unreadDatas addObjectsFromArray:[self readDataFromFile]];
                    if (count > 0) {
                        self.tableView.tableHeaderView = _headerView;
                        NSString *c = [NSString stringWithFormat:@"%ld",count];
                        _unreadLabel.text = [c stringByAppendingString:@"条消息未读"];
                    }else{
                        self.tableView.tableHeaderView = nil;
                    }
                    
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
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // >>>>>>>>>>>>>>>>>>>>> * cell自适应 * >>>>>>>>>>>>>>>>>>>>>>>>
    id model = self.dataModels[indexPath.row];
    return [self.tableView cellHeightForIndexPath:indexPath model:model keyPath:@"model" cellClass:[CircleTableCell class] contentViewWidth:[self cellContentViewWith]];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CircleTableCell *cell = [tableView dequeueReusableCellWithIdentifier:kCircleTableCellId];
    if (!cell) {
        cell = [[CircleTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCircleTableCellId];
    }
    cell.indexPath = indexPath;
    __weak typeof(self) weakSelf = self;
    if (!cell.moreButtonClickedBlock) {
        [cell setMoreButtonClickedBlock:^(NSIndexPath *indexPath) {
            Circle *model = weakSelf.dataModels[indexPath.row];
            model.isOpening = !model.isOpening;
            [weakSelf.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        }];
    }
    
    cell.model = self.dataModels[indexPath.row];
    cell.delegate = self;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    UIViewController *vc = [CircleDetailsTableViewController new];
    CircleDetailsBottomBarViewController *vc = [[CircleDetailsBottomBarViewController alloc] initWithCircleID:self.dataModels[indexPath.row]];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
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
- (NSMutableArray *)dataModels {
    if(_dataModels == nil) {
        _dataModels = [NSMutableArray array];
    }
    return _dataModels;
}

- (NSMutableArray *)unreadDatas{
    if (_unreadDatas == nil) {
        _unreadDatas = [NSMutableArray array];
    }
    return _unreadDatas;
}
#define PATH_OF_DOCUMENT    [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]

- (void)mergeData{
    NSMutableArray *local = [self readDataFromFile];
    NSInteger count = 0;
    for (int i = 0; i < self.unreadDatas.count; i++) {
        Boolean flag = true;
        Comment *comment = self.unreadDatas[i];
        for (int j = 0; j < local.count && flag; j++) {
            Comment *c = local[j];
            if (comment.id == c.id && comment.integerList != nil && comment.integerList.count > 0) {
                [comment.integerList addObjectsFromArray:c.integerList];
                flag = false;
                NSSet *set = [[NSSet alloc] initWithArray:c.integerList];
                [c.integerList removeAllObjects];
                [c.integerList addObjectsFromArray:[set allObjects]];
                count = count + c.counts;
                [self.unreadDatas replaceObjectAtIndex:j withObject:c];
            }
        }
        if (flag && comment.counts > 0) {
            [local addObject:comment];
            count = count + comment.counts;
        }
    }
    [self.unreadDatas removeAllObjects];
    [self.unreadDatas addObjectsFromArray:local];
    [_preferUtil setInt:UnreadCircleListCount data:count];
    [self saveDataToFile];
    if (count > 0) {
        self.tableView.tableHeaderView = _headerView;
        NSString *c = [NSString stringWithFormat:@"%ld",count];
        _unreadLabel.text = [c stringByAppendingString:@"条消息未读"];
    }else{
        self.tableView.tableHeaderView = nil;
    }
}
- (void)saveDataToFile{
    NSString *filename = [UnreadCircleList stringByAppendingString:[NSString stringWithFormat:@"%lld",[Config getOwnID]]];
    filename = [PATH_OF_DOCUMENT stringByAppendingPathComponent:filename];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self.unreadDatas];
    [data writeToFile:filename atomically:YES];
//    NSData *tempData = [NSData dataWithContentsOfFile:filename options:0 error:NULL];
//    NSMutableArray *temp = [NSKeyedUnarchiver unarchiveObjectWithData:tempData];
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
- (void)unreadClicked:(UITapGestureRecognizer *)rec{
    if (rec.state == UIGestureRecognizerStateBegan) {
        _headerView.backgroundColor = [UIColor lightGrayColor];
    }else if(rec.state == UIGestureRecognizerStateEnded){
        _headerView.backgroundColor = [UIColor whiteColor];
        CircleUnreadTableViewController *unreadVC = [[CircleUnreadTableViewController alloc] init];
        unreadVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:unreadVC animated:YES];
    }
}

- (void)deleteClick:(NSIndexPath *)indexPath{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"删除" message:@"确定要删除该圈子吗？" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *sure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self deleteCirle:indexPath];
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alert addAction:sure];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:^{}];
}

- (void)deleteCirle:(NSIndexPath *)indexPath{
    Circle *circle = self.dataModels[indexPath.row];
    NSString *userId = [NSString stringWithFormat:@"%lld",[Config getOwnID]];;
    NSString *token = [Config getToken];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    
    NSString* urlStr = [NSString stringWithFormat:@"%@%@",BASE_URL,API_CIRCLE_DELETE];
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"POST" URLString:urlStr parameters:@{@"postid":[NSString stringWithFormat:@"%ld",circle.id],@"commentid":@"-1"}                                                                                    error:nil];
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
                    [self.dataModels removeObject:circle];
                    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                }else{
                    
                }
                
            }else{
                
            }
        }
    }];
    [dataTask resume];
}
@end
