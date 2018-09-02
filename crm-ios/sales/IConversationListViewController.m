//
//  IConversationViewController.m
//  sales
//
//  Created by user on 2017/1/3.
//  Copyright © 2017年 rayootech. All rights reserved.
//

#import "IConversationListViewController.h"
#import "IConversationViewController.h"
#import "ServiceNoTableViewController.h"

@interface IConversationListViewController ()

@property (nonatomic,strong) UIView *headerView;
@property (nonatomic,strong) UILabel *serverLabel;
@property (nonatomic,strong) UILabel *countLabel;
@property (nonatomic,strong) UILabel *unreadLabel;
@end

@implementation IConversationListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setDisplayConversationTypes:@[@(ConversationType_PRIVATE),
                                        @(ConversationType_DISCUSSION)]];
    [self updateBadgeValueForTabBarItem];
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(refreshConversationTableViewIfNeeded) name:@"refreshOrgList" object:nil];
    [center addObserver:self selector:@selector(updateUnreadCount) name:@"updateUnreadCount" object:nil];
    UIView *blackView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.height -64)];
    self.emptyConversationView = blackView;
    self.conversationListTableView.tableFooterView = [[UIView alloc] init];
    _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 60)];
    _headerView.backgroundColor = [UIColor whiteColor];
    self.conversationListTableView.tableHeaderView = _headerView;

    WeakSelf;
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"serverno"]];
    [_headerView addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12);
        make.centerY.equalTo(weakSelf.headerView);
        make.width.height.mas_equalTo(44);
    }];
    
    _serverLabel = [[UILabel alloc] init];
    _serverLabel.text = @"服务号";
    _serverLabel.textColor = [UIColor colorWithHex:0x333333];
    _serverLabel.font = [UIFont systemFontOfSize:14];
    [_headerView addSubview:_serverLabel];
    [_serverLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imageView.mas_right).offset(12);
        make.width.height.mas_equalTo(48);
        make.centerY.equalTo(weakSelf.headerView);
    }];
    
    _unreadLabel = [[UILabel alloc] init];
    _unreadLabel.text = @"(3条未读消息)";
    _unreadLabel.textColor = [UIColor darkGrayColor];
    _unreadLabel.font = [UIFont systemFontOfSize:13];
    [_headerView addSubview:_unreadLabel];
    [_unreadLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.serverLabel.mas_right).offset(2);
        make.width.mas_equalTo(120);
        make.centerY.equalTo(weakSelf.headerView);
    }];

    UIView *spliteline = [[UIView alloc] initWithFrame:CGRectMake(10, 62.5, 640, 1.0f/[UIScreen mainScreen].scale)];
    spliteline.backgroundColor = [UIColor lightGrayColor];
    [_headerView addSubview:spliteline];
    
    _countLabel = [[UILabel alloc] initWithFrame:CGRectMake(44, 8, 8, 8)];
    _countLabel.backgroundColor = [UIColor redColor];
    _countLabel.layer.cornerRadius = _countLabel.bounds.size.width/2;
    _countLabel.layer.masksToBounds = YES;
    _countLabel.textColor = [UIColor whiteColor];
    _countLabel.font = [UIFont systemFontOfSize:13];
    _countLabel.textAlignment = NSTextAlignmentCenter;
    _countLabel.text = @"";
    [_headerView addSubview:_countLabel];
    _countLabel.sd_layout.leftSpaceToView(_headerView,44).topSpaceToView(_headerView, 8).widthIs(8).heightIs(8);
    
    UILongPressGestureRecognizer *gesturRecognizer=[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(serviceCell:)];
    gesturRecognizer.minimumPressDuration = 0;
    [_headerView addGestureRecognizer:gesturRecognizer];
    
    self.conversationListTableView.backgroundColor = [UIColor colorWithHex:0xf2f2f2];
    [self.view bringSubviewToFront:self.conversationListTableView];
    [self updateBadgeValueForTabBarItem];
    
    self.conversationListTableView.sd_layout.topSpaceToView(self.view, 60);
    [[RCIM sharedRCIM] setGlobalConversationAvatarStyle:RC_USER_AVATAR_CYCLE];
}

- (NSMutableArray *)willReloadTableData:(NSMutableArray *)dataSource{
    for (int i = 0; i < dataSource.count; i++) {
        RCConversationModel *m = dataSource[i];
        if ([m.targetId isEqualToString:@"out_0"]) {
            [dataSource removeObjectAtIndex:i];
            break;
        }
    }
    return dataSource;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)willDisplayConversationTableCell:(RCConversationBaseCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    RCConversationCell *customCell = (RCConversationCell *)cell;
    customCell.conversationTitle.textColor = [UIColor colorWithHex:0x333333];
    customCell.conversationTitle.font = [UIFont systemFontOfSize:14];
    customCell.messageContentLabel.textColor = [UIColor lightGrayColor];
    customCell.messageContentLabel.font = [UIFont systemFontOfSize:12];
    customCell.messageCreatedTimeLabel.textColor = [UIColor lightGrayColor];
    customCell.messageCreatedTimeLabel.font = [UIFont systemFontOfSize:12];
}

