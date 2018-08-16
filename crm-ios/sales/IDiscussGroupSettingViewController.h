//
//  IDiscussGroupSettingViewController.h
//  sales
//
//  Created by user on 2017/3/2.
//  Copyright © 2017年 rayootech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ISettingBaseViewController.h"

typedef void (^setDiscussTitle)(NSString *discussTitle);
@interface IDiscussGroupSettingViewController : ISettingBaseViewController

//设置讨论组名称后，回传值
@property(nonatomic, copy) setDiscussTitle setDiscussTitleCompletion;

@property(nonatomic, copy) NSString *conversationTitle;

@end
