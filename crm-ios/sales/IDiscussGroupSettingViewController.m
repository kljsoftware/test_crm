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
#import "SalesApi.h"
#import "Config.h"
#import <AFNetworking.h>
#import <MJExtension.h>

@interface IDiscussGroupSettingViewController ()

@property(nonatomic, copy) NSString *discussTitle;
@property(nonatomic, copy) NSString *creatorId;
@property(nonatomic, strong) NSMutableDictionary *members;
@property(nonatomic, strong) NSMutableArray *userList;
@property(nonatomic) BOOL isOwner;
@property(nonatomic, assign) BOOL isClick;
@property (nonatomic,strong) OrgUserInfoDbUtil *dbUtil;

@end

@implementation IDiscussGroupSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //显示顶部视图
    self.headerHidden = NO;
    _dbUtil = [[OrgUserInfoDbUtil alloc] init];
    _members = [[NSMutableDictionary alloc] init];
    _userList = [[NSMutableArray alloc] init];
    
    //添加当前聊天用户
    if (self.conversationType == ConversationType_PRIVATE) {
    }
    
    //添加讨论组成员
    if (self.conversationType == ConversationType_DISCUSSION) {
        
        __weak ISettingBaseViewController *weakSelf = self;
        [[RCIMClient sharedRCIMClient] getDiscussion:self.targetId
                                             success:^(RCDiscussion *discussion) {
                                                 if (discussion) {
                                                     _creatorId = discussion.creatorId;
                                                     if ([[RCIMClient sharedRCIMClient]
                                                          .currentUserInfo.userId isEqualToString:discussion.creatorId]) {
                                                         [weakSelf disableDeleteMemberEvent:NO];
                                                         self.isOwner = YES;
                                                         
                                                     } else {
                                                         [weakSelf disableDeleteMemberEvent:YES];
                                                         self.isOwner = NO;
                                                         if (discussion.inviteStatus == 1) {
                                                             [self disableInviteMemberEvent:YES];
                                                         }
                                                     }
                                                     
                                                     NSMutableArray *users = [NSMutableArray new];
                                                     for (NSString *targetId in discussion.memberIdList) {
                                                         NSArray *ids = [targetId componentsSeparatedByString:@"_"];
                                                         NSString *fid = ids[2];
                                                         
                                                         OrgUserInfo * contact = [_dbUtil selectOrgUserById:[fid integerValue]];
                                                         if (contact != nil && contact.id > 0) {
                                                             [users addObject:contact];
                                                             NSLog(@"---%@",fid);
                                                             [_members setObject:contact forKey:fid];
                                                             if (users.count == discussion.memberIdList.count) {
//                                                                 [weakSelf addUsers:users];
//                                                                 [_userList addObjectsFromArray:users];
                                                             }
                                                         }else{

                                                         }
                                                     }
                                                     OrgUserInfo *my = [Config getOrgUser];
                                                     [users addObject:my];
                                                     [weakSelf addUsers:users];
                                                     [_userList addObjectsFromArray:users];
                                                 }
                                             }
                                               error:^(RCErrorCode status){
                                                   
                                               }];
    }
    UIView *view = [[UIView alloc]
                    initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 45)];
    
    UIImage *image = [UIImage imageNamed:@"group_quit"];
    UIButton *button = [[UIButton alloc]
                        initWithFrame:CGRectMake(0, 0, self.view.frame.size.width - 42, 90 / 2)];
    
    [button setBackgroundImage:image forState:UIControlStateNormal];
    [button setTitle:@"删除并退出" forState:UIControlStateNormal];
    [button setCenter:CGPointMake(view.bounds.size.width / 2,
                                  view.bounds.size.height / 2)];
    [button addTarget:self
               action:@selector(buttonAction:)
     forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:button];
    self.tableView.tableFooterView = view;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshHeaderView:) name:@"addDiscussiongroupMember" object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    _isClick = YES;
}

