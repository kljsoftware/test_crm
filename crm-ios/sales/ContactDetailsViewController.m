//
//  ContactDetailsViewController.m
//  sales
//
//  Created by user on 2016/12/5.
//  Copyright © 2016年 rayootech. All rights reserved.
//

#import "ContactDetailsViewController.h"
#import "SalesDbUtil.h"

@interface ContactDetailsViewController () <UITextFieldDelegate>

@property (nonatomic,strong) SalesDbUtil *dbUtil;
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
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;
@property (nonatomic, strong) MBProgressHUD *hud;

@end

@implementation ContactDetailsViewController
-(instancetype)initWithContact:(Contact *)contact{
    self = [super init];
    if (self) {
        _contact = contact;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"联系人详情";
    self.view.backgroundColor = UIColor.whiteColor;
    self.deleteBtn.layer.cornerRadius = 5;
    self.deleteBtn.layer.masksToBounds = true;
    
    _dbUtil = [[SalesDbUtil alloc] init];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(saveButtonClicked)];
    
    [self setUpData];
}

- (void)saveButtonClicked {
    Contact *contact = [Contact new];
    _contact.id = _contact.id;
    _contact.fid = _contact.fid;
    _contact.name = _nameField.text;
    _contact.orgname = _organizationField.text;
    _contact.dept = _deptField.text;
    _contact.title = _titleField.text;
    _contact.mobile = _mobileField.text;
    _contact.tel = _telField.text;
    _contact.address = _addressField.text;
    _contact.website = _websiteField.text;
    _contact.remark = _remarkField.text;
    _contact.mail = _mailField.text;
    
    NSDictionary *contactinfo = contact.mj_keyValues;
    _hud = [Utils createHUD];
    _hud.label.text = @"修改中";
    NSString *userId = [NSString stringWithFormat:@"%lld",[Config getOwnID]];;
    NSString *token = [Config getToken];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    NSString* urlStr = [NSString stringWithFormat:@"%@%@?contactInfoId=%ld",BASE_URL,API_CONTACT_EDIT,_contact.id];
    NSMutableURLRequest *request = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:urlStr parameters:contactinfo                                                                                   error:nil];
    
    [request addValue:userId forHTTPHeaderField:@"userId"];
    [request addValue:token forHTTPHeaderField:@"token"];
    
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
                    NSNotification *notice = [NSNotification notificationWithName:@"updateContact" object:nil];
                    [[NSNotificationCenter defaultCenter]postNotification:notice];
                    [_dbUtil updateContact:_contact];
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

- (void)setUpData{
    _nameField.text = _contact.name;
    _organizationField.text = _contact.orgname;
    _deptField.text = _contact.dept;
    _titleField.text = _contact.title;
    _telField.text = _contact.tel;
    _mobileField.text = _contact.mobile;
    _websiteField.text = _contact.website;
    _addressField.text = _contact.address;
    _remarkField.text = _contact.remark;
    _mailField.text = _contact.mail;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self textFieldDone];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    return [textField resignFirstResponder];
}

- (void)textFieldDone {
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
}

- (IBAction)deleteAlert {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"删除" message:@"确定要删除该联系人吗？" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *sure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self deleteContact];
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alert addAction:sure];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:^{}];
}

- (void)deleteContact {
    _hud = [Utils createHUD];
    _hud.label.text = @"删除中";
    NSString *userId = [NSString stringWithFormat:@"%lld",[Config getOwnID]];;
    NSString *token = [Config getToken];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    NSString* urlStr = [NSString stringWithFormat:@"%@%@",BASE_URL,API_CONTACT_DELETE];
   
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"POST" URLString:urlStr parameters:@{@"id":[NSString stringWithFormat:@"%ld",_contact.id]}                                                                                    error:nil];
    [request addValue:userId forHTTPHeaderField:@"userId"];
    [request addValue:token forHTTPHeaderField:@"token"];
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id _Nonnull responseObject, NSError *error) {
        if (error) {
            _hud.label.text = @"网络错误";
            [_hud hideAnimated:YES afterDelay:1];
        } else {
            NSString *responseString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            NSLog(@"DATA-->%@", responseString);
            if (responseObject) {
                NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
                if ([dictionary[@"result"] intValue] == 1 || [dictionary[@"result"] intValue] == 2) {
                    [_dbUtil deleteContactById:_contact.id];
                    _hud.label.text = @"删除成功";
                    [_hud hideAnimated:YES afterDelay:1];
                    if (_contact.fid != 0) {
                        [[RCIMClient sharedRCIMClient] addToBlacklist:[@"out_" stringByAppendingString:[NSString stringWithFormat:@"%ld",_contact.fid]] success:^{
                            NSLog(@"toblacklistsuccess");
                        } error:^(RCErrorCode status) {
                            
                        }];
                    }
                    NSNotification *notice = [NSNotification notificationWithName:@"deleteContact" object:nil];
                    [[NSNotificationCenter defaultCenter]postNotification:notice];
                    if (self.navigationController.viewControllers.count <= 1) {
                        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
                    } else {
                        [self.navigationController popViewControllerAnimated:YES];
                    }
                }else{
                    _hud.label.text = @"删除失败";
                }
            }else{
                _hud.label.text = @"删除失败";
            }
            [_hud hideAnimated:YES afterDelay:1];
        }
    }];
    [dataTask resume];
}
@end
