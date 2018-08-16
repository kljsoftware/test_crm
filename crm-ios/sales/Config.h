//
//  Config.h
//  sales
//
//  Created by user on 2016/11/3.
//  Copyright © 2016年 rayootech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"
#import "OrgUserInfo.h"

@interface Config : NSObject

+ (int64_t)getOwnID;
+ (NSString *)getToken;
+ (NSString *)getRoToken;
+ (void)saveProfile:(User *)user;
+ (User *)getUser;
+ (void)setOwnID:(NSInteger)Id;

+ (void)saveOrgProfile:(OrgUserInfo *)orguser;
+ (void)saveDbID:(NSInteger)dbid;
+ (NSString *)getOrgToken;
+ (NSInteger)getDbID;
+ (NSInteger)getOrgUserID;
+ (OrgUserInfo *)getOrgUser;
@end
