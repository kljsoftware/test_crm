//
//  CircleDetailsTableViewCell.h
//  sales
//
//  Created by user on 2016/11/17.
//  Copyright © 2016年 rayootech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Comment.h"

@interface CircleDetailsTableViewCell : UITableViewCell

@property (nonatomic,strong) Comment *model;

@property (nonatomic,strong) NSIndexPath *indexPath;

@property (nonatomic,assign) BOOL unread;

@property (nonatomic,assign) NSInteger type;    // 1 circle 2 blackboard

@end
