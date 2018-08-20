//
//  BindEmailViewController.m
//  sales
//
//  Created by user on 2017/4/26.
//  Copyright © 2017年 rayootech. All rights reserved.
//

#import "BindEmailViewController.h"

@interface BindEmailViewController ()

@property (nonatomic,weak) IBOutlet UITextField         *emailField;
@property (nonatomic,weak) IBOutlet UITextField         *verityField;
@property (nonatomic,weak) IBOutlet UIButton            *verityButton;
@property (nonatomic,weak) IBOutlet UIButton            *bindButton;
@property (nonatomic,assign) NSInteger                  count;
@property (nonatomic,strong) MBProgressHUD              *hud;

@end

@implementation BindEmailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setType:(NSInteger)type{
    if (type == 1) {
        self.title = @"更换邮箱";
        [_bindButton setTitle:@"更换邮箱" forState:UIControlStateNormal];
    }else{
        self.title = @"绑定邮箱";
        [_bindButton setTitle:@"绑定邮箱" forState:UIControlStateNormal];
    }
}

- (void)setModel:(NSString *)model{
    _model = model;
}
- (IBAction)getVerity{
    _hud = [Utils createHUD];
    
    NSString *email = _emailField.text;
    if ([NSStringUtils isEmpty:email]) {
        _hud.label.text = @"邮箱不能为空";
        [_hud hideAnimated:YES afterDelay:1];
        return;
    }
    if(![NSStringUtils isEmail:email]){
        _hud.label.text = @"邮箱格式不正确";
        [_hud hideAnimated:YES afterDelay:1];
        return;
    }
    _count = 120;
    NSString *userId = [NSString stringWithFormat:@"%ld",[Config getOrgUserID]];;
    NSString *token = [Config getToken];
    NSString *dbid = [NSString stringWithFormat:@"%ld",[Config getDbID]];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    
    NSString* urlStr = [NSString stringWithFormat:@"%@%@",BASE_URL,API_GET_EMAIL_CODE];
    
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"POST" URLString:urlStr parameters:@{@"email":email}                                                                                    error:nil];
    [request addValue:userId forHTTPHeaderField:@"userId"];
    [request addValue:token forHTTPHeaderField:@"token"];
    [request addValue:dbid forHTTPHeaderField:@"dbid"];
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id _Nonnull responseObject, NSError *error) {
        if (error) {
            NSLog(@"Error:-->%@", error);
            _hud.label.text = @"请检测网络";
            [_hud hideAnimated:YES afterDelay:1];
        } else {
            NSString *responseString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            NSLog(@"DATA UNREAD-->%@", responseString);
            if (responseObject) {
                NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
                if ([dictionary[@"result"] intValue] == 1) {
                    [_hud hideAnimated:YES afterDelay:1];
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
                }else {
                    _hud.label.text = @"获取失败";
                    [_hud hideAnimated:YES afterDelay:1];
                }
                
            }else{
                _hud.label.text = @"获取失败";
                [_hud hideAnimated:YES afterDelay:1];
            }
        }
    }];
    
    [dataTask resume];
}

