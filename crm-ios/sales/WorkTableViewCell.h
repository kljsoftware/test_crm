//
//  WorkTableViewCell.h
//  sales
//
//  Created by user on 2017/4/10.
//  Copyright © 2017年 rayootech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Work.h"
@protocol WorkCellDelegate <NSObject>

-(void) workColleagueDidClick:(Work *)work;

@end
@interface WorkTableViewCell : UITableViewCell

@property (nonatomic,strong) Work *model;

@property (nonatomic, strong) NSIndexPath *indexPath;

@property (nonatomic, copy) void (^moreButtonClickedBlock)(NSIndexPath *indexPath);

@property (nonatomic,assign) id <WorkCellDelegate> delegate;

@end
