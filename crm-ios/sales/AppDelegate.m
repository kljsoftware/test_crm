//
//  AppDelegate.m
//  sales
//
//  Created by user on 2016/11/3.
//  Copyright © 2016年 rayootech. All rights reserved.
//

#import "SalesDbUtil.h"
#import "UMessage.h"
#import "Contact.h"
#import "ReqFriendDbUtil.h"
#import <UserNotifications/UserNotifications.h>
#import "LoginViewController.h"
#import "IMainTabBarController.h"
#import "OMainTabBarController.h"
#import "OrgUserInfoDbUtil.h"
#import "OrgInvite.h"

@interface AppDelegate () <UNUserNotificationCenterDelegate>
@property (nonatomic,strong) SalesDbUtil *dbUtil;
@property (nonatomic,strong) OrgUserInfoDbUtil * orgDbUtil;
@property (nonatomic,strong) OrgInvite  *orgInvite;
@property (nonatomic,strong) PreferUtil *preferUtil;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [IQKeyboardManager sharedManager].enableAutoToolbar = false;
    
    int64_t userID = [Config getOwnID];
    NSDictionary *navbarTitleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor]};
    [[UINavigationBar appearance] setTitleTextAttributes:navbarTitleTextAttributes];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithHex:0x1F5AF8]];
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHex:0x1F5AF8]} forState:UIControlStateSelected];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    if (userID > 0) {
        self.window.rootViewController = [self.window.rootViewController.storyboard instantiateViewControllerWithIdentifier:@"OMainIdentifier"];
    } else {
        [self showWindowLogin:@"logout"];
    }
    
    [[RCIM sharedRCIM] initWithAppKey:@"8luwapkv8rcpl"];
    [[RCIM sharedRCIM] setUserInfoDataSource:self];
    
    [RCIM sharedRCIM].showUnkownMessage = YES;
    [RCIM sharedRCIM].showUnkownMessageNotificaiton = YES;
    
    [UMessage startWithAppkey:@"58bf7857734be463ea001f83" launchOptions:launchOptions httpsEnable:YES];
    [UMessage registerForRemoteNotifications];
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    center.delegate = self;
    
    UNAuthorizationOptions types10 = UNAuthorizationOptionBadge | UNAuthorizationOptionAlert | UNAuthorizationOptionSound;
    
    [center requestAuthorizationWithOptions:types10 completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if (granted) {
            
        }else{
        
        }
    }];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application {

}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    
}

