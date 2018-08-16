//
//  WorkChooseCustomerTableViewController.h
//  sales
//
//  Created by user on 2017/4/7.
//  Copyright © 2017年 rayootech. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol WorkChooseCustomerCellDelegate <NSObject>

-(void) finialCustomerId:(NSString *)customerid;

@end

@interface WorkChooseCustomerTableViewController : UITableViewController

@property (nonatomic,assign) id <WorkChooseCustomerCellDelegate> delegate;

@end
