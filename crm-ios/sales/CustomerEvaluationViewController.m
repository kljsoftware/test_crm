//
//  CustomerEvaluationViewController.m
//  sales
//
//  Created by user on 2017/2/24.
//  Copyright © 2017年 rayootech. All rights reserved.
//

#import "CustomerEvaluationViewController.h"
#import "Evaluation.h"

@interface CustomerEvaluationViewController ()

@property (nonatomic,weak) IBOutlet UITextField *positionField;
@property (nonatomic,weak) IBOutlet UITextField *keyField;
@property (nonatomic,weak) IBOutlet UITextField *persionalityField;
@property (nonatomic,weak) IBOutlet UITextField *closeField;
@property (nonatomic,weak) IBOutlet UITextField *historyField;
@property (nonatomic,weak) IBOutlet UITextField *activityField;
@property (nonatomic,weak) IBOutlet UITextField *signField;
@property (nonatomic,weak) IBOutlet UITextField *amountField;
@property (nonatomic,weak) IBOutlet UITextField *compliantField;
@property (nonatomic,weak) IBOutlet UITextField *percentageField;

@property (nonatomic, strong) MBProgressHUD *hud;

@end

@implementation CustomerEvaluationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"社交账号";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(saveButtonClicked)];
    [self getEvaluationData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)setupData:(Evaluation *)evaluation{
    _positionField.text = evaluation.position;
    _keyField.text = evaluation.key;
    _persionalityField.text = evaluation.personality;
    _closeField.text = evaluation.close;
    _historyField.text = evaluation.history;
    _activityField.text = evaluation.activity;
    _signField.text = evaluation.sign;
    _amountField.text = evaluation.amount;
    _compliantField.text = evaluation.complaint;
    _percentageField.text = evaluation.percentage;
}
- (void)getEvaluationData{
    _hud = [Utils createHUD];
    NSString *userId = [NSString stringWithFormat:@"%ld",[Config getOrgUserID]];;
    NSString *token = [Config getToken];
    NSString *dbid = [NSString stringWithFormat:@"%ld",[Config getDbID]];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    NSLog(@"data---%ld",_customer.id);
    NSString* urlStr = [NSString stringWithFormat:@"%@%@",BASE_URL,API_CUSTOMER_EVALUATION_GET];
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"POST" URLString:urlStr parameters:@{@"id":[NSString stringWithFormat:@"%ld",_customer.id]}                                                                                    error:nil];
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
//                    _hud.label.text = @"录入成功";
                    [_hud hideAnimated:YES afterDelay:1];
                    Evaluation *eva = [Evaluation mj_objectWithKeyValues:dictionary[@"data"]];
                    [self setupData:eva];
                }else{
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

- (void)saveButtonClicked{
    Evaluation *evaluation = [[Evaluation alloc] init];
    evaluation.position = _positionField.text;
    evaluation.key = _keyField.text;
    evaluation.personality = _persionalityField.text;
    evaluation.close = _closeField.text;
    evaluation.history = _historyField.text;
    evaluation.activity = _activityField.text;
    evaluation.sign = _signField.text;
    evaluation.amount = _amountField.text;
    evaluation.complaint = _compliantField.text;
    evaluation.percentage = _percentageField.text;
    
    NSDictionary *contactinfo = evaluation.mj_keyValues;
    _hud = [Utils createHUD];
    _hud.label.text = @"修改中";
    NSString *userId = [NSString stringWithFormat:@"%ld",[Config getOrgUserID]];;
    NSString *token = [Config getToken];
    NSString *dbid = [NSString stringWithFormat:@"%ld",[Config getDbID]];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    NSString* urlStr = [NSString stringWithFormat:@"%@%@?cid=%ld",BASE_URL,API_CUSTOMER_EVALUATION_SAVE,_customer.id];
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
                
                    _hud.label.text = @"修改成功";
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
