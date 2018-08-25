//
//  IBlackboardTableViewController.m
//  sales
//
//  Created by user on 2017/1/18.
//  Copyright © 2017年 rayootech. All rights reserved.
//

#import "IBlackboardTableViewController.h"
#import "BlackBoardDetailsBottomBarViewController.h"
#import "BlackBoardTableViewCell.h"
#import "BlackBoard.h"
#import "BlackBoardUnreadTableViewController.h"

#define kBlackBoardTableCellId @"BlackBoardTableCell"
#define kMainWidth [UIScreen mainScreen].bounds.size.width
@interface IBlackboardTableViewController ()<BlackBoardCellDelegate,UITableViewDelegate,UITableViewDataSource,UITextViewDelegate>
@property (nonatomic,strong) NSMutableArray *dataModels;
@property (nonatomic,strong) UIView         *headerView;
@property (nonatomic,strong) UILabel        *unreadLabel;
@property (nonatomic,strong) PreferUtil     *preferUtil;
@property (nonatomic,strong) NSMutableArray *unreadDatas;
@property (nonatomic,strong) EditingBar     *editingBar;
@property (nonatomic, strong) NSLayoutConstraint *editingBarYConstraint;
@property (nonatomic, strong) NSLayoutConstraint *editingBarHeightConstraint;
//@property (nonatomic,strong) UITableView            *tableView;
@property (nonatomic,strong) NSIndexPath    *currentIndex;
@end

@implementation IBlackboardTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.height) style:UITableViewStylePlain];
    [self.view addSubview:_tableView];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _editingBar = [[EditingBar alloc] initWithShowSwitch:false showPhoto:false];
    
    _preferUtil = [PreferUtil new];
    [_preferUtil initIN];
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
        [self getBlackBoardList:YES];
        [self getUnreadBlackBoard];
    }];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self getBlackBoardList:NO];
    }];
    self.tableView.mj_header.automaticallyChangeAlpha = YES;
    [self.tableView.mj_header beginRefreshing];
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(getUnreadBlackBoard) name:@"updateUnreadBlackBoard" object:nil];
    [self initEditBar];
}
- (void)initEditBar{
    [self.view addSubview:_editingBar];
    _editingBar.editView.delegate = self;
    _editingBar.hidden = YES;
    _editingBarYConstraint = [NSLayoutConstraint constraintWithItem:self.view    attribute:NSLayoutAttributeBottom   relatedBy:NSLayoutRelationEqual
                                                             toItem:_editingBar  attribute:NSLayoutAttributeBottom   multiplier:1.0 constant:0];
    
    _editingBarHeightConstraint = [NSLayoutConstraint constraintWithItem:_editingBar attribute:NSLayoutAttributeHeight         relatedBy:NSLayoutRelationEqual
                                                                  toItem:nil         attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:_editingBar.intrinsicContentSize.height];
    
    [self.view addConstraint:_editingBarYConstraint];
    [self.view addConstraint:_editingBarHeightConstraint];
    for (UIView *view in self.view.subviews) {view.translatesAutoresizingMaskIntoConstraints = NO;}
    NSDictionary *views = @{@"tableView": self.tableView, @"editingBar": self.editingBar};
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[editingBar]|" options:0 metrics:nil views:views]];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidUpdate:)    name:UITextViewTextDidChangeNotification object:nil];
}



- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.tableView ) {
        [_editingBar.editView resignFirstResponder];
        self.tabBarController.tabBar.hidden = NO;
    }
}
- (void)getBlackBoardList:(BOOL)isRefresh{
    NSString *userId = [NSString stringWithFormat:@"%ld",(long)[Config getOrgUserID]];;
    NSString *token = [Config getToken];
    NSString *dbid = [NSString stringWithFormat:@"%ld",(long)[Config getDbID]];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    
    NSString* urlStr = [NSString stringWithFormat:@"%@%@",BASE_URL,API_BLACKBOARD_LIST];
    NSInteger p = 0;
    p = isRefresh?1:self.dataModels.count / 10 + 1;
    NSString *page = [NSString stringWithFormat:@"%ld",(long)p];
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"POST" URLString:urlStr parameters:@{@"page":page,@"pagenum":@"10"}                                                                                    error:nil];
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
        } else {
            NSString *responseString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            NSLog(@"DATA-->%@", responseString);
            if (responseObject) {
                NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
                if ([dictionary[@"result"] intValue] == 1) {
                    if (isRefresh) {//下拉得到的数据
                        [self.dataModels removeAllObjects];
                    }
                    NSArray* data = dictionary[@"data"];
                    NSArray* modelArray = [BlackBoard mj_objectArrayWithKeyValuesArray:data];
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
                    [_preferUtil setInt:LastUnreadBlackBoardTime data:[dictionary[@"updatetime"] longValue]];
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

- (void)getUnreadBlackBoard{
    
    NSString *userId = [NSString stringWithFormat:@"%ld",(long)[Config getOrgUserID]];;
    NSString *token = [Config getToken];
    NSString *dbid = [NSString stringWithFormat:@"%ld",(long)[Config getDbID]];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    
    NSString* urlStr = [NSString stringWithFormat:@"%@%@",BASE_URL,API_BLACKBOARD_UNREAD];
    NSInteger time = [_preferUtil getInt:LastUnreadBlackBoardTime];
    NSDate *date = [NSDate new];
    NSLog(@"---time %@",[NSString stringWithFormat:@"%ld",(long)[date timeIntervalSince1970]]);
    if (time == 0) {
        time = (long)[date timeIntervalSince1970];
        [_preferUtil setInt:LastUnreadBlackBoardTime data:time];
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
                    NSArray* modelArray = [Comment mj_objectArrayWithKeyValuesArray:data];
                    [self.unreadDatas removeAllObjects];
                    [self.unreadDatas addObjectsFromArray:modelArray];
                    //                    [self saveDateToFile];
                    [self mergeData];
                }else{
                    NSInteger count = [_preferUtil getInt:UnreadBlackBoardListCount];
                    [self.unreadDatas addObjectsFromArray:[FileUtils inReadDataFromFile:UnreadBlackBoardList]];
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
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // >>>>>>>>>>>>>>>>>>>>> * cell自适应 * >>>>>>>>>>>>>>>>>>>>>>>>
    id model = self.dataModels[indexPath.row];
    return [self.tableView cellHeightForIndexPath:indexPath model:model keyPath:@"model" cellClass:[BlackBoardTableViewCell class] contentViewWidth:[self cellContentViewWith]];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    BlackBoardTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kBlackBoardTableCellId];
    if (!cell) {
        cell = [[BlackBoardTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kBlackBoardTableCellId];
    }
    cell.indexPath = indexPath;
    __weak typeof(self) weakSelf = self;
    if (!cell.moreButtonClickedBlock) {
        [cell setMoreButtonClickedBlock:^(NSIndexPath *indexPath) {
            BlackBoard *model = weakSelf.dataModels[indexPath.row];
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
    BlackBoardDetailsBottomBarViewController *vc = [[BlackBoardDetailsBottomBarViewController alloc] initWithBlackBoardID:self.dataModels[indexPath.row]];
    vc.hidesBottomBarWhenPushed = YES;
    vc.view.backgroundColor = [UIColor whiteColor];
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
- (void)mergeData{
    NSMutableArray *local = [FileUtils inReadDataFromFile:UnreadBlackBoardList];
    NSInteger count = 0;
    for (int i = 0; i < self.unreadDatas.count; i++) {
        Boolean flag = true;
        Comment *comment = self.unreadDatas[i];
        for (int j = 0; j < local.count && flag; j++) {
            Comment *c = local[j];
            if (comment.id == c.id && comment.commentsidlist != nil) {
                [comment.commentsidlist addObjectsFromArray:c.commentsidlist];
                flag = false;
                NSSet *set = [[NSSet alloc] initWithArray:c.commentsidlist];
                [c.commentsidlist removeAllObjects];
                [c.commentsidlist addObjectsFromArray:[set allObjects]];
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
    [_preferUtil setInt:UnreadBlackBoardListCount data:count];
    [FileUtils inSaveDataToFile:UnreadBlackBoardList data:self.unreadDatas];
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
        BlackBoardUnreadTableViewController *unreadVC = [[BlackBoardUnreadTableViewController alloc] init];
        unreadVC.hidesBottomBarWhenPushed = YES;
        unreadVC.view.backgroundColor = [UIColor whiteColor];
        [self.navigationController pushViewController:unreadVC animated:YES];
    }
}

- (void)deleteClick:(NSIndexPath *)indexPath{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"删除" message:@"确定要删除该黑板吗？" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *sure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self deleteBlackBoard:indexPath];
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alert addAction:sure];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:^{}];
}
- (void)deleteBlackBoard:(NSIndexPath *)indexPath{
    BlackBoard *blackBoard = self.dataModels[indexPath.row];
    NSString *userId = [NSString stringWithFormat:@"%ld",(long)[Config getOrgUserID]];;
    NSString *token = [Config getToken];
    NSString *dbid = [NSString stringWithFormat:@"%ld",(long)[Config getDbID]];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    
    NSString* urlStr = [NSString stringWithFormat:@"%@%@",BASE_URL,API_BLACKBOARD_DELETE];
    
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"POST" URLString:urlStr parameters:@{@"postid":[NSString stringWithFormat:@"%ld",(long)blackBoard.id],@"commentid":@"-1"}                                                                                    error:nil];
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
                    [self.dataModels removeObject:blackBoard];
                    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                }else{
                    
                }
                
            }else{
                
            }
        }
    }];
    [dataTask resume];
}

- (void)commentClick:(NSIndexPath *)indexPath{
    self.tabBarController.tabBar.hidden = YES;
    _editingBar.hidden = NO;
    _currentIndex = indexPath;
}

#pragma mark - 调整bar的高度

- (void)keyboardWillShow:(NSNotification *)notification
{
    CGRect keyboardBounds = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    _editingBarYConstraint.constant = keyboardBounds.size.height;
    [self setBottomBarHeight];
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    _editingBarYConstraint.constant = 0;
    
    [self setBottomBarHeight];
}

- (void)setBottomBarHeight
{
#if 0
    NSTimeInterval animationDuration;
    [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];
    
    UIViewKeyframeAnimationOptions animationOptions;
    animationOptions = [notification.userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue] << 16;
#endif
    // 用注释的方法有可能会遮住键盘
    
    [self.view setNeedsUpdateConstraints];
    [UIView animateKeyframesWithDuration:0.25       //animationDuration
                                   delay:0
                                 options:7 << 16    //animationOptions
                              animations:^{
                                  [self.view layoutIfNeeded];
                              } completion:nil];
}



#pragma mark - 编辑框相关

- (void)textDidUpdate:(NSNotification *)notification
{
    [self updateInputBarHeight];
}

- (void)updateInputBarHeight
{
    CGFloat inputbarHeight = [self appropriateInputbarHeight];
    
    if (inputbarHeight != self.editingBarHeightConstraint.constant) {
        self.editingBarHeightConstraint.constant = inputbarHeight;
        
        [self.view layoutIfNeeded];
    }
}

- (CGFloat)appropriateInputbarHeight
{
    CGFloat height = 0;
    CGFloat minimumHeight = _editingBar.intrinsicContentSize.height;
    CGFloat newSizeHeight = [_editingBar.editView measureHeight];
    CGFloat maxHeight     = _editingBar.editView.maxHeight;
    
    _editingBar.editView.scrollEnabled = newSizeHeight >= maxHeight;
    
    if (newSizeHeight < minimumHeight) {
        height = minimumHeight;
    } else if (newSizeHeight < _editingBar.editView.maxHeight) {
        height = newSizeHeight;
    } else {
        height = _editingBar.editView.maxHeight;
    }
    
    return roundf(height);
}


- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString: @"\n"]) {
        [self sendContent];
        [textView resignFirstResponder];
        //        }
        return NO;
    }
    return YES;
}
- (void)sendContent{
    MBProgressHUD *HUD = [Utils createHUD];
    
    NSString *comStr = self.editingBar.editView.text;
    comStr = [comStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (comStr.length <= 0) {
        NSLog(@"----");
        HUD.label.text = @"评论不能为空";
        [HUD hideAnimated:YES afterDelay:2500];
        return;
    }
    HUD.label.text = @"评论发送中";
    NSString *userId = [NSString stringWithFormat:@"%ld",(long)[Config getOrgUserID]];;
    NSString *token = [Config getToken];
    NSString *dbid = [NSString stringWithFormat:@"%ld",(long)[Config getDbID]];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    
    NSString* urlStr = [NSString stringWithFormat:@"%@%@",BASE_URL,API_BLACKBOARD_COMMENT_POST];
    BlackBoard *b = self.dataModels[_currentIndex.row];
    NSInteger postid = b.id;
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"POST" URLString:urlStr parameters:@{@"postid":[NSString stringWithFormat:@"%ld",(long)postid],@"commentid":[NSString stringWithFormat:@"%ld",0L],@"content":self.editingBar.editView.text}                                                                                   error:nil];//912
    [request addValue:userId forHTTPHeaderField:@"userId"];
    [request addValue:token forHTTPHeaderField:@"token"];
    [request addValue:dbid forHTTPHeaderField:@"dbid"];
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id _Nonnull responseObject, NSError *error) {
        if (error) {
            NSLog(@"Error:-->%@", error);
            HUD.mode = MBProgressHUDModeCustomView;
            HUD.label.text = @"网络异常，评论发送失败";
            
            [HUD hideAnimated:YES afterDelay:1];
        } else {
            NSString *responseString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            NSLog(@"DATA-->%@", responseString);
            if (responseObject) {
                NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
                if ([dictionary[@"result"] intValue] == 1) {
                    HUD.label.text = @"评论发表成功";
                    self.editingBar.editView.text = @"";
                    self.editingBar.editView.placeholder = @"说点什么";
                    Comment *comment = [Comment mj_objectWithKeyValues:dictionary[@"data"]];
                    comment.uname = [Config getUser].name;
                    comment.uid = [Config getUser].id;
                    BlackBoard *black = self.dataModels[_currentIndex.row];
                    [black.bbCommentsList insertObject:comment atIndex:0];
//                    [b.bbCommentsList addObject:comment];
                    [self.dataModels replaceObjectAtIndex:[_currentIndex row] withObject:b];
                    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:_currentIndex,nil] withRowAnimation:UITableViewRowAnimationNone];
                }else{
                    HUD.label.text = @"评论失败";
                }
                [HUD hideAnimated:YES afterDelay:1];
            }else{
            }
        }
    }];
    [dataTask resume];
}
@end
