//
//  LoginViewController.m
//  sales
//
//  Created by user on 2016/11/3.
//  Copyright © 2016年 rayootech. All rights reserved.
//

#import "LoginViewController.h"
#import "UIColor+Util.h"
#import "SalesApi.h"
#import "User.h"
#import "Utils.h"
#import "ForgetViewController.h"
#import "Config.h"
#import "GlobalDefines.h"
#import "OMainTabBarController.h"
#import "RegisterViewController.h"
#import "AppDelegate.h"
#import <AFNetworking.h>
#import <MJExtension.h>
#import <MBProgressHUD.h>
#import <MLLinkLabel.h>

@interface LoginViewController ()<UITextFieldDelegate,MLLinkLabelDelegate>

@property (nonatomic,weak) IBOutlet UIButton *loginButton;
@property (nonatomic,weak) IBOutlet UIView   *navBar;
@property (nonatomic,weak) IBOutlet UITextField *accountField;
@property (nonatomic,weak) IBOutlet UITextField *passwordField;
@property (nonatomic,weak) IBOutlet MLLinkLabel *registerLabel;
@property (nonatomic,weak) IBOutlet MLLinkLabel *forgetLabel;
@property (nonatomic, strong) MBProgressHUD *hud;
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"登录";
    [self setUpSubview];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void) setUpSubview{

    _navBar.backgroundColor = [UIColor colorWithHex:0x469DE5];
    _accountField.delegate = self;
    _passwordField.delegate = self;
    
    [_accountField addTarget:self action:@selector(returnOnKeyboard:) forControlEvents:UIControlEventEditingDidEndOnExit];
    [_passwordField addTarget:self action:@selector(returnOnKeyboard:) forControlEvents:UIControlEventEditingDidEndOnExit];

    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:@"注册"];
    [attString setAttributes:@{NSLinkAttributeName : @"register"} range:[@"注册" rangeOfString:@"注册"]];
    
    _registerLabel.attributedText = attString;
    _registerLabel.delegate = self;
    
    NSMutableAttributedString *forgetString = [[NSMutableAttributedString alloc] initWithString:@"忘记密码"];
    [forgetString addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0, 3)];
    [forgetString addAttribute:NSLinkAttributeName value:@"forget" range:([@"忘记密码" rangeOfString:@"忘记密码"])];
    _forgetLabel.attributedText = forgetString;
    _forgetLabel.delegate = self;
}

- (IBAction)login {
    _hud = [Utils createHUD];
    _hud.label.text = @"正在登录";
    _hud.userInteractionEnabled = NO;
    NSString *deviceinfo = @"";
    NSString *uuid = [[UIDevice currentDevice].identifierForVendor UUIDString];
    NSString *deviceVersion = [[UIDevice currentDevice] systemVersion];
    int w = [UIScreen mainScreen].bounds.size.width;
    int h = [UIScreen mainScreen].bounds.size.height;
    deviceinfo = [NSString stringWithFormat:@"%@;ios;%@;%dx%d",uuid,deviceVersion,w,h];
    NSLog(@"%@----",deviceinfo);
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    NSString* urlStr = [NSString stringWithFormat:@"%@%@",BASE_URL,API_LOGIN];
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"POST" URLString:urlStr
        parameters:
            @{@"mobile":_accountField.text,@"pwd":_passwordField.text,@"deciveinfo":deviceinfo,@"updatetime":@"1"}                                                                                    error:nil];
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error) {
            NSLog(@"Error:%@", error);
            [_hud hideAnimated:YES afterDelay:1];
        } else {
            NSString *responseString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            NSLog(@"data--%@",responseString);
            NSDictionary *distionary = (NSDictionary *)responseObject;
            User *response = [User mj_objectWithKeyValues:distionary];
            if(response != nil ){
                if (response.result == 1) {
                    User *user = response.data;
                    [_hud hideAnimated:YES afterDelay:1];
                    [Config saveProfile:user];
                    [(AppDelegate *)[UIApplication sharedApplication].delegate showWindow:@"omain"];
                }else{
                    _hud.mode = MBProgressHUDModeCustomView;
                    _hud.label.text = @"用户名或密码错误";
                }
            }else{
                
            }
            [_hud hideAnimated:YES afterDelay:1];
        }
    }];
    [dataTask resume];
    
}

#pragma mark - 键盘操作

- (void)hidenKeyboard
{
    [_accountField resignFirstResponder];
    [_passwordField resignFirstResponder];
}

- (void)returnOnKeyboard:(UITextField *)sender
{
    if (sender == _accountField) {
        [_passwordField becomeFirstResponder];
    } else if (sender == _passwordField) {
        [self hidenKeyboard];
        if (_loginButton.enabled) {
            [self login];
        }
    }
}

- (void)didClickLink:(MLLink *)link linkText:(NSString *)linkText linkLabel:(MLLinkLabel *)linkLabel
{
    if ([link.linkValue isEqualToString:@"register"]) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        RegisterViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"Register"];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
        vc.hidesBottomBarWhenPushed = YES;
        vc.view.backgroundColor = [UIColor whiteColor];
        [self presentViewController:nav animated:YES completion:nil];
    }else if([link.linkValue isEqualToString:@"forget"]){
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        ForgetViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"Forget"];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
        vc.hidesBottomBarWhenPushed = YES;
        vc.view.backgroundColor = [UIColor whiteColor];
        [self presentViewController:nav animated:YES completion:nil];
    }
}

@end
