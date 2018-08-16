//
//  SelectColleauesTableViewCell.h
//  sales
//
//  Created by user on 2017/3/2.
//  Copyright © 2017年 rayootech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrgUserInfo.h"
@interface SelectColleauesTableViewCell : UITableViewCell

@property (nonatomic,strong) OrgUserInfo *model;

+ (CGFloat)fixedHeight;

@end