- (IBAction)bindEmail{
    _hud = [Utils createHUD];
    
    NSString *email = _emailField.text;
    if ([NSStringUtils isEmpty:email]) {
        _hud.label.text = @"邮箱不能为空";
        [_hud hideAnimated:YES afterDelay:1];
        return;
    }
    if(![NSStringUtils isEmail:email]){
        _hud.label.text = @"邮箱格式不正确";
        [_hud hideAnimated:YES afterDelay:1];
        return;
    }
    NSString *verity = _verityField.text;
    if ([NSStringUtils isEmpty:verity]) {
        _hud.label.text = @"验证码不能为空";
        [_hud hideAnimated:YES afterDelay:1];
        return;
    }
    NSString *userId = [NSString stringWithFormat:@"%ld",[Config getOrgUserID]];;
    NSString *token = [Config getToken];
    NSString *dbid = [NSString stringWithFormat:@"%ld",[Config getDbID]];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    
    NSString* urlStr = [NSString stringWithFormat:@"%@%@",BASE_URL,API_BIND_EMAIL];
    
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"POST" URLString:urlStr parameters:@{@"email":email,@"email_smsid":verity}                                                                                    error:nil];
    [request addValue:userId forHTTPHeaderField:@"userId"];
    [request addValue:token forHTTPHeaderField:@"token"];
    [request addValue:dbid forHTTPHeaderField:@"dbid"];
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id _Nonnull responseObject, NSError *error) {
        if (error) {
            NSLog(@"Error:-->%@", error);
            _hud.label.text = @"请检测网络";
            [_hud hideAnimated:YES afterDelay:1];
        } else {
            NSString *responseString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            NSLog(@"DATA UNREAD-->%@", responseString);
            if (responseObject) {
                NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
                if ([dictionary[@"result"] intValue] == 1) {
                    _hud.label.text = @"绑定成功";
                    [_hud hideAnimated:YES afterDelay:1];
                    [self bindSuccess];
                }else if([dictionary[@"result"] intValue] == 128){
                    [_hud hideAnimated:YES afterDelay:1];
                    [self reBindEmail];
                }else{
                    _hud.label.text = @"绑定失败";
                    [_hud hideAnimated:YES afterDelay:1];
                    
                }
                
            }else{
                _hud.label.text = @"验证码失败";
                [_hud hideAnimated:YES afterDelay:1];
            }
        }
    }];
    
    [dataTask resume];
}

- (void)reBindEmail{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"该邮箱已被绑定，是否继续？" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *sure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self reBindRequest];
    }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alert addAction:sure];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:^{}];
}

- (void)reBindRequest{
    _hud = [Utils createHUD];
    NSString *userId = [NSString stringWithFormat:@"%ld",[Config getOrgUserID]];;
    NSString *token = [Config getToken];
    NSString *dbid = [NSString stringWithFormat:@"%ld",[Config getDbID]];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    
    NSString* urlStr = [NSString stringWithFormat:@"%@%@",BASE_URL,API_BIND_EMAIL];
    NSNumber *number = @1;
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"POST" URLString:urlStr parameters:@{@"email":_emailField.text,@"email_smsid":_verityField.text,@"status":number}                                                                                    error:nil];
    [request addValue:userId forHTTPHeaderField:@"userId"];
    [request addValue:token forHTTPHeaderField:@"token"];
    [request addValue:dbid forHTTPHeaderField:@"dbid"];
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id _Nonnull responseObject, NSError *error) {
        if (error) {
            NSLog(@"Error:-->%@", error);
            _hud.label.text = @"请检测网络";
            [_hud hideAnimated:YES afterDelay:1];
        } else {
            NSString *responseString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            NSLog(@"DATA UNREAD-->%@", responseString);
            if (responseObject) {
                NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
                if ([dictionary[@"result"] intValue] == 1) {
                    _hud.label.text = @"绑定成功";
                    [_hud hideAnimated:YES afterDelay:1];
                    [self bindSuccess];
                }else {
                    _hud.label.text = @"绑定失败";
                    [_hud hideAnimated:YES afterDelay:1];
                    
                }
                
            }else{
                _hud.label.text = @"验证码失败";
                [_hud hideAnimated:YES afterDelay:1];
            }
        }
    }];
    
    [dataTask resume];
}
- (void)bindSuccess{
    [_delegate emailUpdate:_emailField.text];
    OrgUserInfo *orguser = [Config getOrgUser];
    orguser.email = _emailField.text;
    [Config saveOrgProfile:orguser];
    _hud.label.text = @"修改成功";
    NSNotification *notice = [NSNotification notificationWithName:@"updateOrgUserInfo" object:nil];
    [[NSNotificationCenter defaultCenter]postNotification:notice];
    if (self.navigationController.viewControllers.count <= 1) {
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}
@end
