//
//  RegisterViewController.m
//  sales
//
//  Created by user on 2017/3/30.
//  Copyright © 2017年 rayootech. All rights reserved.
//

#import "RegisterViewController.h"
#import "PasswordViewController.h"

@interface RegisterViewController ()

@property (nonatomic,weak) IBOutlet UITextField     *telField;
@property (nonatomic,weak) IBOutlet UITextField     *verityField;
@property (nonatomic,weak) IBOutlet UIButton        *verityButton;
@property (nonatomic,weak) IBOutlet UIButton        *nextButton;
@property (nonatomic,assign) NSInteger              count;
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

    self.count = 120;
    
    NSString* urlStr = [NSString stringWithFormat:@"%@%@",BASE_URL,API_PUSH_IDENTIFYCODE];
    WeakSelf;
    [NetWorkManager request:POST_METHOD URL:urlStr requestHeader:nil parameters:@{@"mobile":tel,@"action":@"reg"} success:^(NSURLSessionDataTask *task, id responseObject) {
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

- (IBAction)next {
    NSString *tel = _telField.text;
    if ([NSStringUtils isEmpty:tel]) {
        return;
    }
    NSString *verity = _verityField.text;
    if ([NSStringUtils isEmpty:verity]) {
        return;
    }
    
    NSString* urlStr = [NSString stringWithFormat:@"%@%@",BASE_URL,API_CHECK_IDENTIFYCODE];
    WeakSelf;
    [NetWorkManager request:POST_METHOD URL:urlStr requestHeader:nil parameters:@{@"mobile":tel,@"identifyCode":verity} success:^(NSURLSessionDataTask *task, id responseObject) {
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        PasswordViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"Password"];
        vc.hidesBottomBarWhenPushed = YES;
        vc.tel = tel;
        [weakSelf.navigationController pushViewController:vc animated:YES];
        
    } failure:^(NSURLSessionDataTask *task, BIUPError *error) {
        [Utils showHUD:error.message];
    }];
}

@end
