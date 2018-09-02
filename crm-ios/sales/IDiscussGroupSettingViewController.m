//
//  IDiscussGroupSettingViewController.m
//  sales
//
//  Created by user on 2017/3/2.
//  Copyright © 2017年 rayootech. All rights reserved.
//

#import "IDiscussGroupSettingViewController.h"
#import "ODiscussSettingCell.h"
#import "ODiscussSettingSwitchCell.h"
#import "SelectColleaguesTableViewController.h"
#import "OrgUserInfoDbUtil.h"
#import "ODiscussSettingHeaderView.h"

@interface IDiscussGroupSettingViewController ()

// 创建者
@property (nonatomic, copy) NSString *creatorId;
@property (nonatomic, strong) NSMutableDictionary *members;
// 群成员列表
@property (nonatomic, strong) NSMutableArray *userList;
@property (nonatomic, strong) OrgUserInfoDbUtil *dbUtil;
// 选项标题数组
@property (nonatomic, strong) NSArray *titles;
// 是否有踢人权限
@property (nonatomic, assign) BOOL isCanDelete;
// 是否置顶
@property (nonatomic, assign) BOOL isTop;
// 是否开启消息通知
@property (nonatomic, assign) BOOL isOpenNotify;
// 是否是创建者
@property (nonatomic, assign) BOOL isCreator;
// 是否已修改讨论组名称
@property (nonatomic, assign) BOOL isUpdateDiscussTitle;
@property (nonatomic, strong) ODiscussSettingHeaderView *headerView;
@property (nonatomic, assign) BOOL isAdd;

@end

@implementation IDiscussGroupSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.rowHeight = 48;
    self.tableView.tableFooterView = [self footerView];
    [self.tableView registerNib:[UINib nibWithNibName:@"ODiscussSettingCell" bundle:nil] forCellReuseIdentifier:@"kODiscussSettingCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"ODiscussSettingSwitchCell" bundle:nil] forCellReuseIdentifier:@"kODiscussSettingSwitchCell"];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshHeaderView:) name:@"addDiscussiongroupMember" object:nil];
    
    [self getIsTop];
    [self getIsOpenNotify];
    [self getGroupMembers];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    if (self.isUpdateDiscussTitle && self.setDiscussTitleCompletion) {
        self.setDiscussTitleCompletion(_discussTitle);
    }
}

- (void)refreshHeaderView:(NSNotification *)notification {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSMutableArray *members = notification.object;
        if (self.isAdd) {
            [self.userList addObjectsFromArray:members];
        } else {
            for (OrgUserInfo *model in members) {
                if ([self.userList containsObject:model]) {
                    [self.userList removeObject:model];
                }
            }
        }
        self.navigationItem.title = [NSString stringWithFormat:@"群组信息(%ld)",self.userList.count];
        [self.headerView refreshData:self.userList];
    });
}

- (void)getIsTop {
    RCConversation *conversation = [[RCIMClient sharedRCIMClient] getConversation:self.conversationType targetId:self.targetId];
    self.isTop = conversation.isTop;
}

- (void)getIsOpenNotify {
    [[RCIMClient sharedRCIMClient] getConversationNotificationStatus:self.conversationType targetId:self.targetId success:^(RCConversationNotificationStatus nStatus) {
        self.isOpenNotify = nStatus == NOTIFY;
    } error:nil];
}

- (OrgUserInfoDbUtil *)dbUtil {
    if (!_dbUtil) {
        _dbUtil = [[OrgUserInfoDbUtil alloc] init];
    }
    return _dbUtil;
}

- (NSMutableDictionary *)members {
    if (!_members) {
        _members = [[NSMutableDictionary alloc] init];
    }
    return _members;
}

- (NSMutableArray *)userList {
    if (!_userList) {
        _userList = [[NSMutableArray alloc] init];
    }
    return _userList;
}

- (NSArray *)titles {
    if (!_titles) {
        _titles = @[@"群组名称",@"消息免打扰",@"消息置顶"];
    }
    return _titles;
}

- (UIView *)headerView {
    if (!_headerView) {
        _headerView = [[ODiscussSettingHeaderView alloc] initWithDataArray:self.userList isCreator:self.isCreator];
        WeakSelf;
        _headerView.updateFrameBlock = ^{
            weakSelf.tableView.tableHeaderView = weakSelf.headerView;
        };
        _headerView.addMemberBlock = ^{
            weakSelf.isAdd = true;
            SelectColleaguesTableViewController *contactSelectedVC= [[SelectColleaguesTableViewController alloc]init];
            contactSelectedVC.dataArray = weakSelf.userList;
            contactSelectedVC.discussionId = weakSelf.targetId;
            contactSelectedVC.type = SelectColleaguesAdd;
            contactSelectedVC.navigationItem.title = @"添加成员";
            [weakSelf.navigationController presentViewController:[[UINavigationController alloc] initWithRootViewController:contactSelectedVC] animated:true completion:nil];
        };
        _headerView.deleteMemberBlock = ^{
            weakSelf.isAdd = false;
            SelectColleaguesTableViewController *contactSelectedVC = [[SelectColleaguesTableViewController alloc]init];
            contactSelectedVC.dataArray = [weakSelf.userList mutableCopy];
            [contactSelectedVC.dataArray removeObjectAtIndex:0];
            contactSelectedVC.discussionId = weakSelf.targetId;
            contactSelectedVC.type = SelectColleaguesDelete;
            contactSelectedVC.navigationItem.title = @"删除成员";
            [weakSelf.navigationController presentViewController:[[UINavigationController alloc] initWithRootViewController:contactSelectedVC] animated:true completion:nil];
        };
    }
    return _headerView;
}

