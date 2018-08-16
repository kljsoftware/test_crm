//
//  OrganizationCreateViewController.m
//  sales
//
//  Created by user on 2017/3/24.
//  Copyright © 2017年 rayootech. All rights reserved.
//

#import "OrganizationCreateViewController.h"
#import "SalesApi.h"
#import "Config.h"
#import "NSStringUtils.h"
#import "Utils.h"
#import <AFNetworking.h>
#import <MBProgressHUD.h>
@interface OrganizationCreateViewController ()

@property (nonatomic,weak) IBOutlet UITextField          *nameText;
@property (nonatomic,weak) IBOutlet UITextField          *descriptText;
@property (nonatomic,strong) MBProgressHUD               *hud;

@end

@implementation OrganizationCreateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"创建组织";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(saveButtonClicked)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)saveButtonClicked{
    _hud = [Utils createHUD];
    NSString *name = _nameText.text;
    NSString *desc = _descriptText.text;
    if ([NSStringUtils isEmpty:name]) {
        _hud.label.text = @"名称不能为空";
        [_hud hideAnimated:YES afterDelay:1];
        return;
    }
    if ([NSStringUtils isEmpty:desc]) {
        _hud.label.text = @"描述不能为空";
        [_hud hideAnimated:YES afterDelay:1];
        return;
    }
    NSString *userId = [NSString stringWithFormat:@"%lld",[Config getOwnID]];;
    NSString *token = [Config getToken];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    
    NSString* urlStr = [NSString stringWithFormat:@"%@%@",BASE_URL,API_ORGANIZATION_NEW];
    
    
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"POST" URLString:urlStr parameters:@{@"name":name,@"desc":desc}                                                                                    error:nil];
    [request addValue:userId forHTTPHeaderField:@"userId"];
    [request addValue:token forHTTPHeaderField:@"token"];
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id _Nonnull responseObject, NSError *error) {
        if (error) {
            NSLog(@"Error:-->%@", error);
            _hud.label.text = @"网络错误";
            [_hud hideAnimated:YES afterDelay:1];
        } else {
            NSString *responseString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            NSLog(@"DATA-->%@", responseString);
            if (responseObject) {
                NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
                if ([dictionary[@"result"] intValue] == 1) {
                    _hud.label.text = @"创建成功";
                    [_hud hideAnimated:YES afterDelay:1];
                    NSNotification *notice = [NSNotification notificationWithName:@"updateOrganizationList" object:nil];
                    [[NSNotificationCenter defaultCenter]postNotification:notice];
                    if (self.navigationController.viewControllers.count <= 1) {
                        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
                    } else {
                        [self.navigationController popViewControllerAnimated:YES];
                    }
                }else{
                    _hud.label.text = @"创建失败";
                    [_hud hideAnimated:YES afterDelay:1];
                }
            }else{
                _hud.label.text = @"创建失败";
                [_hud hideAnimated:YES afterDelay:1];
            }
        }
    }];
    [dataTask resume];

}

@end
