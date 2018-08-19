//
//  ForgetViewController.m
//  sales
//
//  Created by user on 2017/3/30.
//  Copyright © 2017年 rayootech. All rights reserved.
//

#import "ForgetViewController.h"
#import "SalesApi.h"
#import "Config.h"
#import "Utils.h"
#import "NSStringUtils.h"
#import <AFNetworking.h>
#import <MBProgressHUD.h>
@interface ForgetViewController ()

@property (nonatomic,weak) IBOutlet UITextField          *mobileField;
@property (nonatomic,weak) IBOutlet UITextField          *verityField;
@property (nonatomic,weak) IBOutlet UITextField          *pwdField;
@property (nonatomic,weak) IBOutlet UITextField          *pwdsureField;
@property (nonatomic,weak) IBOutlet UIButton             *verityButton;
@property (nonatomic,weak) IBOutlet UIButton             *sureButton;
@property (nonatomic,assign) NSInteger                   count;
@property (nonatomic,strong) MBProgressHUD               *hud;

@end

@implementation ForgetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"忘记密码";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)getVerity{
    NSString *mobile = _mobileField.text;
    if ([NSStringUtils isEmpty:mobile]) {
        return;
    }
    _count = 120;
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    
    NSString* urlStr = [NSString stringWithFormat:@"%@%@",BASE_URL,API_PUSH_IDENTIFYCODE];
    
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"POST" URLString:urlStr parameters:@{@"mobile":mobile,@"action":@"forgetpwd"}                                                                                    error:nil];
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id _Nonnull responseObject, NSError *error) {
        if (error) {
            NSLog(@"Error:-->%@", error);
        } else {
            NSString *responseString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            NSLog(@"DATA UNREAD-->%@", responseString);
            if (responseObject) {
                NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
                if ([dictionary[@"result"] intValue] == 1) {
                    dispatch_async(dispatch_get_global_queue(0, 0), ^{
                        _verityButton.enabled = NO;
                        while (_count >= 0) {
                            [NSThread sleepForTimeInterval:1];
                            _count --;
                            dispatch_async(dispatch_get_main_queue(), ^{
                                _verityButton.titleLabel.text = [NSString stringWithFormat:@"剩余%ld秒",_count];
                                [_verityButton setTitle:[NSString stringWithFormat:@"剩余%ld秒",_count] forState:UIControlStateNormal];
                            });
                            if (_count == 0) {
                                _verityButton.enabled = YES;
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    _verityButton.titleLabel.text = @"获取验证码";
                                    [_verityButton setTitle:@"获取验证码" forState:UIControlStateNormal];
                                });
                                break;
                            }
                        }
                    });
                }else if([dictionary[@"result"] intValue] == 111){
                    _hud = [Utils createHUD];
                    _hud.label.text = @"请先注册";
                    [_hud hideAnimated:YES afterDelay:1];
                }
                
            }else{
                
            }
        }
    }];
    
    [dataTask resume];
}

- (IBAction)sure{
    NSString *mobile = _mobileField.text;
    NSString *pwd = _pwdField.text;
    NSString *pwdsure = _pwdsureField.text;
    NSString *verity = _verityField.text;
    if ([NSStringUtils isEmpty:mobile]) {
        return;
    }
    if ([NSStringUtils isEmpty:pwd]) {
        return;
    }
    if ([NSStringUtils isEmpty:pwdsure]) {
        return;
    }
    if ([NSStringUtils isEmpty:verity]) {
        return;
    }
    if (![pwd isEqualToString:pwdsure]) {
        _hud = [Utils createHUD];
        _hud.label.text = @"两次密码不一致";
        [_hud hideAnimated:YES afterDelay:1];
        return;
    }
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    
    NSString* urlStr = [NSString stringWithFormat:@"%@%@",BASE_URL,API_FORGETPWD];
    
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"POST" URLString:urlStr parameters:@{@"mobile":mobile,@"newPwd":pwd,@"identifyCode":verity}                                                                                    error:nil];
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id _Nonnull responseObject, NSError *error) {
        if (error) {
            NSLog(@"Error:-->%@", error);
        } else {
            NSString *responseString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            NSLog(@"DATA-->%@", responseString);
            if (responseObject) {
                NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
                if ([dictionary[@"result"] intValue] == 1) {
                    _hud = [Utils createHUD];
                    _hud.label.text = @"修改成功";
                    [_hud hideAnimated:YES afterDelay:1];
                    if (self.navigationController.viewControllers.count <= 1) {
                        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
                    } else {
                        [self.navigationController popViewControllerAnimated:YES];
                    }
                }else{
                    _hud = [Utils createHUD];
                    _hud.label.text = @"修改失败";
                    [_hud hideAnimated:YES afterDelay:1];
                }
                
            }else{
                
            }
        }
    }];
    
    [dataTask resume];
}
@end
