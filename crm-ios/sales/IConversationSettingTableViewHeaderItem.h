//
//  IConversationSettingTableViewHeaderItem.h
//  sales
//
//  Created by user on 2017/3/2.
//  Copyright © 2017年 rayootech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrgUserInfo.h"
@protocol IConversationSettingTableViewHeaderItemDelegate;
@interface IConversationSettingTableViewHeaderItem : UICollectionViewCell
@property(nonatomic, strong) UIImageView *ivAva;
@property(nonatomic, strong) UILabel *titleLabel;
@property(nonatomic, strong) UIButton *btnImg;
@property(nonatomic, copy) NSString *userId;
@property(nonatomic, weak) id<IConversationSettingTableViewHeaderItemDelegate>
delegate;

- (void)setUserModel:(OrgUserInfo *)userModel;
@end

@protocol IConversationSettingTableViewHeaderItemDelegate <NSObject>

- (void)deleteTipButtonClicked:
(IConversationSettingTableViewHeaderItem *)item;
@end
