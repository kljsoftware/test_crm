//
//  OMainTabBarController.m
//  sales
//
//  Created by user on 2016/11/3.
//  Copyright © 2016年 rayootech. All rights reserved.
//

#import "OMainTabBarController.h"
#import "OChatListTableViewController.h"
#import "CircleTableViewController.h"
#import "ContactTableViewController.h"
#import "OMeViewController.h"
#import "CirclePublishViewController.h"
#import "Config.h"
#import "SearchContactViewController.h"
#import "OConversationListViewController.h"
#import "AddContactViewController.h"
#import "OSelectFriendsViewController.h"
#import "UMessage.h"
#import <RongIMKit/RongIMKit.h>

#define kClassKey   @"rootVCClassString"
#define kTitleKey   @"title"
#define kImgKey     @"imageName"
#define kSelImgKey  @"selectedImageName"
@interface OMainTabBarController ()
{
    OChatListTableViewController *chatVC;
    CircleTableViewController *circleVC;
    ContactTableViewController *contactVC;
    OMeViewController *meVC;
    OConversationListViewController *conversationVC;
}
@property (nonatomic,strong) UITabBarItem *item;
@end

@implementation OMainTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self connoectRC];
    NSArray *childItemsArray = @[
                                 @{kClassKey  : @"OConversationListViewController",
                                   kTitleKey  : @"消息",
                                   kImgKey    : @"tab_message_nor",
                                   kSelImgKey : @"tab_message_sel"
                                   },
                                 
                                 @{kClassKey  : @"CircleTableViewController",
                                   kTitleKey  : @"圈子",
                                   kImgKey    : @"tab_moments_nor",
                                   kSelImgKey : @"tab_moments_sel"
                                   },
                                 @{kClassKey  : @"ContactTableViewController",
                                   kTitleKey  : @"联系人",
                                   kImgKey    : @"tab_contacts_nor",
                                   kSelImgKey : @"tab_contacts_sel",
                                   },
                                 @{kClassKey  : @"OMeViewController",
                                   kTitleKey  : @"我",
                                   kImgKey    : @"tab_me_nor",
                                   kSelImgKey : @"tab_me_sel",
                                   }
                                 ];
    conversationVC = [[OConversationListViewController alloc] init];
    conversationVC.title = childItemsArray[0][kTitleKey];
    
    
    chatVC = [[OChatListTableViewController alloc] init];
    chatVC.title = childItemsArray[0][kTitleKey];
    circleVC = [[CircleTableViewController alloc] init];
    circleVC.title = childItemsArray[1][kTitleKey];
    contactVC = [[ContactTableViewController alloc] init];
    contactVC.title = childItemsArray[2][kTitleKey];
    meVC = [[OMeViewController alloc] init];
    meVC.title = childItemsArray[3][kTitleKey];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:meVC];
    
    
    self.viewControllers = @[
                             [self addNavigationItemForViewController:conversationVC vcId:0],
                             [self addNavigationItemForViewController:circleVC vcId:1],
                             [self addNavigationItemForViewController:contactVC vcId:2],
                             nav
                             ];
    [self.tabBar.items enumerateObjectsUsingBlock:^(UITabBarItem *item, NSUInteger idx, BOOL *stop) {
        [item setTitle:childItemsArray[idx][kTitleKey]];
        item.image = [[UIImage imageNamed:childItemsArray[idx][kImgKey]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        item.selectedImage = [[UIImage imageNamed:childItemsArray[idx][kSelImgKey]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }];
    _item = [self.tabBar.items objectAtIndex:0];

    NSString *alias = [NSString stringWithFormat:@"%lld",[Config getOwnID]];
    [UMessage addAlias:alias type:@"userId" response:^(id responseObject, NSError *error) {
        NSLog(@"---%@",error);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (UINavigationController *)addNavigationItemForViewController:(UIViewController *)viewController vcId:(NSUInteger) id
{
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
    
//    
    viewController.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                                                     target:self
                                                                                                     action:@selector(pushPublishViewController:)];
    if(id == 2){
        viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(searchUser)];
    }
    [viewController.navigationItem.rightBarButtonItem setTag:id];
    return navigationController;
}
- (void)pushPublishViewController:(id)sender{
    NSInteger i = [sender tag];
    if (i == 1) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"CirclePublishViewController" bundle:nil];
        CirclePublishViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"CirclePublish"];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
        [self.selectedViewController presentViewController:nav animated:YES completion:nil];
    }else if (i == 2){
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Contact" bundle:nil];
        AddContactViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"AddContacts"];
        vc.hidesBottomBarWhenPushed = YES;
        [(UINavigationController *)self.selectedViewController pushViewController:vc animated:YES];
    }else if(i == 0){
        OSelectFriendsViewController *vc = [[OSelectFriendsViewController alloc] init];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
        [self.selectedViewController presentViewController:nav animated:YES completion:nil];
    }
    
    
}
- (void)searchUser{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Contact" bundle:nil];
    SearchContactViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"SearchFriend"];
    vc.hidesBottomBarWhenPushed = YES;
    [(UINavigationController *)self.selectedViewController pushViewController:vc animated:YES];
}
- (void)connoectRC{
    NSString *rotoken = [Config getRoToken];
    [[RCIM sharedRCIM] connectWithToken:rotoken success:^(NSString *userId){
//        NSLog(@"pppp----%@",userId);
        NSNotification *notice = [NSNotification notificationWithName:@"refreshList" object:nil];
        [[NSNotificationCenter defaultCenter]postNotification:notice];
    } error:^(RCConnectErrorCode status) {
        NSLog(@"------>%ld",status);
    } tokenIncorrect:^{
    }];
}

@end
