//
//  FriendTableViewCell.h
//  sales
//
//  Created by user on 2016/12/21.
//  Copyright © 2016年 rayootech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Contact.h"
@interface FriendTableViewCell : UITableViewCell

@property (nonatomic,strong) Contact *model;

+ (CGFloat)fixedHeight;
@end
