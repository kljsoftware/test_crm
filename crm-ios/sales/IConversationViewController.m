//
//  IConversationViewController.m
//  sales
//
//  Created by user on 2017/3/2.
//  Copyright © 2017年 rayootech. All rights reserved.
//

#import "IConversationViewController.h"
#import "IDiscussGroupSettingViewController.h"
@interface IConversationViewController ()

@end

@implementation IConversationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"common_btn_back"] style:UIBarButtonItemStylePlain target:self action:@selector(backButtonClicked)];    
    if (self.conversationType == ConversationType_DISCUSSION) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(discussionSetting)];
    }
    [self.chatSessionInputBarControl.pluginBoardView removeItemWithTag:1003];
    [[RCIM sharedRCIM] setGlobalConversationAvatarStyle:RC_USER_AVATAR_CYCLE];
}
- (void)viewWillDisappear:(BOOL)animated {
    [[RCIMClient sharedRCIMClient] clearMessagesUnreadStatus:self.conversationType targetId:self.targetId];
    NSNotification *notice = [NSNotification notificationWithName:@"updateUnreadCount" object:nil userInfo:nil];
    [[NSNotificationCenter defaultCenter]postNotification:notice]; //
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)displayUserNameInCell{
    if (self.conversationType == ConversationType_DISCUSSION) {
        return YES;
    }
    return NO;
}

- (void)discussionSetting {
    IDiscussGroupSettingViewController *settingVC =
    [[IDiscussGroupSettingViewController alloc] init];
    settingVC.conversationType = self.conversationType;
    settingVC.targetId = self.targetId;
    settingVC.discussTitle = self.title;
    //设置讨论组标题时，改变当前聊天界面的标题
    settingVC.setDiscussTitleCompletion = ^(NSString *discussTitle) {
        [[RCIMClient sharedRCIMClient] setDiscussionName:self.targetId name:discussTitle success:^{
            self.title = discussTitle;
        } error:nil];
    };
    [self.navigationController pushViewController:settingVC animated:YES];
}

- (void)pluginBoardView:(RCPluginBoardView *)pluginBoardView
     clickedItemWithTag:(NSInteger)tag {
    switch (tag) {
        case 1010: {
            
            NSLog(@"LOCATION");
        } break;
        default:
            [super pluginBoardView:pluginBoardView clickedItemWithTag:tag];
            break;
    }
}

- (void)backButtonClicked {
    [self.navigationController popViewControllerAnimated:true];
}

@end
