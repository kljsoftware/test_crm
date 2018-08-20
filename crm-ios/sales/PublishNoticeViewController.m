//
//  PublishNoticeViewController.m
//  sales
//
//  Created by user on 2017/2/27.
//  Copyright © 2017年 rayootech. All rights reserved.
//

#import "PublishNoticeViewController.h"
#import "PlaceholderTextView.h"

@interface PublishNoticeViewController () <UITextFieldDelegate>

@property (nonatomic,weak) IBOutlet UITextField         *titleField;
@property (nonatomic,weak) IBOutlet UILabel             *countLabel;
@property (nonatomic,weak) IBOutlet PlaceholderTextView *contentText;

@property (nonatomic,strong) MBProgressHUD *hud;
@end

@implementation PublishNoticeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"创建公告";
    _contentText.placeholder = @"创建公告内容";
    _titleField.delegate = self;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"创建" style:UIBarButtonItemStylePlain target:self action:@selector(createButtonClicked)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    NSString *count = nil;
    
    NSString *toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    if (toBeString.length >= 15) {
        textField.text = [toBeString substringToIndex:15];
        count = @"15";
        _countLabel.text = @"15/15";
        return NO;
    }
    count = [[NSString stringWithFormat:@"%ld",toBeString.length] stringByAppendingString:@"/15"];
    _countLabel.text = count;
    return YES;
}

- (void)createButtonClicked{
    _hud = [Utils createHUD];

    NSString *title = _titleField.text;
    if ([NSStringUtils isEmpty:title]) {
        _hud.label.text = @"标题不能为空";
        [_hud hideAnimated:YES afterDelay:1];
        return;
    }
    NSString *content = _contentText.text;
    if ([NSStringUtils isEmpty:content]) {
        _hud.label.text = @"内容不能为空";
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
    
    NSString* urlStr = [NSString stringWithFormat:@"%@%@",BASE_URL,API_NOTICE_PUBLISH];
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"POST" URLString:urlStr parameters:@{@"title":title,@"content":content}                                                                                    error:nil];
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
                    _hud.label.text = @"创建成功";
                    [_hud hideAnimated:YES afterDelay:1];
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
                _hud.label.text = @"创建失败";
                [_hud hideAnimated:YES afterDelay:1];
            }
        }
    }];
    [dataTask resume];
}
@end
