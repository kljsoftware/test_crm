//
//  ODiscussGroupSettingViewController.h
//  sales
//
//  Created by user on 2016/12/27.
//  Copyright © 2016年 rayootech. All rights reserved.
//

#import "OSettingBaseViewController.h"

typedef void (^setDiscussTitle)(NSString *discussTitle);

@interface ODiscussGroupSettingViewController : OSettingBaseViewController

//设置讨论组名称后，回传值
@property(nonatomic, copy) setDiscussTitle setDiscussTitleCompletion;

@property(nonatomic, copy) NSString *conversationTitle;

@end
