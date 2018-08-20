//
//  OrganizationTableViewCell.m
//  sales
//
//  Created by Sunny on 2018/8/20.
//  Copyright © 2018年 rayootech. All rights reserved.
//

#import "OrganizationTableViewCell.h"

@implementation OrganizationTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.headerImgView.layer.cornerRadius = 18;
    self.headerImgView.layer.masksToBounds = true;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
