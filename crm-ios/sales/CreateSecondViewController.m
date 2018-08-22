//
//  CreateSecondViewController.m
//  sales
//
//  Created by user on 2017/4/18.
//  Copyright © 2017年 rayootech. All rights reserved.
//

#import "CreateSecondViewController.h"

@interface CreateSecondViewController ()

@property (nonatomic,weak) IBOutlet UITextField                  *nameText;
@property (nonatomic,strong) MBProgressHUD              *hud;

@end

@implementation CreateSecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"创建二级部门";
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(finishButtonClick)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setDept:(Dept *)dept{
    _dept = dept;
}

- (void)finishButtonClick{
    NSString *name = _nameText.text;
    _hud = [Utils createHUD];
    if ([NSStringUtils isEmpty:name]) {
        _hud.label.text = @"名称不能为空";
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
    
    NSString* urlStr = [NSString stringWithFormat:@"%@%@",BASE_URL,API_DEPT_ADD];
    
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"POST" URLString:urlStr parameters:@{@"parentid":[NSString stringWithFormat:@"%ld",_dept.id],@"departname":name}                                                                                    error:nil];
    [request addValue:userId forHTTPHeaderField:@"userId"];
    [request addValue:token forHTTPHeaderField:@"token"];
    [request addValue:dbid forHTTPHeaderField:@"dbid"];
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id _Nonnull responseObject, NSError *error) {
        if (error) {
            _hud.label.text = @"请检查网络";
            [_hud hideAnimated:YES afterDelay:1];
        } else {
            NSString *responseString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            NSLog(@"DATA-->%@", responseString);
            if (responseObject) {
                NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
                if ([dictionary[@"result"] intValue] == 1) {
                    _hud.label.text = @"创建成功";
                    [_hud hideAnimated:YES afterDelay:1];
                    NSNotification *notice = [NSNotification notificationWithName:@"refreshSecondDept" object:nil];
                    [[NSNotificationCenter defaultCenter]postNotification:notice];
                    if (self.navigationController.viewControllers.count <= 1) {
                        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
                    } else {
                        [self.navigationController popViewControllerAnimated:YES];
                    }
                }else{
                    _hud.label.text = @"创建失败";
                    [_hud hideAnimated:YES afterDelay:1];
                }
            }else{
                
            }
        }
    }];
    [dataTask resume];
}


@end
