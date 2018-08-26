//
//  WorkDetailsTableViewController.h
//  sales
//
//  Created by user on 2017/4/11.
//  Copyright © 2017年 rayootech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Work.h"
@interface WorkDetailsTableViewController : UITableViewController

@property (nonatomic, strong) Work *work;
@property (nonatomic,strong) NSMutableArray *dataModels;
@property (nonatomic, copy) void (^didWorkCommentSelected)(Comment *comment);
@property (nonatomic, copy) void (^didScroll)(void);
@property (nonatomic, copy) void (^didActivatedInputBar)(void);
@property (nonatomic, copy) void (^refreshContent)(void);
- (void)reloadCommentList;
@end
