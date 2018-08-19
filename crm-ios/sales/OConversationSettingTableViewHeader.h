//
//  OConversationSettingTableViewHeader.h
//  sales
//
//  Created by user on 2016/12/27.
//  Copyright © 2016年 rayootech. All rights reserved.
//

#import <UIKit/UIKit.h>
@class OConversationSettingTableViewHeader;

/**
 *  RCConversationSettingTableViewHeaderDelegate
 */
@protocol OConversationSettingTableViewHeaderDelegate <NSObject>

@optional
/**
 *  设置选中item的回调操作
 *
 *  @param settingTableViewHeader   settingTableViewHeader description
 *  @param indexPathForSelectedItem indexPathForSelectedItem description
 *  @param users users description
 */
- (void)settingTableViewHeader:
(OConversationSettingTableViewHeader *)settingTableViewHeader
       indexPathOfSelectedItem:(NSIndexPath *)indexPathOfSelectedItem
            allTheSeletedUsers:(NSArray *)users;

/**
 *  点击删除的回调
 *
 *  @param indexPath 点击索引
 */
- (void)deleteTipButtonClicked:(NSIndexPath *)indexPath;

/**
 *  点击头像的回调
 *
 *  @param userId 用户id
 */
- (void)didTipHeaderClicked:(NSString *)userId;

@end
@interface OConversationSettingTableViewHeader : UICollectionView <UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
/**
 *  showDeleteTip
 */
@property(nonatomic, assign) BOOL showDeleteTip;

/**
 *  isAllowedDeleteMember
 */
@property(nonatomic, assign) BOOL isAllowedDeleteMember;

/**
 *  isAllowedInviteMember
 */
@property(nonatomic, assign) BOOL isAllowedInviteMember;

/**
 *  call back
 */
@property(weak, nonatomic) id<OConversationSettingTableViewHeaderDelegate>
settingTableViewHeaderDelegate;
/**
 *  contains the RCUserInfo
 */
@property(strong, nonatomic) NSMutableArray *users;
@end