//
//  CustomerInfoViewController.m
//  sales
//
//  Created by user on 2017/2/22.
//  Copyright © 2017年 rayootech. All rights reserved.
//

#import "CustomerInfoViewController.h"

@interface CustomerInfoViewController ()

@property (nonatomic,weak) IBOutlet UIButton    *sexBtn;
@property (nonatomic,weak) IBOutlet UITextField *ageField;
@property (nonatomic,weak) IBOutlet UITextField *hometownField;
@property (nonatomic,weak) IBOutlet UITextField *schoolField;
@property (nonatomic,weak) IBOutlet UITextField *specialtyField;
@property (nonatomic,weak) IBOutlet UITextField *likesField;
@property (nonatomic,weak) IBOutlet UITextField *homeaddressField;
@property (nonatomic,weak) IBOutlet UITextField *homeinfoField;


@property (nonatomic,strong) CustomerDbUtil *dbUtil;
@property (nonatomic, strong) MBProgressHUD *hud;

@end

@implementation CustomerInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"个人信息";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(saveButtonClicked)];
    [_sexBtn addTarget:self action:@selector(sexChange) forControlEvents:UIControlEventTouchUpInside];
    [self setupData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (void)setupData{
    if (_customer.sex == 0) {
        [_sexBtn setTitle:@"男" forState:UIControlStateNormal];
    }else{
        [_sexBtn setTitle:@"女" forState:UIControlStateNormal];
    }
    _ageField.text = [NSString stringWithFormat:@"%ld",_customer.age];
    _hometownField.text = _customer.hometown;
    _schoolField.text = _customer.school;
    _specialtyField.text = _customer.specialty;
    _likesField.text = _customer.likes;
    _homeaddressField.text = _customer.homeaddress;
    _homeinfoField.text = _customer.homeinfo;
}
- (void)sexChange{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction *allAction = [UIAlertAction actionWithTitle:@"男" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        _customer.sex = 0;
        [_sexBtn setTitle:@"男" forState:UIControlStateNormal];
    }];
    UIAlertAction *waitAction = [UIAlertAction actionWithTitle:@"女" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        _customer.sex = 1;
        [_sexBtn setTitle:@"女" forState:UIControlStateNormal];
    }];
    

//    [alertController addAction:cancelAction];
    [alertController addAction:allAction];
    [alertController addAction:waitAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}
- (void)saveButtonClicked{
    _customer.age = [_ageField.text integerValue];
    _customer.hometown = _hometownField.text;
    _customer.school = _schoolField.text;
    _customer.specialty = _specialtyField.text;
    _customer.likes = _likesField.text;
    _customer.homeaddress = _homeaddressField.text;
    _customer.homeinfo = _homeinfoField.text;
    NSDictionary *contactinfo = _customer.mj_keyValues;
    NSLog(@"----%@",contactinfo);
    _hud = [Utils createHUD];
    _hud.label.text = @"修改中";
    NSString *userId = [NSString stringWithFormat:@"%ld",[Config getOrgUserID]];;
    NSString *token = [Config getToken];
    NSString *dbid = [NSString stringWithFormat:@"%ld",[Config getDbID]];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    NSString* urlStr = [NSString stringWithFormat:@"%@%@?cid=%ld",BASE_URL,API_CUSTOMER_INFO_SAVE,_customer.id];
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
                    //                    NSNotification *notice = [NSNotification notificationWithName:@"updateContact" object:nil];
                    //                    [[NSNotificationCenter defaultCenter]postNotification:notice];
                    [_dbUtil updateCustomer:_customer];
                    _hud.label.text = @"修改成功";
                    if (self.navigationController.viewControllers.count <= 1) {
                        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
                    } else {
                        [self.navigationController popViewControllerAnimated:YES];
                    }
                }else{
                    _hud.label.text = @"修改失败";
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
