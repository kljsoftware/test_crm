//
//  IDiscussGroupSettingViewController.h
//  sales
//
//  Created by user on 2017/3/2.
//  Copyright © 2017年 rayootech. All rights reserved.
//

#import "BaseTableViewController.h"

typedef void (^SetDiscussTitle)(NSString *discussTitle);

@interface IDiscussGroupSettingViewController : BaseTableViewController

// 设置讨论组名称后，回传值
@property(nonatomic, copy) SetDiscussTitle setDiscussTitleCompletion;

@property(nonatomic, copy) NSString *targetId;
@property(nonatomic, assign) RCConversationType conversationType;
@property(nonatomic, copy) NSString *discussTitle;

@end
