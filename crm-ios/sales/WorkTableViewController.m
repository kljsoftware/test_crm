//
//  WorkTableViewController.m
//  sales
//
//  Created by user on 2017/1/3.
//  Copyright © 2017年 rayootech. All rights reserved.
//

#import "WorkTableViewController.h"
#import "OrgUserInfo.h"
#import "Work.h"
#import "WorkTableViewCell.h"
#import "WorkCommentDbUtil.h"
#import "WorkDetailsBottomBarViewController.h"
#import "WorkStaffTableViewController.h"
#import "WorkDbUtil.h"
#import "WorkStaffDbUtil.h"
#import "WorkUnreadTableViewController.h"
#import "WorkChooseView.h"
#define kWorkTableCellId @"WorkTableViewCell"

#define kMainWidth [UIScreen mainScreen].bounds.size.width
@interface WorkTableViewController () <WorkCellDelegate,UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) NSMutableArray         *dataModels;
@property (nonatomic,strong) NSMutableArray         *unreadDatas;
@property (nonatomic,strong) WorkDbUtil             *workDb;
@property (nonatomic,strong) WorkCommentDbUtil      *commentDb;
@property (nonatomic,strong) WorkStaffDbUtil        *staffDb;
@property (nonatomic,strong) NSMutableArray         *newModels;
@property (nonatomic,strong) PreferUtil             *preferUtil;
@property (nonatomic,strong) UIView                 *headerView;
@property (nonatomic,strong) UILabel                *unreadLabel;
@property (nonatomic,strong) UITableView            *tableView;
@end

@implementation WorkTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _workDb = [[WorkDbUtil alloc] init];
    _commentDb = [[WorkCommentDbUtil alloc] init];
    _staffDb = [[WorkStaffDbUtil alloc] init];
    _preferUtil = [PreferUtil new];
    [_preferUtil initIN];
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.height) style:UITableViewStylePlain];
    [self.view addSubview:_tableView];
    _tableView.delegate = self;
    _tableView.dataSource = self;
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
        [self getWorkList:YES];
        [self getUnreadWork];
    }];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        [self getLocalData:0 pageNum:1 isRefresh:NO];
    }];
    self.tableView.mj_header.automaticallyChangeAlpha = YES;
    [self.tableView.mj_header beginRefreshing];
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(getUnreadWork) name:@"updateUnreadWork" object:nil];
    
    UIButton *chooseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [chooseBtn setImage:[UIImage imageNamed:@"work_choose"] forState:UIControlStateNormal];
    [chooseBtn addTarget:self action:@selector(chooseClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:chooseBtn];
    [chooseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-20);
        make.bottom.mas_equalTo(-20-KMAINTAB_HEIGHT);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)getWorkList:(BOOL)isRefresh{
    NSString *userId = [NSString stringWithFormat:@"%ld",(long)[Config getOrgUserID]];;
    NSString *token = [Config getToken];
    NSString *dbid = [NSString stringWithFormat:@"%ld",(long)[Config getDbID]];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    
    NSString* urlStr = [NSString stringWithFormat:@"%@%@",BASE_URL,API_WORK_LIST];
    NSString *updatetime = [NSString stringWithFormat:@"%ld",(long)[_preferUtil getInt:LastWorkUpdate]];
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"POST" URLString:urlStr parameters:@{@"type":@"0",@"time":updatetime}                                                                                    error:nil];
    [request addValue:userId forHTTPHeaderField:@"userId"];
    [request addValue:token forHTTPHeaderField:@"token"];
    [request addValue:dbid forHTTPHeaderField:@"dbid"];
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id _Nonnull responseObject, NSError *error) {
        if (error) {
            NSLog(@"Error:-->%@", error);
            if (isRefresh) {
                [self.tableView.mj_header endRefreshing];
            } else{
                [self.tableView.mj_footer endRefreshing];
            }
            [self.dataModels removeAllObjects];
            [self getLocalData:0 pageNum:0 isRefresh:YES];
        } else {
            NSString *responseString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            NSLog(@"DATA-->%@", responseString);
            if (responseObject) {
                NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
                if ([dictionary[@"result"] intValue] == 1) {
                    if (isRefresh) {//下拉得到的数据
                        [self.newModels removeAllObjects];
                    }
                    NSArray* data = dictionary[@"data"];
                    NSArray* modelArray = [Work mj_objectArrayWithKeyValuesArray:data];
                    [self.newModels addObjectsFromArray:modelArray];
                    if (isRefresh) {
                        [self.tableView.mj_header endRefreshing];
                    }
                    [self mergeData];
                    [_preferUtil setInt:LastWorkUpdate data:[dictionary[@"updatetime"] longValue]];
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
            [self getLocalData:0 pageNum:0 isRefresh:YES];
        }
    }];
    [dataTask resume];
}

