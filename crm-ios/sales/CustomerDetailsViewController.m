//
//  CustomerDetailsViewController.m
//  sales
//
//  Created by user on 2017/2/16.
//  Copyright © 2017年 rayootech. All rights reserved.
//

#import "CustomerDetailsViewController.h"
#import "CustomerEditViewController.h"
#import "CustomerDeepViewController.h"
#import "NSStringUtils.h"
#import "UIColor+Util.h"
#import "Config.h"
#import "Utils.h"
#import "SalesApi.h"
#import "CustomerDbUtil.h"
#import <AFNetworking.h>
#import <SDAutoLayout.h>
#import <MBProgressHUD.h>
@interface CustomerDetailsViewController () <CustomerEditDelegate>

@property (weak,nonatomic) IBOutlet UILabel *nameLabel;
@property (weak,nonatomic) IBOutlet UILabel *titleLabel;
@property (weak,nonatomic) IBOutlet UILabel *deptLabel;
@property (weak,nonatomic) IBOutlet UILabel *mobileLabel;
@property (weak,nonatomic) IBOutlet UILabel *telLabel;
@property (weak,nonatomic) IBOutlet UILabel *mailLabel;
@property (weak,nonatomic) IBOutlet UILabel *addressLabel;
@property (weak,nonatomic) IBOutlet UILabel *webLabel;
@property (weak,nonatomic) IBOutlet UILabel *remarkLabel;
@property (weak,nonatomic) IBOutlet UIView *bottomView;

@property (weak,nonatomic) IBOutlet UILabel *webText;
@property (weak,nonatomic) IBOutlet UILabel *remakText;
@property (weak,nonatomic) IBOutlet UILabel *addressText;

@property (nonatomic,strong) UIView         *deepView;
@property (nonatomic,strong) UIImageView    *deepImage;
@property (nonatomic,strong) UILabel        *deepLabel;
@property (nonatomic,strong) UIView         *deepLine;

@property (nonatomic,strong) UIButton       *deleteButton;
@property (nonatomic,strong) MBProgressHUD  *hud;
@property (nonatomic,strong) CustomerDbUtil *dbUtil;
@end

@implementation CustomerDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _dbUtil = [[CustomerDbUtil alloc] init];
    self.title = @"客户详情";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(editButtonClicked)];
    [self initView];
}

- (void)initView{
//    _deepView = [[UIView alloc] initWithFrame:CGRectMake(0, 356, 450, 41)];
    _deepView = [[UIView alloc] init];
    [_bottomView addSubview:_deepView];
    
    UILongPressGestureRecognizer *gesturRecognizer=[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(deepCustomer:)];
    gesturRecognizer.minimumPressDuration = 0;
    [_deepView addGestureRecognizer:gesturRecognizer];
    
    _deepView.sd_layout
    .topSpaceToView(_remarkLabel,16).heightIs(41).widthIs(450);
    
    _deepLabel = [UILabel new];
    _deepLabel.text = @"客户深度管理";
    _deepLabel.font = [UIFont systemFontOfSize:15];
    [_deepView addSubview:_deepLabel];
    _deepLabel.sd_layout
    .topSpaceToView(_deepView,10).leftSpaceToView(_deepView,20).widthIs(120).heightIs(20);
    
//    _deepLine = [[UIView alloc] initWithFrame:CGRectMake(0, 397, 450, 1)];
    _deepLine = [[UIView alloc] init];
    _deepLine.backgroundColor = [UIColor lineColor];
    [_deepView addSubview:_deepLine];
    _deepLine.sd_layout
    .topSpaceToView(_deepView,40).heightIs(1).widthIs(450);
    
    _deleteButton = [UIButton new];
    [_deleteButton setTitle:@"删除" forState:UIControlStateNormal];
    _deleteButton.backgroundColor = [UIColor redColor];
    [_deleteButton addTarget:self action:@selector(deleteAlert) forControlEvents:UIControlEventTouchUpInside];
    _deleteButton.sd_cornerRadius = [NSNumber numberWithInt:6];
    [_bottomView addSubview:_deleteButton];
    _deleteButton.sd_layout
    .topSpaceToView(_deepView,10)
    .leftSpaceToView(_bottomView,20)
    .rightSpaceToView(_bottomView,20)
    .heightIs(40);
}

