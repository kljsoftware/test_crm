//
//  IMainTabBarController.m
//  sales
//
//  Created by user on 2017/1/3.
//  Copyright © 2017年 rayootech. All rights reserved.
//

#import "IMainTabBarController.h"
#import "PublishBlackBoardViewController.h"
#import "IConversationListViewController.h"
#import "SelectColleaguesTableViewController.h"
#import "ReadViewController.h"
#import "WorkTableViewController.h"
#import "CustomerTableViewController.h"
#import "IMeTableViewController.h"
#import "OMeViewController.h"
#import "AddCustomerViewController.h"
#import "FindCustomerTableViewController.h"
#import "OrgUserInfoDbUtil.h"
#import "OrgUserInfo.h"
#import "PublishNoticeViewController.h"
#import "PublishWorkViewController.h"
@interface IMainTabBarController () <ReadItemDelegate>

{
    IConversationListViewController     *conversationVC;
    ReadViewController         *readVC;
    WorkTableViewController         *workVC;
    CustomerTableViewController     *customerVC;
    IMeTableViewController          *meVC;
    FindCustomerTableViewController *findCustomerVC;
}
@property (nonatomic,strong) OrgUserInfoDbUtil *dbUtil;
@property (nonatomic,strong) PreferUtil *preferUtil;
@end

