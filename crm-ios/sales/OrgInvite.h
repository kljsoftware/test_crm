//
//  OrgInvite.h
//  sales
//
//  Created by user on 2017/3/16.
//  Copyright © 2017年 rayootech. All rights reserved.
//

#import "BaseModel.h"

@interface OrgInvite : BaseModel <NSCoding>

@property (nonatomic,strong) NSString *inviter;

@property (nonatomic,strong) NSString *dbid;

@property (nonatomic,strong) NSString *orgname;

@property (nonatomic,strong) NSString *recevied;

@end
