//
//  CustomerSocialViewController.m
//  sales
//
//  Created by user on 2017/2/23.
//  Copyright © 2017年 rayootech. All rights reserved.
//

#import "CustomerSocialViewController.h"
#import "Social.h"

@interface CustomerSocialViewController ()

@property (nonatomic,weak) IBOutlet UITextField *wechatField;
@property (nonatomic,weak) IBOutlet UITextField *qqField;
@property (nonatomic,weak) IBOutlet UITextField *weiboField;
@property (nonatomic,weak) IBOutlet UITextField *skypeField;
@property (nonatomic,weak) IBOutlet UITextField *linkedinField;
@property (nonatomic,weak) IBOutlet UITextField *emailField;
@property (nonatomic,weak) IBOutlet UITextField *maimaiField;
@property (nonatomic,weak) IBOutlet UITextField *tianjiField;
@property (nonatomic,weak) IBOutlet UITextField *bokeField;
@property (nonatomic,strong) NSMutableArray     *dataModels;
@property (nonatomic, strong) MBProgressHUD *hud;

@end

@implementation CustomerSocialViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"社交账号";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(saveButtonClicked)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)setupData{
    if (self.dataModels.count <= 0) {
        return;
    }
    for (int i = 0; i < self.dataModels.count; i++) {
        Social *social = self.dataModels[i];
        NSInteger type = social.type;
        switch (type) {
            case 1:
                _wechatField.text = social.account;
                break;
            case 2:
                _qqField.text = social.account;
                break;
            case 3:
                _weiboField.text = social.account;
                break;
            case 4:
                _skypeField.text = social.account;
                break;
            case 5:
                _linkedinField.text = social.account;
                break;
            case 6:
                _emailField.text = social.account;
                break;
            case 7:
                _maimaiField.text = social.account;
                break;
            case 8:
                _tianjiField.text = social.account;
                break;
            case 9:
                _bokeField.text = social.account;
                break;
            default:
                break;
        }
    }
}

- (void)setCustomer:(Customer *)customer{
    _customer = customer;
    [self getSocialData];
}
- (void)getSocialData{
    _hud = [Utils createHUD];
    NSString *userId = [NSString stringWithFormat:@"%ld",[Config getOrgUserID]];;
    NSString *token = [Config getToken];
    NSString *dbid = [NSString stringWithFormat:@"%ld",[Config getDbID]];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    
    NSString* urlStr = [NSString stringWithFormat:@"%@%@",BASE_URL,API_CUSTOMER_SOCIAL_GET];
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"POST" URLString:urlStr parameters:@{@"cid":[NSString stringWithFormat:@"%ld",_customer.id]}                                                                                    error:nil];
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
                    [_hud hideAnimated:YES afterDelay:1];
                    NSArray* data = dictionary[@"data"];
                    NSArray* modelArray = [Social mj_objectArrayWithKeyValuesArray:data];
                    [self.dataModels addObjectsFromArray:modelArray];
                    [self setupData];
                }else{
                    [_hud hideAnimated:YES afterDelay:1];
                }
            }else{
                [_hud hideAnimated:YES afterDelay:1];
            }
        }
    }];
    [dataTask resume];
}
- (void)saveButtonClicked{
    
    NSMutableDictionary *typeaccount = [[NSMutableDictionary alloc] init];
    NSMutableArray *array = [[NSMutableArray alloc] init];
    Social *wechat = [[Social alloc] init];
    
    wechat.account = _wechatField.text;
    wechat.typename = @"WeChat";
    [array addObject:wechat.mj_keyValues];
    
    Social *qq = [[Social alloc] init];
    qq.account = _qqField.text;
    qq.typename = @"QQ";
    [array addObject:qq.mj_keyValues];
    
    Social *weibo = [[Social alloc] init];
    weibo.account = _weiboField.text;
    weibo.typename = @"weibo";
    [array addObject:weibo.mj_keyValues];
    
    Social *skype = [[Social alloc] init];
    skype.account = _skypeField.text;
    skype.typename = @"Skype";
    [array addObject:skype.mj_keyValues];
    
    Social *linked = [[Social alloc] init];
    linked.account = _linkedinField.text;
    linked.typename = @"Linkedin";
    [array addObject:linked.mj_keyValues];
    
    Social *email = [[Social alloc] init];
    email.account = _emailField.text;
    email.typename = @"Email";
    [array addObject:email.mj_keyValues];
    
    Social *momo = [[Social alloc] init];
    momo.account = _maimaiField.text;
    momo.typename = @"momo";
    [array addObject:momo.mj_keyValues];
    
    Social *tianji = [[Social alloc] init];
    tianji.account = _tianjiField.text;
    tianji.typename = @"tianji";
    [array addObject:tianji.mj_keyValues];
    
    Social *boke = [[Social alloc] init];
    boke.account = _bokeField.text;
    boke.typename = @"boke";
    [array addObject:boke.mj_keyValues];
    [typeaccount setValue:array forKey:@"typeaccount"];
    
    _hud = [Utils createHUD];
    _hud.label.text = @"修改中";
    NSString *userId = [NSString stringWithFormat:@"%ld",[Config getOrgUserID]];;
    NSString *token = [Config getToken];
    NSString *dbid = [NSString stringWithFormat:@"%ld",[Config getDbID]];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    NSString* urlStr = [NSString stringWithFormat:@"%@%@?cid=%ld",BASE_URL,API_CUSTOMER_SOCIAL_EDIT,_customer.id];
    NSMutableURLRequest *request = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:urlStr parameters:typeaccount                                                                                   error:nil];
    
    [request addValue:userId forHTTPHeaderField:@"userId"];
    [request addValue:token forHTTPHeaderField:@"token"];
    [request addValue:dbid forHTTPHeaderField:@"dbid"];
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id _Nonnull responseObject, NSError *error) {
        if (error) {
            NSLog(@"error-%@",error);
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

- (NSMutableArray *)dataModels {
    if(_dataModels == nil) {
        _dataModels = [NSMutableArray array];
    }
    return _dataModels;
}
@end
