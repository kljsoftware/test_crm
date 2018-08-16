//
//  WorkChooseColleagueTableViewController.h
//  sales
//
//  Created by user on 2017/4/7.
//  Copyright © 2017年 rayootech. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WorkChooseColleaguesCellDelegate <NSObject>

-(void) finialColleaguesIds:(NSString *)customerids;

@end

@interface WorkChooseColleagueTableViewController : UITableViewController

@property (nonatomic,assign) id <WorkChooseColleaguesCellDelegate> delegate;

@end
