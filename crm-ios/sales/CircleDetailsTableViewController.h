//
//  CircleDetailsTableViewController.h
//  sales
//
//  Created by user on 2016/11/17.
//  Copyright © 2016年 rayootech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Circle.h"
#import "Comment.h"
@interface CircleDetailsTableViewController : UITableViewController

@property (nonatomic, strong) Circle *circle;
@property (nonatomic,strong) NSMutableArray *dataModels;
@property (nonatomic, copy) void (^didCircleCommentSelected)(Comment *comment);
@property (nonatomic, copy) void (^didScroll)();
@property (nonatomic, copy) void (^didActivatedInputBar)();
@property (nonatomic, copy) void (^refreshContent)();
- (void)reloadCommentList;
@end
