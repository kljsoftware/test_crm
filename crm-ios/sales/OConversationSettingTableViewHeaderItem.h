//
//  OConversationSettingTableViewHeaderItem.h
//  sales
//
//  Created by user on 2016/12/27.
//  Copyright © 2016年 rayootech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Contact.h"
@protocol OConversationSettingTableViewHeaderItemDelegate;
@interface OConversationSettingTableViewHeaderItem : UICollectionViewCell
@property(nonatomic, strong) UIImageView *ivAva;
@property(nonatomic, strong) UILabel *titleLabel;
@property(nonatomic, strong) UIButton *btnImg;
@property(nonatomic, copy) NSString *userId;
@property(nonatomic, weak) id<OConversationSettingTableViewHeaderItemDelegate>
delegate;

- (void)setUserModel:(Contact *)userModel;
@end

@protocol OConversationSettingTableViewHeaderItemDelegate <NSObject>

- (void)deleteTipButtonClicked:
(OConversationSettingTableViewHeaderItem *)item;
@end
