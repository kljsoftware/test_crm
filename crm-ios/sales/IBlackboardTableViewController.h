//
//  IBlackboardTableViewController.h
//  sales
//
//  Created by user on 2017/1/18.
//  Copyright © 2017年 rayootech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IBlackboardTableViewController : UIViewController

@property (nonatomic,strong) UITableView  *tableView;
@property (nonatomic, copy) void (^didScroll)();
@property (nonatomic, copy) void (^didActivatedInputBar)();
@property (nonatomic, copy) void (^refreshContent)();
@end
