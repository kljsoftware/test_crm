//
//  DeptTableViewCell.h
//  sales
//
//  Created by user on 2017/4/17.
//  Copyright © 2017年 rayootech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Dept.h"

@interface DeptTableViewCell : UITableViewCell

@property (nonatomic,strong) Dept *model;

@property (nonatomic,assign) NSInteger type;
+ (CGFloat)fixedHeight;

@end
