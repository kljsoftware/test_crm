//
//  RegisterViewController.m
//  sales
//
//  Created by user on 2017/3/30.
//  Copyright © 2017年 rayootech. All rights reserved.
//

#import "RegisterViewController.h"
#import "NSStringUtils.h"
#import "Config.h"
#import "SalesApi.h"
#import "Utils.h"
#import "PasswordViewController.h"
#import <MBProgressHUD.h>
#import <AFNetworking.h>
@interface RegisterViewController ()

@property (nonatomic,weak) IBOutlet UITextField     *telField;
@property (nonatomic,weak) IBOutlet UITextField     *verityField;
@property (nonatomic,weak) IBOutlet UIButton        *verityButton;
@property (nonatomic,weak) IBOutlet UIButton        *nextButton;
@property (nonatomic,assign) NSInteger              count;
@property (nonatomic,strong) MBProgressHUD          *hud;
@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"注册";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)getVerity{
    NSString *tel = _telField.text;
    if ([NSStringUtils isEmpty:tel]) {
        return;
    }
    NSLog(@"tel--%@",tel);
    _count = 120;
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    
    NSString* urlStr = [NSString stringWithFormat:@"%@%@",BASE_URL,API_PUSH_IDENTIFYCODE];
    
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"POST" URLString:urlStr parameters:@{@"mobile":tel,@"action":@"reg"}                                                                                    error:nil];
    
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
                }else if([dictionary[@"result"] intValue] == 1021){
                    _hud = [Utils createHUD];
                    _hud.label.text = @"该号码已被注册";
                    [_hud hideAnimated:YES afterDelay:1];
                }
                
            }else{
                
            }
        }
    }];

    [dataTask resume];
}
- (IBAction)next{
    NSString *tel = _telField.text;
    if ([NSStringUtils isEmpty:tel]) {
        return;
    }
    NSString *verity = _verityField.text;
    if ([NSStringUtils isEmpty:verity]) {
        return;
    }
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    
    NSString* urlStr = [NSString stringWithFormat:@"%@%@",BASE_URL,API_CHECK_IDENTIFYCODE];
    
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"POST" URLString:urlStr parameters:@{@"mobile":tel,@"identifyCode":verity}                                                                                    error:nil];
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id _Nonnull responseObject, NSError *error) {
        if (error) {
            NSLog(@"Error:-->%@", error);
        } else {
            NSString *responseString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            NSLog(@"DATA UNREAD-->%@", responseString);
            if (responseObject) {
                NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
                if ([dictionary[@"result"] intValue] == 1) {
                    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                    PasswordViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"Password"];
                    vc.hidesBottomBarWhenPushed = YES;
                    vc.view.backgroundColor = [UIColor whiteColor];
                    vc.tel = tel;
                    [self.navigationController pushViewController:vc animated:YES];
                }else{
                    _hud = [Utils createHUD];
                    _hud.label.text = @"验证码错误";
                    [_hud hideAnimated:YES afterDelay:1];
                }
                
            }else{
                
            }
        }
    }];
    
    [dataTask resume];
}
@end
