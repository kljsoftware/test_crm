//
//  CustomerTableViewCell.h
//  sales
//
//  Created by user on 2017/2/15.
//  Copyright © 2017年 rayootech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Customer.h"
@interface CustomerTableViewCell : UITableViewCell

@property (nonatomic,strong) Customer *model;

+ (CGFloat)fixedHeight;

@end