- (UIView *)footerView {
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 88)];
    UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    deleteBtn.frame = CGRectMake(20, 20, self.view.frame.size.width - 40, 48);
    deleteBtn.titleLabel.font = SYSTEM_FONT(14);
    deleteBtn.backgroundColor = SDColor(31, 90, 248, 1);
    deleteBtn.layer.cornerRadius = 5;
    deleteBtn.layer.masksToBounds = true;
    [deleteBtn setTitle:@"删除并退出" forState:UIControlStateNormal];
    [deleteBtn addTarget:self action:@selector(quitClicked:) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:deleteBtn];
    return footerView;
}

- (void)getGroupMembers {
    // 获取讨论组成员
    if (self.conversationType == ConversationType_DISCUSSION) {
        WeakSelf;
        [[RCIMClient sharedRCIMClient] getDiscussion:self.targetId success:^(RCDiscussion *discussion) {
            if (discussion) {
                weakSelf.creatorId = discussion.creatorId;
                if ([[RCIMClient sharedRCIMClient].currentUserInfo.userId isEqualToString:discussion.creatorId]) {
                    weakSelf.isCanDelete = true;
                    self.isCreator = true;
                } else {
                    weakSelf.isCanDelete = false;
                    self.isCreator = false;
                }
                
                for (NSString *targetId in discussion.memberIdList) {
                    NSArray *ids = [targetId componentsSeparatedByString:@"_"];
                    NSString *fid = ids[2];
                    OrgUserInfo *contact = [weakSelf.dbUtil selectOrgUserById:[fid integerValue]];
                    if (contact && contact.id > 0) {
                        NSLog(@"---%@",fid);
                        [weakSelf.members setObject:contact forKey:fid];
                        [weakSelf.userList addObject:contact];
                    }
                }
                if (self.isCreator) {
                    OrgUserInfo *my = [Config getOrgUser];
                    [weakSelf.userList insertObject:my atIndex:0];
                }
                self.navigationItem.title = [NSString stringWithFormat:@"群组信息(%ld)",self.userList.count];
                self.tableView.tableHeaderView = self.headerView;
            }
        } error:^(RCErrorCode status) {
            
        }];
    }
}

- (void)quitClicked:(UIButton *)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"删除并且退出讨论组" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"确定" otherButtonTitles:nil];
    [actionSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        WeakSelf;
        [[RCIM sharedRCIM] quitDiscussion:self.targetId success:^(RCDiscussion *discussion) {
            NSLog(@"退出讨论组成功");
            UIViewController *temp = nil;
            NSArray *viewControllers =
            weakSelf.navigationController.viewControllers;
            temp = viewControllers[viewControllers.count - 1 - 2];
            if (temp) {
                //切换主线程
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf.navigationController popToViewController:temp animated:YES];
                });
            }
        } error:^(RCErrorCode status) {
            NSLog(@"quit discussion status is %ld", (long)status);
        }];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.titles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        ODiscussSettingCell *cell = [tableView dequeueReusableCellWithIdentifier:@"kODiscussSettingCell" forIndexPath:indexPath];
        cell.titleLabel.text = self.titles[indexPath.row];
        cell.contentTF.text = self.discussTitle;
        cell.indexPath = indexPath;
        cell.block = ^(NSIndexPath *indexPath, NSString *content) {
            self.discussTitle = content;
            self.isUpdateDiscussTitle = true;
        };
        return cell;
        
    } else {
        ODiscussSettingSwitchCell *cell = [tableView dequeueReusableCellWithIdentifier:@"kODiscussSettingSwitchCell" forIndexPath:indexPath];
        cell.titleLabel.text = self.titles[indexPath.row];
        cell.indexPath = indexPath;
        if (indexPath.row == 1) { // 设置新消息通知状态
             cell.rightSwitch.on = !self.isOpenNotify;
            
        } else { // 设置置顶聊天状态
            cell.rightSwitch.on = self.isTop;
        }
        cell.block = ^(NSIndexPath *indexPath, BOOL on) {
            if (indexPath.row == 1) { // 消息免打扰
                [[RCIMClient sharedRCIMClient] setConversationNotificationStatus:self.conversationType targetId:self.targetId isBlocked:on success:^(RCConversationNotificationStatus nStatus) {
                    self.isOpenNotify = nStatus == NOTIFY;
                    [self.tableView reloadData];
                } error:nil];
                
            } else { // 置顶聊天
                [[RCIMClient sharedRCIMClient] setConversationToTop:self.conversationType targetId:self.targetId isTop:on];
                self.isTop = on;
                [self.tableView reloadData];
            }
        };
        return cell;
    }
}

@end
