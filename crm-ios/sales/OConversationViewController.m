//
//  OConversationViewController.m
//  sales
//
//  Created by user on 2016/12/1.
//  Copyright © 2016年 rayootech. All rights reserved.
//

#import "OConversationViewController.h"
#import "ODiscussGroupSettingViewController.h"
@interface OConversationViewController ()

@end

@implementation OConversationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"common_btn_back"] style:UIBarButtonItemStylePlain target:self action:@selector(cancelButtonClicked)];

    if (self.conversationType == ConversationType_DISCUSSION) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(discussionSetting)];
    }
    [self.chatSessionInputBarControl.pluginBoardView removeItemWithTag:1003];
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

- (void)discussionSetting{
    ODiscussGroupSettingViewController *settingVC =
    [[ODiscussGroupSettingViewController alloc] init];
    settingVC.conversationType = self.conversationType;
    settingVC.targetId = self.targetId;
    settingVC.conversationTitle = self.title;
    //设置讨论组标题时，改变当前聊天界面的标题
    settingVC.setDiscussTitleCompletion = ^(NSString *discussTitle) {
        self.title = discussTitle;
    };
    //清除聊天记录之后reload data
    __weak OConversationViewController *weakSelf = self;
    settingVC.clearHistoryCompletion = ^(BOOL isSuccess) {
        if (isSuccess) {
            [weakSelf.conversationDataRepository removeAllObjects];
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.conversationMessageCollectionView reloadData];
            });
        }
    };
    
    [self.navigationController pushViewController:settingVC animated:YES];
}

- (BOOL)displayUserNameInCell{
    if (self.conversationType == ConversationType_DISCUSSION) {
        return YES;
    }
    return NO;
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

- (void)cancelButtonClicked {
    [self.navigationController popViewControllerAnimated:true];
}

@end
