//
//  PasswordViewController.m
//  sales
//
//  Created by user on 2017/3/30.
//  Copyright © 2017年 rayootech. All rights reserved.
//

#import "PasswordViewController.h"

@interface PasswordViewController ()

@property (nonatomic,weak) IBOutlet UITextField         *nameField;
@property (nonatomic,weak) IBOutlet UITextField         *passwordField;
@property (nonatomic,weak) IBOutlet UITextField         *sureField;
@property (nonatomic,weak) IBOutlet UIButton            *registerButton;
@property (nonatomic,strong) MBProgressHUD              *hud;
@end

@implementation PasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"密码";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)setTel:(NSString *)tel{
    _tel = tel;
}

- (IBAction)registerUser{
    NSString *name = _nameField.text;
    NSString *pwd = _passwordField.text;
    NSString *pwdsure = _sureField.text;
    if ([NSStringUtils isEmpty:name]) {
        return;
    }
    if ([NSStringUtils isEmpty:pwd]) {
        return;
    }
    if ([NSStringUtils isEmpty:pwdsure]) {
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
    
    NSString* urlStr = [NSString stringWithFormat:@"%@%@",BASE_URL,API_REGISTER];
    
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"POST" URLString:urlStr parameters:@{@"mobile":_tel,@"pwd":pwd,@"name":name}                                                                                    error:nil];
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id _Nonnull responseObject, NSError *error) {
        if (error) {
            NSLog(@"Error:-->%@", error);
        } else {
            NSString *responseString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            NSLog(@"DATA UNREAD-->%@", responseString);
            if (responseObject) {
                NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
                if ([dictionary[@"result"] intValue] == 1) {
                    _hud = [Utils createHUD];
                    _hud.label.text = @"注册成功";
                    [_hud hideAnimated:YES afterDelay:1];
                    [Config setOwnID:0];
                    [(AppDelegate *)[UIApplication sharedApplication].delegate showWindowLogin:@"logout"];
                }else{
                    _hud = [Utils createHUD];
                    _hud.label.text = @"注册失败";
                    [_hud hideAnimated:YES afterDelay:1];
                }
                
            }else{
                
            }
        }
    }];
    
    [dataTask resume];
}

@end
