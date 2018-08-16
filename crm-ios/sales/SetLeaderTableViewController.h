//
//  SetLeaderTableViewController.h
//  sales
//
//  Created by user on 2017/4/20.
//  Copyright © 2017年 rayootech. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SetLeaderDelegate <NSObject>

-(void) setLeader:(NSString *)name;

@end

@interface SetLeaderTableViewController : UITableViewController

@property (nonatomic,assign) id <SetLeaderDelegate> delegate;

@end
