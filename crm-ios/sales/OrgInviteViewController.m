//
//  OrgInviteViewController.m
//  sales
//
//  Created by user on 2017/1/11.
//  Copyright © 2017年 rayootech. All rights reserved.
//

#import "OrgInviteViewController.h"
#import "Contact.h"
#import "OrgUserInfo.h"

@interface OrgInviteViewController () <UITextFieldDelegate>
@property (nonatomic,weak) IBOutlet UITextField     *searchText;
@property (nonatomic,weak) IBOutlet UIView          *resultView;
@property (nonatomic,weak) IBOutlet UILabel         *nameLabel;
@property (nonatomic,weak) IBOutlet UIImageView     *avatarImage;
@property (nonatomic,weak) IBOutlet UIButton        *addButton;
@property (nonatomic,strong) MBProgressHUD          *hud;
@property (nonatomic,strong) Contact                *contact;
@end

@implementation OrgInviteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"组织邀请";
    _searchText.delegate = self;
    _resultView.hidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)setOrganizations:(Organizations *)organizations{
    _organizations = organizations;
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
    NSString *dbid = [NSString stringWithFormat:@"%ld",_organizations.id];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    
    NSString* urlStr = [NSString stringWithFormat:@"%@%@",BASE_URL,API_ORGUSER_SEARCH];
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"POST" URLString:urlStr parameters:@{@"mobile":number,@"dbid":dbid}                                                                                    error:nil];
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
                        _hud.label.text = @"不能邀请自己";
                        [_hud hideAnimated:YES afterDelay:1];
                        return ;
                    }
                    _resultView.hidden = NO;
                    
                    [_avatarImage loadPortrait:_contact.avatar];
                    _nameLabel.text = _contact.name;
                }else{
                    if ([dictionary[@"result"] intValue] == 0 || [dictionary[@"result"] intValue] == 110) {
                        _hud.label.text = @"无结果";
                    }else if([dictionary[@"result"] intValue] == 119){
                        _hud.label.text = @"已经是在该组织";
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

- (IBAction)inviteUser{
    NSString *number = _contact.mobile;
    if ([NSStringUtils isEmpty:number]) {
        return;
    }
    number = [number stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *userId = [NSString stringWithFormat:@"%lld",[Config getOwnID]];;
    NSString *token = [Config getToken];
    NSString *dbid = [NSString stringWithFormat:@"%ld",_organizations.id];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    
    NSString* urlStr = [NSString stringWithFormat:@"%@%@",BASE_URL,API_ORG_INVITE];
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"POST" URLString:urlStr parameters:@{@"mobile":number,@"dbid":dbid,@"userId":userId}                                                                                    error:nil];
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
                    
                    dispatch_async(dispatch_get_global_queue(0, 0), ^{
                        dispatch_async(dispatch_get_main_queue(), ^{
                            _addButton.enabled = NO;
                            _addButton.titleLabel.text = @"等待验证";
                            [_addButton setTitle:@"等待验证" forState:UIControlStateNormal];
                        });
                    });
                }else{
                    
                }
            }else{
                
            }
        }
    }];
    [dataTask resume];

}
@end
