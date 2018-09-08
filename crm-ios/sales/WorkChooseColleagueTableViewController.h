//
//  WorkChooseColleagueTableViewController.h
//  sales
//
//  Created by user on 2017/4/7.
//  Copyright © 2017年 rayootech. All rights reserved.
//

#import "BaseTableViewController.h"

@protocol WorkChooseColleaguesCellDelegate <NSObject>

-(void) finialColleaguesIds:(NSString *)customerids;

@end

@interface WorkChooseColleagueTableViewController : BaseTableViewController

@property (nonatomic,assign) id <WorkChooseColleaguesCellDelegate> delegate;

@end
