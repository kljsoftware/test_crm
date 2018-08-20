//
//  EnteringContactViewController.m
//  sales
//
//  Created by user on 2016/12/2.
//  Copyright © 2016年 rayootech. All rights reserved.
//

#import "EnteringContactViewController.h"

@interface EnteringContactViewController ()
@property (weak,nonatomic) IBOutlet UIButton *sureBtn;
@property (weak,nonatomic) IBOutlet UITextField *nameField;
@property (weak,nonatomic) IBOutlet UITextField *organizationField;
@property (weak,nonatomic) IBOutlet UITextField *titleField;
@property (weak,nonatomic) IBOutlet UITextField *deptField;
@property (weak,nonatomic) IBOutlet UITextField *mobileField;
@property (weak,nonatomic) IBOutlet UITextField *telField;
@property (weak,nonatomic) IBOutlet UITextField *mailField;
@property (weak,nonatomic) IBOutlet UITextField *addressField;
@property (weak,nonatomic) IBOutlet UITextField *websiteField;
@property (weak,nonatomic) IBOutlet UITextField *remarkField;
@property (nonatomic, strong) MBProgressHUD *hud;
@end

@implementation EnteringContactViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _nameField.text = @"";
    _organizationField.text = @"";
    _titleField.text = @"";
    _deptField.text = @"";
    _mobileField.text = @"";
    _telField.text = @"";
    _mailField.text = @"";
    _addressField.text = @"";
    _websiteField.text = @"";
    _remarkField.text = @"";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)sure{
    _hud = [Utils createHUD];
    NSString *name = _nameField.text;
    NSString *organization = _organizationField.text;
    NSString *title = _titleField.text;
    NSString *dept = _deptField.text;
    NSString *mobile = _mobileField.text;
    NSString *tel = _telField.text;
    NSString *mail = _mailField.text;
    NSString *address = _addressField.text;
    NSString *website = _websiteField.text;
    NSString *remark = _remarkField.text;
    
    name = [name stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if(name.length <= 0 || name == nil){
        _hud.label.text = @"名字不能为空";
        [_hud hideAnimated:YES afterDelay:1];
        return;
    }
    _hud.label.text = @"录入中";
    
    NSString *userId = [NSString stringWithFormat:@"%lld",[Config getOwnID]];;
    NSString *token = [Config getToken];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    
    NSString* urlStr = [NSString stringWithFormat:@"%@%@",BASE_URL,API_CONTACT_ADD];
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"POST" URLString:urlStr parameters:@{@"name":name,@"organization":organization,@"title":title,@"dept":dept,@"mobile":mobile,@"tel":tel,@"mail":mail,@"address":address,@"website":website,@"remark":remark}                                                                                    error:nil];
    [request addValue:userId forHTTPHeaderField:@"userId"];
    [request addValue:token forHTTPHeaderField:@"token"];
    
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
                    NSNotification *notice = [NSNotification notificationWithName:@"updateContact" object:nil];
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
    _organizationField.text = [map valueForKey:@"company"];
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
