//
//  EnteringCustomerViewController.m
//  sales
//
//  Created by user on 2017/2/20.
//  Copyright © 2017年 rayootech. All rights reserved.
//

#import "EnteringCustomerViewController.h"
#import "SalesApi.h"
#import "Config.h"
#import "PreferUtil.h"
#import "CustomerDbUtil.h"
#import "Utils.h"
#import <AFNetworking.h>
#import <MBProgressHUD.h>
#import <MJExtension.h>
@interface EnteringCustomerViewController ()

@property (weak,nonatomic) IBOutlet UITextField *nameField;
@property (weak,nonatomic) IBOutlet UITextField *companyField;
@property (weak,nonatomic) IBOutlet UITextField *titleField;
@property (weak,nonatomic) IBOutlet UITextField *deptField;
@property (weak,nonatomic) IBOutlet UITextField *mobileField;
@property (weak,nonatomic) IBOutlet UITextField *telField;
@property (weak,nonatomic) IBOutlet UITextField *mailField;
@property (weak,nonatomic) IBOutlet UITextField *addressField;
@property (weak,nonatomic) IBOutlet UITextField *websiteField;
@property (weak,nonatomic) IBOutlet UITextField *remarkField;

@property (nonatomic,strong) CustomerDbUtil *dbUtil;
@property (nonatomic,strong) PreferUtil *preferUtil;
@property (nonatomic, strong) MBProgressHUD *hud;

@end

@implementation EnteringCustomerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"手工录入";
    _dbUtil = [[CustomerDbUtil alloc] init];
    _preferUtil = [PreferUtil new];
    [_preferUtil initIN];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)sure{
    _hud = [Utils createHUD];
    NSString *name = _nameField.text;
    NSString *company = _companyField.text;
    NSString *title = _titleField.text;
    NSString *dept = _deptField.text;
    NSString *mobile = _mobileField.text;
    NSString *tel = _telField.text;
    NSString *mail = _mailField.text;
    NSString *address = _addressField.text;
    NSString *website = _websiteField.text;
    NSString *remark = _remarkField.text;
    NSString *userId = [NSString stringWithFormat:@"%ld",[Config getOrgUserID]];;
    NSString *token = [Config getToken];
    NSString *dbid = [NSString stringWithFormat:@"%ld",[Config getDbID]];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    
    NSString* urlStr = [NSString stringWithFormat:@"%@%@",BASE_URL,API_CUSTOMER_ADD];
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"POST" URLString:urlStr parameters:@{@"img":@"img",@"name":name,@"company":company,@"title":title,@"dept":dept,@"mobile":mobile,@"tel":tel,@"mail":mail,@"address":address,@"website":website,@"remark":remark}                                                                                    error:nil];
    [request addValue:userId forHTTPHeaderField:@"userId"];
    [request addValue:token forHTTPHeaderField:@"token"];
    [request addValue:dbid forHTTPHeaderField:@"dbid"];
    
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
                    _hud.label.text = @"录入成功";
                    [_hud hideAnimated:YES afterDelay:1];
                    Customer *cus = [Customer mj_objectWithKeyValues:dictionary[@"data"]];
                    [_dbUtil insertCustomer:cus];
                    NSNotification *notice = [NSNotification notificationWithName:@"updateCustomer" object:nil];
                    [[NSNotificationCenter defaultCenter]postNotification:notice];
                    if (self.navigationController.viewControllers.count <= 1) {
                        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
                    } else {
                        [self.navigationController popViewControllerAnimated:YES];
                    }
                }else{
                    _hud.label.text = @"录入失败";
                    [_hud hideAnimated:YES afterDelay:1];
                }
            }else{
                _hud.label.text = @"录入失败";
                [_hud hideAnimated:YES afterDelay:1];
            }
        }
    }];
    [dataTask resume];
}

- (void)setMap:(NSMutableDictionary *)map{
    _map = map;
    _nameField.text = [map valueForKey:@"name"];
    _companyField.text = [map valueForKey:@"company"];
    _titleField.text = [map valueForKey:@"jobtitle"];
    _deptField.text = [map valueForKey:@"department"];
    _mobileField.text = [map valueForKey:@"tel_mobile"];
    _telField.text = [map valueForKey:@"tel_main"];
    _mailField.text = [map valueForKey:@"email"];
    _addressField.text = [map valueForKey:@"address"];
    _websiteField.text = [map valueForKey:@"web"];
    _remarkField.text = @"";
}

@end
