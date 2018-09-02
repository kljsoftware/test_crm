//
//  ODiscussSettingCell.h
//  sales
//
//  Created by Sunny on 2018/8/26.
//  Copyright © 2018年 rayootech. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^TextFieldCellBlock)(NSIndexPath *indexPath, NSString *content);

@interface ODiscussSettingCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITextField *contentTF;
@property (nonatomic, strong) NSIndexPath *indexPath;

@property (nonatomic, copy) TextFieldCellBlock block;

@end
