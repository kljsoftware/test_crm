//
//  ISettingBaseViewController.h
//  sales
//
//  Created by user on 2017/3/2.
//  Copyright © 2017年 rayootech. All rights reserved.
//

#import "IConversationSettingBaseViewController.h"
#import "IConversationSettingTableViewHeader.h"
#import <RongIMKit/RongIMKit.h>
#import <UIKit/UIKit.h>
/**
 *  定义block
 *
 *  @param isSuccess isSuccess description
 */
typedef void(^rcdClearHistory)(BOOL isSuccess);

/**
 *  RCSettingViewController
 */
@interface ISettingBaseViewController
: IConversationSettingBaseViewController

/**
 *  targetId
 */
@property(nonatomic, copy) NSString *targetId;

/**
 *  conversationType
 */
@property(nonatomic, assign) RCConversationType conversationType;

/**
 *  清除历史消息后，会话界面调用roload data
 */
@property(nonatomic, copy) rcdClearHistory clearHistoryCompletion;

/**
 *  UIActionSheet
 */
@property(nonatomic, readonly, strong)
UIActionSheet *clearMsgHistoryActionSheet;

/**
 *  clearHistoryMessage
 */
- (void)clearHistoryMessage;

/**
 *  override 如果显示headerView时，最后一个+号点击事件
 *
 *  @param settingTableViewHeader  settingTableViewHeader description
 *  @param indexPathOfSelectedItem indexPathOfSelectedItem description
 *  @param users                   所有在headerView中的user
 */
- (void)settingTableViewHeader:
(IConversationSettingTableViewHeader *)settingTableViewHeader
       indexPathOfSelectedItem:(NSIndexPath *)indexPathOfSelectedItem
            allTheSeletedUsers:(NSArray *)users;

/**
 *  override 如果显示headerView时，所点击的-号事件
 *
 *  @param indexPath 所点击左上角-号的索引
 */
- (void)deleteTipButtonClicked:(NSIndexPath *)indexPath;

@end
