//
//  CustomerEditViewController.m
//  sales
//
//  Created by user on 2017/2/16.
//  Copyright © 2017年 rayootech. All rights reserved.
//

#import "CustomerEditViewController.h"

@interface CustomerEditViewController ()

@property (nonatomic,weak) IBOutlet UITextField *nameField;
@property (nonatomic,weak) IBOutlet UITextField *titleField;
@property (nonatomic,weak) IBOutlet UITextField *deptField;
@property (nonatomic,weak) IBOutlet UITextField *mobileField;
@property (nonatomic,weak) IBOutlet UITextField *telField;
@property (nonatomic,weak) IBOutlet UITextField *emailField;
@property (nonatomic,weak) IBOutlet UITextField *addressField;
@property (nonatomic,weak) IBOutlet UITextField *webField;
@property (nonatomic,weak) IBOutlet UITextField *remarkField;
@property (nonatomic, strong) CustomerDbUtil *dbUtil;
@property (nonatomic, strong) MBProgressHUD *hud;

@end

@implementation CustomerEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _dbUtil = [[CustomerDbUtil alloc] init];
    self.title = @"客户编辑";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(saveButtonClicked)];
    [self setupData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)setupData {
    if ([NSStringUtils isEmpty:_customer.name])
        _nameField.text = @"";
    else
        _nameField.text = _customer.name;
    
    if([NSStringUtils isEmpty:_customer.title])
        _titleField.text = @"";
    else
        _titleField.text = _customer.title;
    
    if ([NSStringUtils isEmpty:_customer.department]) {
        _deptField.text = @"";
    }else{
        _deptField.text = _customer.department;
    }
    
    if ([NSStringUtils isEmpty:_customer.mobile]) {
        _mobileField.text = @"";
    }else{
        _mobileField.text = _customer.mobile;
    }
    
    if ([NSStringUtils isEmpty:_customer.tel]) {
        _telField.text = @"";
    }else{
        _telField.text = _customer.tel;
    }
    
    if ([NSStringUtils isEmpty:_customer.mail]) {
        _emailField.text = @"";
    }else{
        _emailField.text = _customer.mail;
    }
    
    if ([NSStringUtils isEmpty:_customer.address]) {
        _addressField.text = @"";
    }else{
        _addressField.text = _customer.address;
    }
    
    if ([NSStringUtils isEmpty:_customer.website]) {
        _webField.text = @"";
    }else{
        _webField.text = _customer.website;
    }
    
    if ([NSStringUtils isEmpty:_customer.remark]) {
        _remarkField.text = @"";
    }else{
        _remarkField.text = _customer.remark;
    }
}
- (void)saveButtonClicked{
    if (![Utils mobileIsUsable:_mobileField.text]) {
        [Utils showHUD:@"手机号格式不正确"];
        return;
    }
    if (![Utils emailIsUsable:_emailField.text]) {
        [Utils showHUD:@"邮箱格式不正确"];
        return;
    }
    _customer.name = _nameField.text;
    _customer.title = _titleField.text;
    _customer.department = _deptField.text;
    _customer.mobile = _mobileField.text;
    _customer.tel = _telField.text;
    _customer.mail = _emailField.text;
    _customer.address = _addressField.text;
    _customer.website = _webField.text;
    _customer.remark = _remarkField.text;
    NSLog(@"address -- %@",_customer.address);
    NSDictionary *contactinfo = _customer.mj_keyValues;
    _hud = [Utils createHUD];
    _hud.label.text = @"修改中";
    NSString *userId = [NSString stringWithFormat:@"%ld",[Config getOrgUserID]];;
    NSString *token = [Config getToken];
    NSString *dbid = [NSString stringWithFormat:@"%ld",[Config getDbID]];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    NSString* urlStr = [NSString stringWithFormat:@"%@%@?id=%ld",BASE_URL,API_CUSTOMER_EDIT,_customer.id];
    NSMutableURLRequest *request = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:urlStr parameters:contactinfo                                                                                   error:nil];
    
    [request addValue:userId forHTTPHeaderField:@"userId"];
    [request addValue:token forHTTPHeaderField:@"token"];
    [request addValue:dbid forHTTPHeaderField:@"dbid"];
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id _Nonnull responseObject, NSError *error) {
        if (error) {
            _hud.label.text = @"修改失败";
            [_hud hideAnimated:YES afterDelay:1];
        } else {
            
            if (responseObject) {
                NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
                NSString *responseString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
                NSLog(@"DATA-->%@", responseString);
                if ([dictionary[@"result"] intValue] == 1) {
                    [_dbUtil updateCustomer:_customer];
                    [_delegate customerEdit:_customer];
                    _hud.label.text = @"修改成功";
                    NSNotification *notice = [NSNotification notificationWithName:@"updateCustomer" object:nil];
                    [[NSNotificationCenter defaultCenter]postNotification:notice];
                    if (self.navigationController.viewControllers.count <= 1) {
                        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
                    } else {
                        [self.navigationController popViewControllerAnimated:YES];
                    }
                }else if([dictionary[@"result"] intValue] == 118){
                    _hud.label.text = @"无权限或该客户已被锁定";
                }else if([dictionary[@"result"] intValue] == 109){
                    _hud.label.text = @"手机号不能修改";
                }else if([dictionary[@"result"] intValue] == 125){
                    _hud.label.text = @"修改失败,客户可能已被转移";
                }else if([dictionary[@"result"] intValue] == 112){
                    _hud.label.text = @"修改失败,客户可能已被删除";
                }
            }else{
                _hud.label.text = @"修改失败";
            }
            [_hud hideAnimated:YES afterDelay:1];
        }
        
    }];
    [dataTask resume];
}
@end
