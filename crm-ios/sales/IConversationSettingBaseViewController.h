//
//  IConversationSettingBaseViewController.h
//  sales
//
//  Created by user on 2017/3/2.
//  Copyright © 2017年 rayootech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IConversationSettingTableViewHeader.h"
@interface IConversationSettingBaseViewController : UITableViewController
/**
 *  内置置顶聊天，新消息通知，清除消息记录三个cell
 */
@property(nonatomic, strong, readonly) NSArray *defaultCells;

/**
 *  是否隐藏顶部视图
 */
@property(nonatomic, assign) BOOL headerHidden;

/**
 *  设置top switch
 */
@property(nonatomic, assign) BOOL switch_isTop;

/**
 *  新消息通知switchs
 */
@property(nonatomic, assign) BOOL switch_newMessageNotify;

/**
 *  设置顶部视图显示的users
 */
@property(nonatomic, strong) NSMutableArray *users;

/**
 *  禁用删除成员事件
 *
 *  @param disable disable description
 */
- (void)disableDeleteMemberEvent:(BOOL)disable;

/**
 *  禁用邀请成员事件
 *
 *  @param disable disable description
 */
- (void)disableInviteMemberEvent:(BOOL)disable;
/**
 *  重写以下方法，自定义点击事件
 *
 */

/**
 *  置顶聊天
 *
 *  @param sender sender description
 */
- (void)onClickIsTopSwitch:(id)sender;

/**
 *  新消息通知
 *
 *  @param sender sender description
 */
- (void)onClickNewMessageNotificationSwitch:(id)sender;

/**
 *  清除聊天记录
 *
 *  @param sender sender description
 */
- (void)onClickClearMessageHistory:(id)sender;

/**
 *  添加users到顶部视图
 *
 *  @param users users description
 */
- (void)addUsers:(NSArray *)users;

/**
 *  重写以下两个方法以实现顶部视图item点击事件
 *
 *  @param settingTableViewHeader  settingTableViewHeader description
 *  @param indexPathOfSelectedItem indexPathOfSelectedItem description
 *  @param users                   users description
 */
- (void)settingTableViewHeader:
(IConversationSettingTableViewHeader *)settingTableViewHeader
       indexPathOfSelectedItem:(NSIndexPath *)indexPathOfSelectedItem
            allTheSeletedUsers:(NSArray *)users;

/**
 *  点击删除图标事件
 *
 *  @param indexPath indexPath description
 */
- (void)deleteTipButtonClicked:(NSIndexPath *)indexPath;

/**
 *  点击上面头像列表的头像
 *
 *  @param userId 用户id
 */
- (void)didTipHeaderClicked:(NSString *)userId;

@end