- (void)getUnreadWork{
    
    NSString *userId = [NSString stringWithFormat:@"%ld",(long)[Config getOrgUserID]];;
    NSString *token = [Config getToken];
    NSString *dbid = [NSString stringWithFormat:@"%ld",(long)[Config getDbID]];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    
    NSString* urlStr = [NSString stringWithFormat:@"%@%@",BASE_URL,API_WORK_UNREAD];
    NSInteger time = [_preferUtil getInt:LastWorkUpdate];
    NSDate *date = [NSDate new];
    NSLog(@"---time %@",[NSString stringWithFormat:@"%ld",(long)[date timeIntervalSince1970]]);
    if (time == 0) {
        time = (long)[date timeIntervalSince1970];
        [_preferUtil setInt:LastWorkUpdate data:time];
    }else{}
    NSString *lasttime = [NSString stringWithFormat:@"%ld",(long)time];
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"POST" URLString:urlStr parameters:@{@"lasttime":lasttime}                                                                                    error:nil];
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
                    NSArray* modelArray = [Work mj_objectArrayWithKeyValuesArray:data];
                    [self.unreadDatas removeAllObjects];
                    [self.unreadDatas addObjectsFromArray:modelArray];
                    [self mergeDataUnread];
                }else{
                    NSInteger count = [_preferUtil getInt:UnreadWorkListCount];
                    [self.unreadDatas addObjectsFromArray:[FileUtils inReadDataFromFile:UnreadWorkList]];
                    if (count > 0) {
                        self.tableView.tableHeaderView = _headerView;
                        NSString *c = [NSString stringWithFormat:@"%ld",(long)count];
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

- (NSMutableArray *)newModels {
    if (_newModels == nil) {
        _newModels = [NSMutableArray array];
    }
    return _newModels;
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
    id model = self.dataModels[indexPath.row];
    return [self.tableView cellHeightForIndexPath:indexPath model:model keyPath:@"model" cellClass:[WorkTableViewCell class] contentViewWidth:[self cellContentViewWith]];
    
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    [cell setSeparatorInset:UIEdgeInsetsZero];
    [cell setLayoutMargins:UIEdgeInsetsZero];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    WorkTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kWorkTableCellId];
    if (!cell) {
        cell = [[WorkTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kWorkTableCellId];
    }
    cell.indexPath = indexPath;
    __weak typeof(self) weakSelf = self;
    if (!cell.moreButtonClickedBlock) {
        [cell setMoreButtonClickedBlock:^(NSIndexPath *indexPath) {
            Work *model = weakSelf.dataModels[indexPath.row];
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
    WorkDetailsBottomBarViewController *vc = [[WorkDetailsBottomBarViewController alloc] initWithWorkID:self.dataModels[indexPath.row]];
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

- (void)mergeData{
    for (int i = 0; i < self.newModels.count; i++) {
        Work *work = self.newModels[i];
        Work *t = [_workDb selectWorkById:work.id];
        if (work.status == 0) {
            continue;
        }
        if(t.id == 0){
            [_workDb insertWork:work];
            for (int j = 0; j < work.staffList.count; j++) {
                OrgUserInfo *staff = work.staffList[j];
                [_staffDb insertStaffInfo:staff workId:work.id];
            }
            for (int j = 0; j < work.workCommentsList.count; j++) {
                Comment *comment = work.workCommentsList[j];
                [_commentDb insertComment:comment workid:work.id];
            }
        }else{
            [_commentDb deleteCommentByWorkId:work.id];
            for (int j = 0; j < work.workCommentsList.count; j++) {
                Comment *comment = work.workCommentsList[j];
                [_commentDb insertComment:comment workid:work.id];
            }
        }
    }
}

- (void)getLocalData:(NSInteger)type pageNum:(NSInteger)page isRefresh:(BOOL)refresh{
    NSMutableArray *array = [_workDb selectAll:type pageNum:page];
    for (int i = 0; i < array.count; i++) {
        Work *work = array[i];
        NSMutableArray *comments = [_commentDb selectAll:work.id];
        work.workCommentsList = comments.mutableCopy;
    }
    if (refresh) {
        [self.dataModels removeAllObjects];
    }
    [self.dataModels addObjectsFromArray:array];
    if (!refresh) {
        if (array.count < 20) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        } else {
            [self.tableView.mj_footer endRefreshing];
        }
    }
    [self.tableView reloadData];
}

- (void)workColleagueDidClick:(Work *)work{
    WorkStaffTableViewController *vc = [[WorkStaffTableViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.view.backgroundColor = [UIColor whiteColor];
    vc.work = work;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)mergeDataUnread{
    NSMutableArray *local = [FileUtils inReadDataFromFile:UnreadWorkList];
    NSInteger count = 0;
    for (int i = 0; i < self.unreadDatas.count; i++) {
        Boolean flag = true;
        Work *work = self.unreadDatas[i];
        for (int j = 0; j < local.count && flag; j++) {
            Work *w = local[j];
            if (work.id == w.id && work.workCommentsIds != nil) {
                [work.workCommentsIds addObjectsFromArray:w.workCommentsIds];
                flag = false;
                NSSet *set = [[NSSet alloc] initWithArray:w.workCommentsIds];
                [w.workCommentsIds removeAllObjects];
                [w.workCommentsIds addObjectsFromArray:[set allObjects]];
                count = count + w.counts;
                [self.unreadDatas replaceObjectAtIndex:j withObject:w];
            }
        }
        if (flag && work.counts > 0) {
            [local addObject:work];
            count = count + work.counts;
        }
    }
    [self.unreadDatas removeAllObjects];
    [self.unreadDatas addObjectsFromArray:local];
    [_preferUtil setInt:UnreadWorkListCount data:count];
    [FileUtils inSaveDataToFile:UnreadWorkList data:self.unreadDatas];
    if (count > 0) {
        self.tableView.tableHeaderView = _headerView;
        NSString *c = [NSString stringWithFormat:@"%ld",(long)count];
        _unreadLabel.text = [c stringByAppendingString:@"条消息未读"];
    }else{
        self.tableView.tableHeaderView = nil;
    }
}

- (void)unreadClicked:(UITapGestureRecognizer *)rec{
    if (rec.state == UIGestureRecognizerStateBegan) {
        _headerView.backgroundColor = [UIColor lightGrayColor];
    }else if(rec.state == UIGestureRecognizerStateEnded){
        _headerView.backgroundColor = [UIColor whiteColor];
        WorkUnreadTableViewController *unreadVC = [[WorkUnreadTableViewController alloc] init];
        unreadVC.hidesBottomBarWhenPushed = YES;
        unreadVC.view.backgroundColor = [UIColor whiteColor];
        [self.navigationController pushViewController:unreadVC animated:YES];
    }
}

- (void)chooseClicked {
    ChooseItem *item1 = [[ChooseItem alloc] initWithTitle:@"我下属的工作" icon:@"work_underling"];
    ChooseItem *item2 = [[ChooseItem alloc] initWithTitle:@"我参与的工作" icon:@"work_involvement"];
    ChooseItem *item3 = [[ChooseItem alloc] initWithTitle:@"我的工作" icon:@"work_my"];
    ChooseItem *item4 = [[ChooseItem alloc] initWithTitle:@"全部工作" icon:@"work_all"];
    NSArray *items = @[item1,item2,item3,item4];
    WorkChooseView *chooseView = [[WorkChooseView alloc] initWithItem:items selectIndex:^(NSInteger selectIndex) {
        [self getLocalData:selectIndex pageNum:0 isRefresh:YES];
    }];
    [KeyWindow addSubview:chooseView];
    [chooseView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(KeyWindow);
    }];
    [chooseView show];
}

@end
