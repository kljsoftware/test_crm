//
//  OrganizationTableViewCell.h
//  sales
//
//  Created by user on 2016/12/30.
//  Copyright © 2016年 rayootech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Organizations.h"

@interface OrganizationTableViewCell : UITableViewCell

@property (nonatomic,strong) Organizations *model;

+ (CGFloat)fixedHeight;

@end
