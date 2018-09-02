//
//  ODiscussSettingSwitchCell.h
//  sales
//
//  Created by Sunny on 2018/8/26.
//  Copyright © 2018年 rayootech. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SwitchCellBlock)(NSIndexPath *indexPath, BOOL on);

@interface ODiscussSettingSwitchCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UISwitch *rightSwitch;
@property (nonatomic, strong) NSIndexPath *indexPath;

@property (nonatomic, copy) SwitchCellBlock block;

@end