- (void)onSelectedTableRow:(RCConversationModelType)conversationModelType conversationModel:(RCConversationModel *)model atIndexPath:(NSIndexPath *)indexPath {
    IConversationViewController *conversationVC = [[IConversationViewController alloc] init];
    conversationVC.conversationType = model.conversationType;
    conversationVC.targetId = model.targetId;
    conversationVC.displayUserNameInCell = NO;
    conversationVC.title = model.conversationTitle;
    conversationVC.hidesBottomBarWhenPushed = YES;
    [self updateBadgeValueForTabBarItem];
    [self.navigationController pushViewController:conversationVC animated:YES];
}
- (void)didReceiveMessageNotification:(NSNotification *)notification{
    //调用父类刷新未读消息数
    NSLog(@"notification");
    RCMessage *msg = [notification object];
    if ([msg.senderUserId isEqualToString:@"out_0"]) {
        int unread = [[RCIMClient sharedRCIMClient] getUnreadCount:ConversationType_PRIVATE targetId:@"out_0"];
        _countLabel.hidden = NO;
        _unreadLabel.hidden = NO;
        _unreadLabel.text = [NSString stringWithFormat:@"(%d)条未读消息",unread];
        return;
    }else{
        _countLabel.hidden = YES;
        _unreadLabel.hidden = NO;
    }
    [super didReceiveMessageNotification:notification];
}
- (void)refreshConversationTableViewIfNeeded{
    [super refreshConversationTableViewIfNeeded];
}
- (void)serviceCell:(UITapGestureRecognizer *)rec{
    if (rec.state == UIGestureRecognizerStateBegan) {
        _headerView.backgroundColor = [UIColor colorWithHex:0xf2f2f2];
    }else if(rec.state == UIGestureRecognizerStateEnded){
        _headerView.backgroundColor = [UIColor whiteColor];
        ServiceNoTableViewController *conversationVC = [[ServiceNoTableViewController alloc] init];
        conversationVC.hidesBottomBarWhenPushed = YES;
        [[RCIMClient sharedRCIMClient] clearMessagesUnreadStatus:ConversationType_PRIVATE targetId:@"out_0"];
        [self updateBadgeValueForTabBarItem];
        [self.navigationController pushViewController:conversationVC animated:YES];
    }
}

- (void)notifyUpdateUnreadMessageCount {
    [self updateBadgeValueForTabBarItem];
}

- (void)updateBadgeValueForTabBarItem {
    
    if ([NSThread isMainThread]) {
        int unread = [[RCIMClient sharedRCIMClient] getUnreadCount:ConversationType_PRIVATE targetId:@"out_0"];
        if (unread > 0) {
            _countLabel.hidden = NO;
            _unreadLabel.hidden = NO;
            _unreadLabel.text = [NSString stringWithFormat:@"(%d条未读消息)",unread];
        }else{
            _countLabel.hidden = YES;
            _unreadLabel.hidden = YES;
        }
        
        
        int count = [[RCIMClient sharedRCIMClient]
                     getUnreadCount:self.displayConversationTypeArray];
        count = [[RCIMClient sharedRCIMClient] getTotalUnreadCount];
        count = count - unread;
        if (count <= 0) {
            self.navigationController.tabBarItem.badgeValue = nil;
            return;
        }
        self.navigationController.tabBarItem.badgeValue = [NSString stringWithFormat:@"%d",count];
        NSLog(@"0000MAIN---%d",count);
    } else {
        WeakSelf;
        dispatch_sync(dispatch_get_main_queue(), ^{
            int unread = [[RCIMClient sharedRCIMClient] getUnreadCount:ConversationType_PRIVATE targetId:@"out_0"];
            if (unread > 0) {
                weakSelf.countLabel.hidden = NO;
                weakSelf.unreadLabel.hidden = NO;
                weakSelf.unreadLabel.text = [NSString stringWithFormat:@"(%d条未读消息)",unread];
            }else{
                weakSelf.countLabel.hidden = YES;
                weakSelf.unreadLabel.hidden = YES;
            }
            
            int count = [[RCIMClient sharedRCIMClient] getUnreadCount:weakSelf.displayConversationTypeArray];
            count = [[RCIMClient sharedRCIMClient] getTotalUnreadCount];
            count = count - unread;
            if (count <= 0) {
                weakSelf.navigationController.tabBarItem.badgeValue = nil;
                return ;
            }
            weakSelf.navigationController.tabBarItem.badgeValue = [NSString stringWithFormat:@"%d",count];
            NSLog(@"0000---%d",count);
        });
    }
}

- (void)updateUnreadCount{
    [self updateBadgeValueForTabBarItem];
}

@end
