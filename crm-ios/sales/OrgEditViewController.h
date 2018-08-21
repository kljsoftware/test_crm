//
//  OrgEditViewController.h
//  sales
//
//  Created by user on 2017/4/19.
//  Copyright © 2017年 rayootech. All rights reserved.
//

#import "BaseViewController.h"
#import "Organizations.h"

@protocol EditOrgDelegate <NSObject>

-(void) editOrganization:(Organizations *)org;

@end
@interface OrgEditViewController : BaseViewController

@property (nonatomic,strong) Organizations *organizations;

@property (nonatomic,assign) id <EditOrgDelegate> delegate;

@end
