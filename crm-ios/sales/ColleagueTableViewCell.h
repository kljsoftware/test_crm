//
//  ColleagueTableViewCell.h
//  sales
//
//  Created by user on 2017/1/10.
//  Copyright © 2017年 rayootech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrgUserInfo.h"

@interface ColleagueTableViewCell : UITableViewCell

@property (nonatomic,strong) OrgUserInfo *model;

+ (CGFloat)fixedHeight;

@end
