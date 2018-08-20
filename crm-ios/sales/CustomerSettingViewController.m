//
//  CustomerSettingViewController.m
//  sales
//
//  Created by user on 2017/2/24.
//  Copyright © 2017年 rayootech. All rights reserved.
//

#import "CustomerSettingViewController.h"
#import "CustomerSetting.h"
#import "History.h"

@interface CustomerSettingViewController ()

@property (nonatomic,weak) IBOutlet UILabel *ownerLabel;
@property (nonatomic,weak) IBOutlet UILabel *createtimeLabel;
@property (nonatomic,weak) IBOutlet UILabel *moditytimeLabel;
@property (nonatomic,weak) IBOutlet UILabel *historyLabel;

@property (nonatomic, strong) MBProgressHUD *hud;

@end

@implementation CustomerSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"设置";
    _historyLabel.text = @"   ";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)setCustomer:(Customer *)customer{
    _customer = customer;
    [self getSettingData];
}

- (void)setupData:(CustomerSetting *)setting{
    _ownerLabel.text = setting.owner;
    _createtimeLabel.text = setting.createtime;
    _moditytimeLabel.text = setting.modifytime;
    NSArray *historyList = setting.historyList;
    for (int i = 0; i < historyList.count; i++) {
        History *history = historyList[i];
        NSString *str = @"";
        str = [str stringByAppendingString:history.username];
        NSString *time = [history.histime substringToIndex:10];
        str = [str stringByAppendingString:@"  "];
        str = [str stringByAppendingString:time];
        _historyLabel.text = str;
    }
}

- (void)getSettingData{
    _hud = [Utils createHUD];
    NSString *userId = [NSString stringWithFormat:@"%ld",[Config getOrgUserID]];;
    NSString *token = [Config getToken];
    NSString *dbid = [NSString stringWithFormat:@"%ld",[Config getDbID]];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    NSLog(@"data---%ld",_customer.id);
    NSString* urlStr = [NSString stringWithFormat:@"%@%@",BASE_URL,API_CUSTOMER_SETTING_GET];
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
                    CustomerSetting *setting = [CustomerSetting mj_objectWithKeyValues:dictionary[@"data"]];
                    [self setupData:setting];
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
@end
