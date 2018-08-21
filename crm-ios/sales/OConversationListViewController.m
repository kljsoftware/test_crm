//
//  OConversationListViewController.m
//  sales
//
//  Created by user on 2016/11/30.
//  Copyright © 2016年 rayootech. All rights reserved.
//

#import "OConversationListViewController.h"
#import "OConversationViewController.h"
#import "UITabBar+badge.h"
@interface OConversationListViewController ()
@property (nonatomic,strong) UIImageView *unreadImage;
@end

@implementation OConversationListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setDisplayConversationTypes:@[@(ConversationType_PRIVATE),
                                        @(ConversationType_DISCUSSION)]];
    [self updateBadgeValueForTabBarItem];
    
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(updateUnreadCount) name:@"updateUnreadCount" object:nil];
    [center addObserver:self selector:@selector(refreshConversationTableViewIfNeeded) name:@"refreshList" object:nil];
    
    UIView *blackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    blackView.backgroundColor = [UIColor whiteColor];
    self.emptyConversationView = blackView;
    self.conversationListTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //  [self notifyUpdateUnreadMessageCount];
  
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)onSelectedTableRow:(RCConversationModelType)conversationModelType conversationModel:(RCConversationModel *)model atIndexPath:(NSIndexPath *)indexPath{
    OConversationViewController *conversationVC = [[OConversationViewController alloc] init];
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
    [super didReceiveMessageNotification:notification];
}

- (void)notifyUpdateUnreadMessageCount {
    [self updateBadgeValueForTabBarItem];
}

- (void)updateBadgeValueForTabBarItem {
    NSLog(@"userid - %@",[[RCIMClient sharedRCIMClient] currentUserInfo].userId);
    if ([NSThread isMainThread]) {
        
        if ([[[RCIMClient sharedRCIMClient] currentUserInfo].userId containsString:@"in_"]) {
            return;
        }
        if ([NSStringUtils isEmpty:[[RCIMClient sharedRCIMClient] currentUserInfo].userId]) {
            return;
        }
        int count = [[RCIMClient sharedRCIMClient]
                     getUnreadCount:self.displayConversationTypeArray];
        count = [[RCIMClient sharedRCIMClient] getTotalUnreadCount];
        if (count <= 0) {
            self.navigationController.tabBarItem.badgeValue = nil;
            return;
        }
        self.navigationController.tabBarItem.badgeValue = [NSString stringWithFormat:@"%d",count];
        NSLog(@"0000MAIN---%d",count);
    }else{
        if ([[[RCIMClient sharedRCIMClient] currentUserInfo].userId containsString:@"in_"]) {
            return;
        }
        dispatch_sync(dispatch_get_main_queue(), ^{
            int count = [[RCIMClient sharedRCIMClient]
                         getUnreadCount:self.displayConversationTypeArray];
            count = [[RCIMClient sharedRCIMClient] getTotalUnreadCount];
            if (count <= 0) {
                self.navigationController.tabBarItem.badgeValue = nil;
                return ;
            }
            self.navigationController.tabBarItem.badgeValue = [NSString stringWithFormat:@"%d",count];
            NSLog(@"0000---%d",count);
        });
        
    }
    
}

- (void)updateUnreadCount{
    [self updateBadgeValueForTabBarItem];
}
@end
