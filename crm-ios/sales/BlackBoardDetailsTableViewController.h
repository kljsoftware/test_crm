//
//  BlackBoardDetailsTableViewController.h
//  sales
//
//  Created by user on 2017/2/15.
//  Copyright © 2017年 rayootech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BlackBoard.h"
@interface BlackBoardDetailsTableViewController : UITableViewController

@property (nonatomic, strong) BlackBoard *blackBoard;
@property (nonatomic,strong) NSMutableArray *dataModels;
@property (nonatomic, copy) void (^didBlackBoardCommentSelected)(Comment *comment);
@property (nonatomic, copy) void (^didScroll)();
@property (nonatomic, copy) void (^didActivatedInputBar)();
@property (nonatomic, copy) void (^refreshContent)();
- (void)reloadCommentList;

@end
