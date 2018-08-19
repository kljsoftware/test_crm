//
//  Config.m
//  sales
//
//  Created by user on 2016/11/3.
//  Copyright © 2016年 rayootech. All rights reserved.
//

#import "Config.h"

NSString * const userID = @"id";
NSString * const userName = @"name";
NSString * const userAvatar = @"avatar";
NSString * const userToken = @"token";
NSString * const roToken = @"rotoken";
NSString * const userMobile = @"mobile";
NSString * const userWeiBo = @"weibo";
NSString * const userWeChat = @"wechat";
NSString * const userEmail = @"email";
NSString * const userArea = @"area";
NSString * const userDescription = @"Description";
NSString * const userSex = @"sex";
NSString * const userLinkedin = @"linkedin";

NSString * const orgUserID = @"orgid";
NSString * const orgUserName = @"orgname";
NSString * const orgUserAvatar = @"orgavatar";
NSString * const orgUserToken = @"orgtoken";
NSString * const orgUserMobile = @"orgmobile";
NSString * const orgUserDeptParentid = @"deptparentid";
NSString * const orgUserDeptid = @"deptid";
NSString * const orgUserEmail = @"orgemail";
NSString * const orgUserSex = @"orgsex";
NSString * const orgUserArea = @"orgarea";
NSString * const orgUserWechat = @"orgwechat";
NSString * const orgUserTitle = @"orgtitle";
NSString * const dbID = @"dbid";
NSString * const phoneNumber = @"phoneNumber";
NSString * const password = @"password";

@implementation Config

+ (int64_t)getOwnID
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults integerForKey:userID];
}
+ (void)setOwnID:(NSInteger)Id{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setInteger:Id forKey:userID];
}
+ (NSString *)getToken{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults objectForKey:userToken];
}

+ (NSString *)getRoToken{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults objectForKey:roToken];
}

+ (void)saveProfile:(User *)user
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    [userDefaults setInteger:user.id forKey:userID];
    [userDefaults setObject:user.name forKey:userName];
    [userDefaults setObject:user.avatar forKey:userAvatar];
    [userDefaults setObject:user.token forKey:userToken];
    [userDefaults setObject:user.rotoken forKey:roToken];
    [userDefaults setObject:user.mobile forKey:userMobile];
    [userDefaults setObject:user.Description forKey:userDescription];
    [userDefaults setObject:user.area forKey:userArea];
    [userDefaults setObject:user.weibo forKey:userWeiBo];
    [userDefaults setObject:user.wechat forKey:userWeChat];
    [userDefaults setObject:user.linkedin forKey:userLinkedin];
    [userDefaults setObject:user.sex forKey:userSex];
    [userDefaults setObject:user.email forKey:userEmail];
    [userDefaults synchronize];
}

+ (User *)getUser{
    User *user = [User new];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    user.id = [userDefaults integerForKey:userID];
    user.name = [userDefaults objectForKey:userName];
    user.avatar = [userDefaults objectForKey:userAvatar];
    user.mobile = [userDefaults objectForKey:userMobile];
    user.area = [userDefaults objectForKey:userArea];
    user.Description = [userDefaults objectForKey:userDescription];
    user.weibo = [userDefaults objectForKey:userWeiBo];
    user.wechat = [userDefaults objectForKey:userWeChat];
    user.linkedin = [userDefaults objectForKey:userLinkedin];
    user.email = [userDefaults objectForKey:userEmail];
    user.sex = [userDefaults objectForKey:userSex];
    user.token = [userDefaults objectForKey:userToken];
    user.rotoken = [userDefaults objectForKey:roToken];
    return user;
}

+ (void)saveOrgProfile:(OrgUserInfo *)orguser{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    [userDefaults setInteger:orguser.id forKey:orgUserID];
    [userDefaults setObject:orguser.name forKey:orgUserName];
    [userDefaults setObject:orguser.avatar forKey:orgUserAvatar];
    [userDefaults setObject:orguser.rotoken forKey:orgUserToken];
    [userDefaults setObject:orguser.mobile forKey:orgUserMobile];
    [userDefaults setInteger:orguser.deptparentid forKey:orgUserDeptParentid];
    [userDefaults setInteger:orguser.deptid forKey:orgUserDeptid];
    [userDefaults setObject:orguser.area forKey:orgUserArea];
    [userDefaults setObject:orguser.email forKey:orgUserEmail];
    [userDefaults setObject:orguser.wechat forKey:orgUserWechat];
    [userDefaults setObject:orguser.title forKey:orgUserTitle];
    [userDefaults setInteger:orguser.sex forKey:orgUserSex];
    [userDefaults synchronize];
}
+ (void)saveDbID:(NSInteger)dbid{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setInteger:dbid forKey:dbID];
    [userDefaults synchronize];
}
+ (NSString *)getOrgToken{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults objectForKey:orgUserToken];
}

+ (NSInteger)getDbID{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults integerForKey:dbID];
}

+ (NSInteger)getOrgUserID{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults integerForKey:orgUserID];
}

+ (NSString *)getPassword {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults objectForKey:password];
}

+ (OrgUserInfo *)getOrgUser{
    OrgUserInfo *user = [OrgUserInfo new];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    user.id = [userDefaults integerForKey:orgUserID];
    user.avatar = [userDefaults objectForKey:orgUserAvatar];
    user.mobile = [userDefaults objectForKey:orgUserMobile];
    user.name = [userDefaults objectForKey:orgUserName];
    user.deptid = [userDefaults integerForKey:orgUserDeptid];
    user.deptparentid = [userDefaults integerForKey:orgUserDeptParentid];
    user.area = [userDefaults objectForKey:orgUserArea];
    user.sex = [userDefaults integerForKey:orgUserSex];
    user.email = [userDefaults objectForKey:orgUserEmail];
    user.wechat = [userDefaults objectForKey:orgUserWechat];
    user.title = [userDefaults objectForKey:orgUserTitle];
    return user;
}
@end
