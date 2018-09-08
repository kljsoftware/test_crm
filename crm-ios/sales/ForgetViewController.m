//
//  ForgetViewController.m
//  sales
//
//  Created by user on 2017/3/30.
//  Copyright © 2017年 rayootech. All rights reserved.
//

#import "ForgetViewController.h"

@interface ForgetViewController ()

@property (nonatomic,weak) IBOutlet UITextField          *mobileField;
@property (nonatomic,weak) IBOutlet UITextField          *verityField;
@property (nonatomic,weak) IBOutlet UITextField          *pwdField;
@property (nonatomic,weak) IBOutlet UITextField          *pwdsureField;
@property (nonatomic,weak) IBOutlet UIButton             *verityButton;
@property (nonatomic,weak) IBOutlet UIButton             *sureButton;
@property (nonatomic,assign) NSInteger                   count;

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
    NSString* urlStr = [NSString stringWithFormat:@"%@%@",BASE_URL,API_PUSH_IDENTIFYCODE];
    WeakSelf;
    [NetWorkManager request:POST_METHOD URL:urlStr requestHeader:nil parameters:@{@"mobile":mobile,@"action":@"forgetpwd"} success:^(NSURLSessionDataTask *task, id responseObject) {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            weakSelf.verityButton.enabled = NO;
            while (weakSelf.count >= 0) {
                [NSThread sleepForTimeInterval:1];
                weakSelf.count --;
                dispatch_async(dispatch_get_main_queue(), ^{
                    weakSelf.verityButton.titleLabel.text = [NSString stringWithFormat:@"剩余%ld秒",weakSelf.count];
                    [weakSelf.verityButton setTitle:[NSString stringWithFormat:@"剩余%ld秒",weakSelf.count] forState:UIControlStateNormal];
                });
                if (weakSelf.count == 0) {
                    weakSelf.verityButton.enabled = YES;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        weakSelf.verityButton.titleLabel.text = @"获取验证码";
                        [weakSelf.verityButton setTitle:@"获取验证码" forState:UIControlStateNormal];
                    });
                    break;
                }
            }
        });
        
    } failure:^(NSURLSessionDataTask *task, BIUPError *error) {
        [Utils showHUD:error.message];
    }];
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
        [Utils showHUD:@"两次密码不一致"];
        return;
    }
    
    NSString* urlStr = [NSString stringWithFormat:@"%@%@",BASE_URL,API_FORGETPWD];
    WeakSelf;
    [NetWorkManager request:POST_METHOD URL:urlStr requestHeader:nil parameters:@{@"mobile":mobile,@"newPwd":pwd,@"identifyCode":verity} success:^(NSURLSessionDataTask *task, id responseObject) {
        
        [Utils showHUD:@"修改成功"];
        if (weakSelf.navigationController.viewControllers.count <= 1) {
            [weakSelf.navigationController dismissViewControllerAnimated:YES completion:nil];
        } else {
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }
        
    } failure:^(NSURLSessionDataTask *task, BIUPError *error) {
        [Utils showHUD:error.message];
    }];
}

@end