@implementation IMainTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self connoectRC];
    _preferUtil = [PreferUtil new];
    [_preferUtil initIN];
    NSArray *titles = @[@"消息", @"阅读", @"工作", @"客户", @"我"];
    NSArray *images = @[@"tab_message_nor", @"tab_read_nor", @"tab_work_nor", @"tab_customer_nor", @"tab_me_nor"];
    NSArray *imagesed = @[@"tab_message_sel",@"tab_read_sel",@"tab_work_sel",@"tab_customer_sel",@"tab_me_sel"];
    conversationVC = [[IConversationListViewController alloc] init];
    conversationVC.title = titles[0];
    readVC = [[ReadViewController alloc] init];
    readVC.title = titles[1];
    workVC = [[WorkTableViewController alloc] init];
    workVC.title = titles[2];
    customerVC = [[CustomerTableViewController alloc] init];
    customerVC.title = titles[3];
    findCustomerVC = [[FindCustomerTableViewController alloc] init];
    findCustomerVC.title = titles[3];
    meVC = [[IMeTableViewController alloc] init];
    meVC.title = titles[4];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:meVC];
    UINavigationController *readNav = [[UINavigationController alloc] initWithRootViewController:readVC];
    
    UINavigationController *find = [[UINavigationController alloc] initWithRootViewController:findCustomerVC];
    
    UINavigationController *workNav = [[UINavigationController alloc] initWithRootViewController:workVC];
    
    if ([Config getOrgUserID] == 1) {
        self.viewControllers = @[
                                 [self addNavigationItemForViewController:conversationVC vcId:0],
                                 readNav,
                                 workNav,
                                 find,
                                 nav,
                                 ];
    }else{
        self.viewControllers = @[
                             [self addNavigationItemForViewController:conversationVC vcId:0],
                             readNav,
                             [self addNavigationItemForViewController:workVC vcId:2],
                             [self addNavigationItemForViewController:customerVC vcId:3],
                             nav,
                             ];

    }
    [self.tabBar.items enumerateObjectsUsingBlock:^(UITabBarItem *item, NSUInteger idx, BOOL *stop) {
        [item setTitle:titles[idx]];
        item.image = [[UIImage imageNamed:images[idx]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        item.selectedImage = [[UIImage imageNamed:imagesed[idx]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }];
    [self setSelectedIndex:2];
    _dbUtil = [[OrgUserInfoDbUtil alloc] init];
    readVC.delegate = self;
    [self getColleagueList];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UINavigationController *)addNavigationItemForViewController:(UIViewController *)viewController vcId:(NSUInteger) id
{
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
    viewController.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                                                     target:self
                                                                                                     action:@selector(pushPublishViewController:)];
    [viewController.navigationItem.rightBarButtonItem setTag:id];
    return navigationController;
}
- (void)pushPublishViewController:(id)sender{
    NSInteger i = [sender tag];
    if(i == 3){
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Customer" bundle:nil];
        AddCustomerViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"AddCustomer"];
        vc.hidesBottomBarWhenPushed = YES;
        [(UINavigationController *)self.selectedViewController pushViewController:vc animated:YES];
    }else if (i == 0){
        SelectColleaguesTableViewController *vc = [[SelectColleaguesTableViewController alloc] init];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
        [self.selectedViewController presentViewController:nav animated:YES completion:nil];
    }else if(i == 2){
        [BHBPopView showToView:self.view andImages:@[@"image.bundle/work_meeting",@"image.bundle/work_eat",@"image.bundle/work_message",@"image.bundle/work_text",@"image.bundle/work_contract",@"image.bundle/work_activity"] andTitles:@[@"会议面谈",@"餐饮娱乐",@"通信",@"撰写文本",@"签订合同",@"市场活动"] andSelectBlock:^(BHBItem *item) {
            if (item != nil) {
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Work" bundle:nil];
                PublishWorkViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"PublishWork"];
                if ([item.title isEqualToString:@"会议面谈"]) {
                    vc.worktype = 1;
                }else if([item.title isEqualToString:@"餐饮娱乐"]){
                    vc.worktype = 2;
                }else if([item.title isEqualToString:@"通信"]){
                    vc.worktype = 3;
                }else if([item.title isEqualToString:@"撰写文本"]){
                    vc.worktype = 4;
                }else if([item.title isEqualToString:@"签订合同"]){
                    vc.worktype = 5;
                }else{
                    vc.worktype = 6;
                }
                
                UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
                [self.selectedViewController presentViewController:nav animated:YES completion:nil];
            }
        }];
    }
    
}	
- (void)connoectRC{
    NSString *rotoken = [Config getOrgToken];
    [[RCIM sharedRCIM] connectWithToken:rotoken success:^(NSString *userId){
        NSNotification *notice = [NSNotification notificationWithName:@"refreshOrgList" object:nil];
        [[NSNotificationCenter defaultCenter]postNotification:notice];
    } error:^(RCConnectErrorCode status) {
    } tokenIncorrect:^{
    }];
}
- (void)getColleagueList{
    NSString *userId = [NSString stringWithFormat:@"%ld",[Config getOrgUserID]];
    NSString *dbid = [NSString stringWithFormat:@"%ld",[Config getDbID]];
    NSString *token = [Config getToken];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    
    NSString* urlStr = [NSString stringWithFormat:@"%@%@",BASE_URL,API_COLLEAGUE_LIST];
    NSString *updatetime = [NSString stringWithFormat:@"%ld",[_preferUtil getInt:LastColleagueListUpdate]];
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"POST" URLString:urlStr parameters:@{@"updatetime":updatetime}                                                                                    error:nil];
    [request addValue:userId forHTTPHeaderField:@"userId"];
    [request addValue:token forHTTPHeaderField:@"token"];
    [request addValue:dbid forHTTPHeaderField:@"dbid"];
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id _Nonnull responseObject, NSError *error) {
        if (error) {
//            [self getLocalData];
        } else {
            NSString *responseString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            NSLog(@"DATA-->%@", responseString);
            if (responseObject) {
                NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
                if ([dictionary[@"result"] intValue] == 1) {
                    NSArray* data = dictionary[@"data"];
                    NSArray* modelArray = [OrgUserInfo mj_objectArrayWithKeyValuesArray:data];
                    NSMutableArray *temp;
                    temp = modelArray.mutableCopy;
                    for (OrgUserInfo *model in temp) {
           
                        NSInteger uid = [self.dbUtil selectOrgUserById:model.id].id;
                        if (uid == 0) {
                            [self.dbUtil insertOrgUserInfo:model];
                        }else{
                            [self.dbUtil updateOrgUserInfo:model];
                        }
                        
                    }
                    [self.preferUtil setInt:LastColleagueListUpdate data:[dictionary[@"updatetime"] longValue]];
                }else{
                    
                }
            }else{
                
            }
        }
    }];
    [dataTask resume];
}

- (void)itemChange:(NSInteger)index vc:(UIViewController *)viewController{
    if ([Config getOrgUserID] != 1 && index == 10) {
        viewController.navigationItem.rightBarButtonItem = nil;
        return;
    }
    if (index == 12 || index == 13 || index == 14){
        viewController.navigationItem.rightBarButtonItem = nil;
        return;
    }
    viewController.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                                        target:self
                                                                                                     action:@selector(readPushPublishViewController:)];
    [viewController.navigationItem.rightBarButtonItem setTag:index];
}

- (void)readPushPublishViewController:(id)sender{
    NSInteger i = [sender tag];
    if(i == 10){
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"ReadView" bundle:nil];
        PublishNoticeViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"PublishNotice"];
        vc.hidesBottomBarWhenPushed = YES;
        [(UINavigationController *)self.selectedViewController pushViewController:vc animated:YES];
    }else if (i == 11){
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"ReadView" bundle:nil];
        PublishBlackBoardViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"PublishBlackBoard"];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
        [self.selectedViewController presentViewController:nav animated:YES completion:nil];
    }
}
@end
