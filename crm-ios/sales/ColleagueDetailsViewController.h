//
//  ColleagueDetailsViewController.h
//  sales
//
//  Created by user on 2017/2/24.
//  Copyright © 2017年 rayootech. All rights reserved.
//

#import "BaseTableViewController.h"
#import "OrgUserInfo.h"

@interface ColleagueDetailsViewController : BaseTableViewController

@property (nonatomic,strong) OrgUserInfo *orgUserInfo;
@property (nonatomic, assign) BOOL uneditable;


@end
