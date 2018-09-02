//
//  ODiscussSettingMemberCell.m
//  sales
//
//  Created by Sunny on 2018/8/30.
//  Copyright © 2018年 rayootech. All rights reserved.
//

#import "ODiscussSettingMemberCell.h"

@implementation ODiscussSettingMemberCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.portraitImgView.layer.cornerRadius = 5;
    self.portraitImgView.layer.masksToBounds = true;
}

- (void)refreshData:(OrgUserInfo *)userInfo {
    [self.portraitImgView loadPortrait:userInfo.avatar];
    self.nameLabel.text = userInfo.name;
}

@end
