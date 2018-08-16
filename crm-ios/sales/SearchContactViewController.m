//
//  SearchFriendViewController.m
//  sales
//
//  Created by user on 2016/12/12.
//  Copyright © 2016年 rayootech. All rights reserved.
//

#import "SearchContactViewController.h"
#import "NSStringUtils.h"
#import "Config.h"
#import "SalesApi.h"
#import "Config.h"
#import "Utils.h"
#import "Contact.h"
#import "UIImageView+Util.h"
#import <AFNetworking.h>
#import <MBProgressHUD.h>
#import <MJExtension.h>
#import <RongIMKit/RongIMKit.h>
@interface SearchContactViewController () <UITextFieldDelegate>
@property (nonatomic,weak) IBOutlet UITextField     *searchText;
@property (nonatomic,weak) IBOutlet UIView          *resultView;
@property (nonatomic,weak) IBOutlet UILabel         *nameLabel;
@property (nonatomic,weak) IBOutlet UIImageView     *avatarImage;
@property (nonatomic,weak) IBOutlet UIButton        *addButton;
@property (nonatomic,strong) MBProgressHUD          *hud;
@property (nonatomic,strong) Contact                *contact;
@end

@implementation SearchContactViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"添加联系人";
    _searchText.delegate = self;
    _resultView.hidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) searchContact{
    _hud = [Utils createHUD];
    NSString *number = _searchText.text;
    if ([NSStringUtils isEmpty:number]) {
        return;
    }
    number = [number stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *userId = [NSString stringWithFormat:@"%lld",[Config getOwnID]];;
    NSString *token = [Config getToken];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    
    NSString* urlStr = [NSString stringWithFormat:@"%@%@",BASE_URL,API_CONTACT_SEARCH];
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"POST" URLString:urlStr parameters:@{@"mobile":number}                                                                                    error:nil];
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
                    _contact = [Contact mj_objectWithKeyValues:dictionary[@"data"]];
                    if (_contact.id == [Config getOwnID]) {
                        _hud.label.text = @"不能添加自己";
                        [_hud hideAnimated:YES afterDelay:1];
                        return ;
                    }
                    _resultView.hidden = NO;
                    [_avatarImage loadPortrait:_contact.avatar];
                    _nameLabel.text = _contact.name;
                }else{
                    if ([dictionary[@"result"] intValue] == 0 || [dictionary[@"result"] intValue] == 110) {
                        _hud.label.text = @"无结果";
                    }else if([dictionary[@"result"] intValue] == 109){
                        _hud.label.text = @"已经是好友";
                    }
                }
            }else{
                _hud.label.text = @"查找失败";
            }
            [_hud hideAnimated:YES afterDelay:1];
        }
    }];
    [dataTask resume];

}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if ([string isEqualToString: @"\n"]) {
        [self searchContact];
        return NO;
    }
    return YES;
}
- (IBAction)addContact{
    [[RCIMClient sharedRCIMClient] removeFromBlacklist:[@"out_" stringByAppendingString:[NSString stringWithFormat:@"%ld",_contact.id]] success:^{
        [self reqFriend];
    } error:^(RCErrorCode status) {
        
    }];
}

- (void)reqFriend{
    NSString *fid = [NSString stringWithFormat:@"%ld",_contact.id];
    
    NSString *userId = [NSString stringWithFormat:@"%lld",[Config getOwnID]];;
    NSString *token = [Config getToken];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    
    NSString* urlStr = [NSString stringWithFormat:@"%@%@",BASE_URL,API_REQ_ADD_FRIEND];
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"POST" URLString:urlStr parameters:@{@"fid":fid,@"userId":userId}                                                                                    error:nil];
    [request addValue:userId forHTTPHeaderField:@"userId"];
    [request addValue:token forHTTPHeaderField:@"token"];
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id _Nonnull responseObject, NSError *error) {
        if (error) {
            NSLog(@"Error:-->%@", error);
        } else {
            NSString *responseString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            NSLog(@"DATA-->%@", responseString);
            if (responseObject) {
                NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
                if ([dictionary[@"result"] intValue] == 1) {
                    [_addButton setTitle:@"等待验证" forState:UIControlStateNormal];
                    [_addButton setEnabled:NO];
                }else{
                    //
                }
            }else{
            }
        }
    }];
    [dataTask resume];
}
@end