- (void)buttonAction:(UIButton *)sender {
    UIActionSheet *actionSheet =
    [[UIActionSheet alloc] initWithTitle:@"删除并且退出讨论组"
                                delegate:self
                       cancelButtonTitle:@"取消"
                  destructiveButtonTitle:@"确定"
                       otherButtonTitles:nil];
    [actionSheet showInView:self.view];
}
#pragma mark -UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet
clickedButtonAtIndex:(NSInteger)buttonIndex {
    if ([actionSheet isEqual:self.clearMsgHistoryActionSheet] &&
        buttonIndex == 0) {
        [self clearHistoryMessage];
    } else {
        if (0 == buttonIndex) {
            __weak typeof(&*self) weakSelf = self;
            [[RCIM sharedRCIM] quitDiscussion:self.targetId
                                      success:^(RCDiscussion *discussion) {
                                          NSLog(@"退出讨论组成功");
                                          UIViewController *temp = nil;
                                          NSArray *viewControllers =
                                          weakSelf.navigationController.viewControllers;
                                          temp = viewControllers[viewControllers.count - 1 - 2];
                                          if (temp) {
                                              //切换主线程
                                              dispatch_async(dispatch_get_main_queue(), ^{
                                                  [weakSelf.navigationController popToViewController:temp
                                                                                            animated:YES];
                                              });
                                          }
                                      }
                                        error:^(RCErrorCode status) {
                                            NSLog(@"quit discussion status is %ld", (long)status);
                                            
                                        }];
        }
    }
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    if (self.isOwner) {
        return self.defaultCells.count + 2;
    } else {
        return self.defaultCells.count + 1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    int offset = 2;
    if (!self.isOwner) {
        offset = 1;
    }
    switch (indexPath.row) {
        case 0: {
            ODiscussSettingCell *discussCell =
            [[ODiscussSettingCell alloc] initWithFrame:CGRectZero];
            discussCell.lblDiscussName.text = self.conversationTitle;
            discussCell.lblTitle.text = @"讨论组名称";
            cell = discussCell;
            _discussTitle = discussCell.lblDiscussName.text;
        } break;
        case 1: {
            if (self.isOwner) {
                ODiscussSettingSwitchCell *switchCell =
                [[ODiscussSettingSwitchCell alloc] initWithFrame:CGRectZero];
                switchCell.label.text = @"开放成员邀请";
                [[RCIMClient sharedRCIMClient] getDiscussion:self.targetId
                                                     success:^(RCDiscussion *discussion) {
                                                         if (discussion.inviteStatus == 0) {
                                                             switchCell.swich.on = YES;
                                                         }
                                                     }
                                                       error:^(RCErrorCode status){
                                                           
                                                       }];
                [switchCell.swich addTarget:self
                                     action:@selector(openMemberInv:)
                           forControlEvents:UIControlEventTouchUpInside];
                cell = switchCell;
            } else {
                cell = self.defaultCells[0];
            }
            
        } break;
        case 2: {
            cell = self.defaultCells[indexPath.row - offset];
        } break;
        case 3: {
            cell = self.defaultCells[indexPath.row - offset];
            
        } break;
        case 4: {
            cell = self.defaultCells[indexPath.row - offset];
            
        } break;
    }
    
    return cell;
}

#pragma mark - RCConversationSettingTableViewHeader Delegate
//点击最后一个+号事件
- (void)settingTableViewHeader:
(RCConversationSettingTableViewHeader *)settingTableViewHeader
       indexPathOfSelectedItem:(NSIndexPath *)indexPathOfSelectedItem
            allTheSeletedUsers:(NSArray *)users {
    NSLog(@"--- %ld",indexPathOfSelectedItem.row);
    //    点击最后一个+号,调出选择联系人UI
    if (indexPathOfSelectedItem.row == settingTableViewHeader.users.count) {
        SelectColleaguesTableViewController *contactSelectedVC= [[SelectColleaguesTableViewController alloc]init];
        contactSelectedVC.addDiscussionGroupMembers = _userList;
        contactSelectedVC.discussionId = self.targetId;
        
        [self.navigationController pushViewController:contactSelectedVC
                                             animated:YES];
    }
}

#pragma mark - private method
- (void)refreshHeaderView:(NSNotification *)notification {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSMutableArray *members = notification.object;
        [_userList addObjectsFromArray:members];
        [self addUsers:_userList];
    });
}

