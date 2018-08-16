//
//  WorkDetailsTableViewController.h
//  sales
//
//  Created by user on 2017/4/11.
//  Copyright © 2017年 rayootech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Work.h"
#import "Comment.h"
@interface WorkDetailsTableViewController : UITableViewController

@property (nonatomic, strong) Work *work;
@property (nonatomic,strong) NSMutableArray *dataModels;
@property (nonatomic, copy) void (^didWorkCommentSelected)(Comment *comment);
@property (nonatomic, copy) void (^didScroll)();
@property (nonatomic, copy) void (^didActivatedInputBar)();
@property (nonatomic, copy) void (^refreshContent)();
- (void)reloadCommentList;
@end
