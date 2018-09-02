//
//  ODiscussSettingSwitchCell.m
//  sales
//
//  Created by Sunny on 2018/8/26.
//  Copyright © 2018年 rayootech. All rights reserved.
//

#import "ODiscussSettingSwitchCell.h"

@implementation ODiscussSettingSwitchCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)switchChanged:(UISwitch *)sender {
    if (self.block) {
        self.block(self.indexPath, sender.on);
    }
}

@end
