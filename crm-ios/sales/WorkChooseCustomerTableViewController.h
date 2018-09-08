//
//  WorkChooseCustomerTableViewController.h
//  sales
//
//  Created by user on 2017/4/7.
//  Copyright © 2017年 rayootech. All rights reserved.
//

#import "BaseTableViewController.h"
@protocol WorkChooseCustomerCellDelegate <NSObject>

-(void) finialCustomerId:(NSString *)customerid;

@end

@interface WorkChooseCustomerTableViewController : BaseTableViewController

@property (nonatomic,assign) id <WorkChooseCustomerCellDelegate> delegate;

@end