- (void)applicationWillTerminate:(UIApplication *)application {
    
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(nonnull NSData *)deviceToken{
    NSLog(@"devicetoken -- %@",[[[[deviceToken description] stringByReplacingOccurrencesOfString: @"<" withString: @""]
                  stringByReplacingOccurrencesOfString: @">" withString: @""]
                 stringByReplacingOccurrencesOfString: @" " withString: @""]);
}

//ios 10 以下使用这个方法接受通知
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(nonnull NSDictionary *)userInfo{
    [UMessage setAutoAlert:NO];
    [UMessage didReceiveRemoteNotification:userInfo];
    NSLog(@"push -----  didReceiveRemoteNotification");
}

//iOS10新增：处理前台收到通知的代理方法
-(void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler{
    NSDictionary * userInfo = notification.request.content.userInfo;
    NSLog(@"push -----  willPresentNotification");
    NSLog(@"type --- %@",userInfo[@"type"]);
    NSString *type = userInfo[@"type"];
    if ([type isEqualToString:@"add"]) {
        Contact *contact = [Contact mj_objectWithKeyValues:userInfo[@"data"]];
        contact.recevied = 0;
        [self dealReqFriend:contact];
    }else if([type isEqualToString:@"opost"]){
        NSNotification *notice = [NSNotification notificationWithName:@"updateUnreadCircle" object:nil];
        [[NSNotificationCenter defaultCenter]postNotification:notice];
    }else if([type isEqualToString:@"invite"]){
        if (_orgInvite == nil) {
            _orgInvite = [OrgInvite new];
        }
        _orgInvite.orgname = userInfo[@"orgname"];
        _orgInvite.dbid = userInfo[@"dbid"];
        _orgInvite.inviter = userInfo[@"inviter"];
        _orgInvite.recevied = @"0";
        [self dealOrgInvite:_orgInvite];
    }else if([type isEqualToString:@"workinfo"]){
        NSNotification *notice = [NSNotification notificationWithName:@"updateUnreadWork" object:nil];
        [[NSNotificationCenter defaultCenter]postNotification:notice];
    }
    
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        //应用处于前台时的远程推送接受
        //关闭友盟自带的弹出框
        [UMessage setAutoAlert:NO];
        //必须加这句代码
        [UMessage didReceiveRemoteNotification:userInfo];
        
    }else{
        //应用处于前台时的本地推送接受
    }
    //当应用处于前台时提示设置，需要哪个可以设置哪一个
    completionHandler(UNNotificationPresentationOptionSound|UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionAlert);
}

//iOS10新增：处理后台点击通知的代理方法
-(void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler{
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        //应用处于后台时的远程推送接受
        //必须加这句代码
        [UMessage didReceiveRemoteNotification:userInfo];
        
    }else{
        //应用处于后台时的本地推送接受
    }
    
}
- (void)getUserInfoWithUserId:(NSString *)userId completion:(void (^)(RCUserInfo *))completion{
    Contact *contact;
    OrgUserInfo *orgUserInfo;
    RCUserInfo *user = [[RCUserInfo alloc]init];
    UIImageView *image = [UIImageView new];
    NSLog(@"USERID--%@",userId);
    if ([userId rangeOfString:@"out_"].location != NSNotFound) {
        if (_dbUtil == nil) {
            _dbUtil = [[SalesDbUtil alloc] init];
        }
        userId = [userId substringFromIndex:4];
        NSInteger fid = [userId integerValue];
        NSString *myId = [NSString stringWithFormat:@"%lld",[Config getOwnID]];
        contact = [_dbUtil selectUserById:fid];
        if (contact.fid != 0) {
            user.userId = [NSString stringWithFormat:@"out_%ld",contact.fid];
            user.name = contact.name;
            user.portraitUri = [image rongPortrait:contact.avatar];
        }else if([userId isEqualToString:myId]){
            user.userId = [NSString stringWithFormat:@"out_%@",myId];
            user.name = [Config getUser].name;
            user.portraitUri = [image rongPortrait:[Config getUser].avatar];
        }else{
            user = nil;
            NSNotification *notice = [NSNotification notificationWithName:@"updateContact" object:nil];
            [[NSNotificationCenter defaultCenter]postNotification:notice];
        }
    }else if([userId rangeOfString:@"in_"].location != NSNotFound){
        if (_orgDbUtil == nil) {
            _orgDbUtil = [[OrgUserInfoDbUtil alloc] init];
        }
        NSString *temp = userId;
        NSArray *array = [userId componentsSeparatedByString:@"_"];
        userId = [array objectAtIndex:2];
        NSInteger fid = [userId integerValue];
        orgUserInfo = [_orgDbUtil selectOrgUserById:fid];
        NSString *myId = [NSString stringWithFormat:@"%ld",[Config getOrgUserID]];
        if (orgUserInfo.id != 0) {
            user.userId = temp;
            user.name = orgUserInfo.name;
            user.portraitUri = [image rongPortrait:orgUserInfo.avatar];
        }else if([userId isEqualToString:myId]){
            NSString *dbid = [NSString stringWithFormat:@"%ld",[Config getDbID]];
            userId = [NSString stringWithFormat:@"in_%@_%@",dbid,myId];
            user.userId = userId;
            user.name = [Config getOrgUser].name;
            user.portraitUri = [image rongPortrait:[Config getOrgUser].avatar];
        }else{
            user = nil;
        }
    }
    
    
    return completion(user);
}

- (void)showWindowLogin:(NSString *)windowType {
    if ([windowType isEqualToString:@"logout"]) {
        LoginViewController *loginVC = [self.window.rootViewController.storyboard instantiateViewControllerWithIdentifier:@"LoginIdentifier"];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:loginVC];
        self.window.rootViewController = nav;
    }
}
- (void)showWindow:(NSString *)windowType showOrgList:(BOOL)showOrgList {
    if ([windowType isEqualToString:@"organization"]) {
        IMainTabBarController *vc = [[IMainTabBarController alloc]init];
        self.window.rootViewController = vc;
        
    }else if([windowType isEqualToString:@"omain"]) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        OMainTabBarController *tabBar = [storyboard instantiateViewControllerWithIdentifier:@"OMainIdentifier"];
        self.window.rootViewController = tabBar;
        if (showOrgList) {
            tabBar.selectedIndex = 3;
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^(void) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"kShowOrgListNoti" object:nil];
            });
        }
    }
}

- (void)dealReqFriend:(Contact *)contact{
    ReqFriendDbUtil *reqDb = [[ReqFriendDbUtil alloc] init];
    Contact *result = [reqDb selectUserById:contact.id];
    if (result.id == 0) {
        [reqDb insertContact:contact];
        if (_preferUtil == nil) {
            _preferUtil = [PreferUtil new];
        }
        [_preferUtil initOUT];
        [_preferUtil setInt:NewFriendReq data:1];
        NSNotification *notice = [NSNotification notificationWithName:@"newFriendReq" object:nil];
        [[NSNotificationCenter defaultCenter]postNotification:notice];
    }
}

- (void)dealOrgInvite:(OrgInvite *)invite{
    NSMutableArray *local = [FileUtils readDataFromFile:OrgInviteList];
    if (local == nil) {
        local = [NSMutableArray new];
    }
    for(int i = 0; i < local.count;i++){
        OrgInvite *temp = local[i];
        if ([temp.dbid isEqualToString:invite.dbid]) {
            return;
        }
    }
    if (_preferUtil == nil) {
        _preferUtil = [PreferUtil new];
    }
    [_preferUtil initOUT];
    
    NSInteger count = [_preferUtil getInt:OrgInviteCount];
    count++;
    [_preferUtil setInt:OrgInviteCount data:count];
    [local addObject:invite];
    [FileUtils saveDataToFile:OrgInviteList data:local];
}

@end
