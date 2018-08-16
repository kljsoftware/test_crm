//
//  OrganizationViewController.m
//  sales
//
//  Created by user on 2017/1/3.
//  Copyright © 2017年 rayootech. All rights reserved.
//

#import "OrganizationViewController.h"
#import "IMainTabBarController.h"
#import "OMainTabBarController.h"
#import "AppDelegate.h"
#import "OrgEditViewController.h"
#import "Config.h"
#import "Utils.h"
#import "UIImageView+Util.h"
#import "OrgInviteViewController.h"
#import "SalesApi.h"
#import "OrgUserInfo.h"
#import <AFNetworking.h>
#import <MJExtension.h>
#import <RongIMKit/RongIMKit.h>
@interface OrganizationViewController ()<EditOrgDelegate>

@property (nonatomic,weak) IBOutlet UIButton *loginButton;
@property (nonatomic,weak) IBOutlet UIImageView *logoImage;
@property (nonatomic,weak) IBOutlet UILabel *nameLabel;
@property (nonatomic,weak) IBOutlet UILabel *descriptionLabel;
@property (nonatomic,weak) IBOutlet UILabel *createrLabel;
@property (nonatomic, strong) MBProgressHUD *hud;
@end

@implementation OrganizationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"组织";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)setOrganizations:(Organizations *)organization{
    _organizations = organization;
    User *info = [Config getUser];
    if (info.id == organization.createuser) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(createButtonClicked)];
    }
    
    [self setUpData];
}
- (void)setUpData{
    NSString *logo = _organizations.logo;
    if (logo == nil) {
        logo = @"";
    }
    [_logoImage loadPortrait:logo];
    _nameLabel.text = _organizations.name;
    _descriptionLabel.text = _organizations.Description;
    _createrLabel.text = _organizations.creater;
}
- (IBAction)joinOrganization{
    _hud = [Utils createHUD];
    _hud.label.text = @"正在进入";
    NSString *userId = [NSString stringWithFormat:@"%lld",[Config getOwnID]];;
    NSString *token = [Config getToken];
    NSString *mobile = [Config getUser].mobile;
    NSString *dbid = [NSString stringWithFormat:@"%ld",_organizations.dbid];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    
    NSString* urlStr = [NSString stringWithFormat:@"%@%@",BASE_URL,API_ORGANIZATION_JOIN];
    
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"POST" URLString:urlStr parameters:@{@"mobile":mobile,@"dbid":dbid}                                                                                    error:nil];
    [request addValue:userId forHTTPHeaderField:@"userId"];
    [request addValue:token forHTTPHeaderField:@"token"];
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id _Nonnull responseObject, NSError *error) {
        if (error) {
            NSLog(@"Error:-->%@", error);
            [_hud hideAnimated:YES afterDelay:1];
        } else {
            NSString *responseString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            NSLog(@"DATA-->%@", responseString);
            if (responseObject) {
                NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
                if ([dictionary[@"result"] intValue] == 1) {
                    OrgUserInfo *orguser = [OrgUserInfo mj_objectWithKeyValues:dictionary[@"data"]];
                    [Config saveOrgProfile:orguser];
                    [Config saveDbID:_organizations.dbid];
                    _hud.label.text = @"进入成功";
                    [_hud hideAnimated:YES afterDelay:1];
                    [[RCIMClient sharedRCIMClient] logout];
                    [NSThread sleepForTimeInterval:0.5];
                    [(AppDelegate *)[UIApplication sharedApplication].delegate showWindow:@"organization"];
                }else{
                    _hud.label.text = @"进入失败";
                }
            }else{
                _hud.label.text = @"进入失败";
            }
            [_hud hideAnimated:YES afterDelay:1];
        }
    }];
    [dataTask resume];
}

- (IBAction)inviteUser{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"OMeViewController" bundle:nil];
    OrgInviteViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"OrgInvite"];
    vc.hidesBottomBarWhenPushed = YES;
    vc.view.backgroundColor = [UIColor whiteColor];
    vc.organizations = _organizations;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)createButtonClicked{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"OMeViewController" bundle:nil];
    OrgEditViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"OrgEdit"];
    
    vc.hidesBottomBarWhenPushed = YES;
    vc.view.backgroundColor = [UIColor whiteColor];
    vc.organizations = _organizations;
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)editOrganization:(Organizations *)org{
    _organizations = org;
    [self setUpData];
}
@end
