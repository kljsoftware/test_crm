//
//  UpdatePasswordViewController.m
//  sales
//
//  Created by user on 2017/4/14.
//  Copyright © 2017年 rayootech. All rights reserved.
//

#import "UpdatePasswordViewController.h"
#import "SalesApi.h"
#import "NSStringUtils.h"
#import "Config.h"
#import "Utils.h"
#import <AFNetworking.h>
#import <MBProgressHUD.h>
@interface UpdatePasswordViewController ()

@property (nonatomic,weak) IBOutlet UITextField         *oldText;
@property (nonatomic,weak) IBOutlet UITextField         *nowText;
@property (nonatomic,weak) IBOutlet UITextField         *sureText;
@property (nonatomic,strong) MBProgressHUD              *hud;

@end

@implementation UpdatePasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"更改密码";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(saveButtonClicked)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)saveButtonClicked{
    NSString *old = _oldText.text;
    NSString *now = _nowText.text;
    NSString *sure = _sureText.text;

    if ([NSStringUtils isEmpty:old] || [NSStringUtils isEmpty:now] || [NSStringUtils isEmpty:sure]) {
        return;
    }
    
    _hud = [Utils createHUD];
    if (![now isEqualToString:sure]) {
        _hud.label.text = @"两次密码不一致";
        [_hud hideAnimated:YES afterDelay:1];
        return;
    }
    if ([now length] <= 6) {
        _hud.label.text = @"新密码长度不能小于7位";
        [_hud hideAnimated:YES afterDelay:1];
        return;
    }
    NSString *userId = [NSString stringWithFormat:@"%lld",[Config getOwnID]];;
    NSString *token = [Config getToken];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    
    NSString* urlStr = [NSString stringWithFormat:@"%@%@",BASE_URL,API_UPDATE_PWD];
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"POST" URLString:urlStr parameters:@{@"appUserId":userId,@"orginalPwd":old,@"newPwd":now}                                                                                    error:nil];
    [request addValue:userId forHTTPHeaderField:@"userId"];
    [request addValue:token forHTTPHeaderField:@"token"];
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id _Nonnull responseObject, NSError *error) {
        if (error) {
            NSLog(@"Error:-->%@", error);
            _hud.label.text = @"请检查网络";
            [_hud hideAnimated:YES afterDelay:1];
        } else {
            NSString *responseString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
                        NSLog(@"DATA-->%@", responseString);
            if (responseObject) {
                NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
                if ([dictionary[@"result"] intValue] == 1) {
                    _hud.label.text = @"更改成功";
                    [_hud hideAnimated:YES afterDelay:1];
                    if (self.navigationController.viewControllers.count <= 1) {
                        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
                    } else {
                        [self.navigationController popViewControllerAnimated:YES];
                    }
                    
                }else if([dictionary[@"result"] intValue] == 105){
                    _hud.label.text = @"原始密码不正确";
                    [_hud hideAnimated:YES afterDelay:1];
                }
            }else{
                _hud.label.text = @"更改失败";
                [_hud hideAnimated:YES afterDelay:1];
            }
        }
    }];
    [dataTask resume];
}

@end
