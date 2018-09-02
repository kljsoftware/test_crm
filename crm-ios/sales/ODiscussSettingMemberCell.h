//
//  ODiscussSettingMemberCell.h
//  sales
//
//  Created by Sunny on 2018/8/30.
//  Copyright © 2018年 rayootech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ODiscussSettingMemberCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *portraitImgView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

- (void)refreshData:(OrgUserInfo *)userInfo;

@end
