//
//  SetLeaderTableViewController.h
//  sales
//
//  Created by user on 2017/4/20.
//  Copyright © 2017年 rayootech. All rights reserved.
//

#import "BaseTableViewController.h"

@protocol SetLeaderDelegate <NSObject>

-(void) setLeader:(NSString *)name;

@end

@interface SetLeaderTableViewController : BaseTableViewController

@property (nonatomic,assign) id <SetLeaderDelegate> delegate;

@end