- (void)setCustomer:(Customer *)customer{
    _customer = customer;
    [self setUpData];
}
- (void)setUpData{
//    _addressLabel.sd_layout.maxHeightIs(MAXFLOAT);
    if ([NSStringUtils isEmpty:_customer.name])
        _nameLabel.text = @"  ";
    else
        _nameLabel.text = _customer.name;
    
    if([NSStringUtils isEmpty:_customer.title])
        _titleLabel.text = @"  ";
    else
        _titleLabel.text = _customer.title;
    
    if ([NSStringUtils isEmpty:_customer.department]) {
        _deptLabel.text = @"  ";
    }else{
        _deptLabel.text = _customer.department;
    }
    
    if ([NSStringUtils isEmpty:_customer.mobile]) {
        _mobileLabel.text = @"  ";
    }else{
        _mobileLabel.text = _customer.mobile;
    }
    
    if ([NSStringUtils isEmpty:_customer.tel]) {
        _telLabel.text = @"  ";
    }else{
        _telLabel.text = _customer.tel;
    }
    
    if ([NSStringUtils isEmpty:_customer.mail]) {
        _mailLabel.text = @"  ";
    }else{
        _mailLabel.text = _customer.mail;
    }
    
    if ([NSStringUtils isEmpty:_customer.address]) {
        _addressLabel.text = @"  ";
    }else{
        _addressLabel.text = _customer.address;
    }
    
    if ([NSStringUtils isEmpty:_customer.website]) {
        _webLabel.text = @"  ";
    }else{
        _webLabel.text = _customer.website;
    }
    
    if ([NSStringUtils isEmpty:_customer.remark]) {
        _remarkLabel.text = @"  ";
    }else{
        _remarkLabel.text = _customer.remark;
    }
    
    _webText.sd_layout.topSpaceToView(_addressLabel, 15);
    _remakText.sd_layout.topSpaceToView(_webLabel, 15);
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)editButtonClicked{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Customer" bundle:nil];
    CustomerEditViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"CustomerEdit"];
    vc.hidesBottomBarWhenPushed = YES;
    vc.view.backgroundColor = [UIColor whiteColor];
    vc.customer = _customer;
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)customerEdit:(Customer *)customer{
    [self setCustomer:customer];
}

- (void)deepCustomer:(UITapGestureRecognizer *)rec{
    if (rec.state == UIGestureRecognizerStateBegan) {
        
    }else if(rec.state == UIGestureRecognizerStateEnded){
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Customer" bundle:nil];
        
        CustomerDeepViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"CustomerDeep"];
        vc.hidesBottomBarWhenPushed = YES;
        vc.view.backgroundColor = [UIColor whiteColor];
        vc.customer = _customer;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)deleteAlert{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"删除" message:@"确定要删除该客户吗？" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *sure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self deleteCustomer];
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alert addAction:sure];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:^{}];
}

- (void)deleteCustomer{
    _hud = [Utils createHUD];
    NSString *userId = [NSString stringWithFormat:@"%ld",[Config getOrgUserID]];;
    NSString *token = [Config getToken];
    NSString *dbid = [NSString stringWithFormat:@"%ld",[Config getDbID]];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    
    NSString* urlStr = [NSString stringWithFormat:@"%@%@",BASE_URL,API_CUSTOMER_DELETE];
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"POST" URLString:urlStr parameters:@{@"tel":_customer.mobile,@"did":[NSString stringWithFormat:@"%ld",_customer.id]}                                                                                    error:nil];
    [request addValue:userId forHTTPHeaderField:@"userId"];
    [request addValue:token forHTTPHeaderField:@"token"];
    [request addValue:dbid forHTTPHeaderField:@"dbid"];
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id _Nonnull responseObject, NSError *error) {
        if (error) {
            NSLog(@"Error:-->%@", error);
            _hud.label.text = @"检测网络";
            [_hud hideAnimated:YES afterDelay:1];
        } else {
            NSString *responseString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            NSLog(@"DATA-->%@", responseString);
            if (responseObject) {
                NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
                if ([dictionary[@"result"] intValue] == 1) {
                    [_dbUtil deleteCustomerById:_customer.id];
                    _hud.label.text = @"删除成功";
                    [_hud hideAnimated:YES afterDelay:1];
                    NSNotification *notice = [NSNotification notificationWithName:@"updateCustomer" object:nil];
                    [[NSNotificationCenter defaultCenter]postNotification:notice];
                    if (self.navigationController.viewControllers.count <= 1) {
                        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
                    } else {
                        [self.navigationController popViewControllerAnimated:YES];
                    }

                }else{
                    _hud.label.text = @"删除失败，您可能不是该客户拥有者";
                    [_hud hideAnimated:YES afterDelay:1];
                }
            }else{
                _hud.label.text = @"删除失败，您可能不是该客户拥有者";
                [_hud hideAnimated:YES afterDelay:1];
            }
        }
    }];
    [dataTask resume];
}
@end

