//
//  ReqFriendTableViewCell.h
//  sales
//
//  Created by user on 2017/3/9.
//  Copyright © 2017年 rayootech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Contact.h"
@protocol ReqFriendCellDelegate <NSObject>

-(void) agreeDidClick:(Contact *)contact index:(NSIndexPath *)indexPath;

@end

@interface ReqFriendTableViewCell : UITableViewCell

@property (nonatomic,strong) Contact *model;

+ (CGFloat)fixedHeight;

@property (nonatomic, strong) NSIndexPath *index;

@property (nonatomic,assign) id <ReqFriendCellDelegate> delegate;
@end