- (void)createDiscussionOrInvokeMemberWithSelectedUsers:
(NSArray *)selectedUsers {
    //    __weak RCDSettingViewController *weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        if (ConversationType_DISCUSSION == self.conversationType) {
            // invoke new member to current discussion
            
            NSMutableArray *addIdList = [NSMutableArray new];
            for (RCUserInfo *user in selectedUsers) {
                [addIdList addObject:user.userId];
            }
            
            //加入讨论组
            if (addIdList.count != 0) {
                
                [[RCIM sharedRCIM] addMemberToDiscussion:self.targetId
                                              userIdList:addIdList
                                                 success:^(RCDiscussion *discussion) {
                                                     NSLog(@"成功");
                                                 }
                                                   error:^(RCErrorCode status){
                                                   }];
            }
            
        } else if (ConversationType_PRIVATE == self.conversationType) {
            // create new discussion with the new invoked member.
            NSUInteger _count = [_members.allKeys count];
            if (_count > 1) {
                
                NSMutableString *discussionTitle = [NSMutableString string];
                NSMutableArray *userIdList = [NSMutableArray new];
                for (int i = 0; i < _count; i++) {
                    RCUserInfo *_userInfo = (RCUserInfo *)_members.allValues[i];
                    [discussionTitle
                     appendString:[NSString
                                   stringWithFormat:@"%@%@", _userInfo.name, @","]];
                    
                    [userIdList addObject:_userInfo.userId];
                }
                [discussionTitle
                 deleteCharactersInRange:NSMakeRange(discussionTitle.length - 1, 1)];
                self.conversationTitle = discussionTitle;
                
                __weak typeof(&*self) weakSelf = self;
                [[RCIM sharedRCIM] createDiscussion:discussionTitle
                                         userIdList:userIdList
                                            success:^(RCDiscussion *discussion) {
                                                
                                                
                                            }
                                              error:^(RCErrorCode status){
                                              }];
            }
        }
    });
}

- (void)openMemberInv:(UISwitch *)swch {
    //设置成员邀请权限
    
    [[RCIM sharedRCIM] setDiscussionInviteStatus:self.targetId
                                          isOpen:swch.on
                                         success:^{
                                             //        DebugLog(@"设置成功");
                                         }
                                           error:^(RCErrorCode status){
                                               
                                           }];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    if (self.setDiscussTitleCompletion) {
        self.setDiscussTitleCompletion(_discussTitle);
    }
}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        ODiscussSettingCell *discussCell =
        (ODiscussSettingCell *)[tableView cellForRowAtIndexPath:indexPath];
        discussCell.lblTitle.text = @"讨论组名称";
    }
}

/**
 *  override
 *
 *  @param 添加顶部视图显示的user,必须继承以调用父类添加user
 */
- (void)addUsers:(NSArray *)users {
    [super addUsers:users];
}

/**
 *  override 左上角删除按钮回调
 *
 *  @param indexPath indexPath description
 */
- (void)deleteTipButtonClicked:(NSIndexPath *)indexPath {
    OrgUserInfo *user = self.users[indexPath.row];
    NSString *userId = [NSString stringWithFormat:@"in_%ld_%ld",[Config getDbID],user.id];
    if ([userId isEqualToString:[RCIMClient sharedRCIMClient]
         .currentUserInfo.userId]) {
        return;
    }
    [[RCIM sharedRCIM] removeMemberFromDiscussion:self.targetId
                                           userId:userId
                                          success:^(RCDiscussion *discussion) {
                                              NSLog(@"踢人成功");
                                              [_userList removeObject:user];
                                              [self.users removeObject:user];
                                              [self.members removeObjectForKey:[NSString stringWithFormat:@"%ld",user.id]];
                                              [self addUsers:self.users];
                                          }
                                            error:^(RCErrorCode status) {
                                                NSLog(@"踢人失败");
                                            }];
}

- (void)didTipHeaderClicked:(NSString *)userId {
    if (_isClick) {
        _isClick = NO;
    }
}

@end
