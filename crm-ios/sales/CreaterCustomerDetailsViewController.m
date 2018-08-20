//
//  CreaterCustomerDetailsViewController.m
//  sales
//
//  Created by user on 2017/3/21.
//  Copyright © 2017年 rayootech. All rights reserved.
//

#import "CreaterCustomerDetailsViewController.h"
#import "CustomerDeepViewController.h"
#import "CustomerDupTableViewController.h"
#import "CustomerTransferTableViewController.h"
#import "CustomerDistTableViewController.h"

@interface CreaterCustomerDetailsViewController ()

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

@property (nonatomic,strong) UIView         *lookView;      //查重
@property (nonatomic,strong) UIImageView    *lookImage;
@property (nonatomic,strong) UILabel        *lookLabel;
@property (nonatomic,strong) UIView         *lookLine;

@property (nonatomic,strong) UIView         *transferView;
@property (nonatomic,strong) UIImageView    *transferImage;
@property (nonatomic,strong) UILabel        *transferLabel;
@property (nonatomic,strong) UIView         *transferLine;

@property (nonatomic,strong) UIView         *lockView;
@property (nonatomic,strong) UIImageView    *lockImage;
@property (nonatomic,strong) UILabel        *lockLabel;
@property (nonatomic,strong) UIView         *lockLine;

@property (nonatomic,strong) UIView         *distView;
@property (nonatomic,strong) UIImageView    *distImage;
@property (nonatomic,strong) UILabel        *distLabel;
@property (nonatomic,strong) UIView         *distLine;
@property (nonatomic, strong) MBProgressHUD *hud;
@end

@implementation CreaterCustomerDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"客户详情";
    [self initView];
}

- (void)initView{
    _deepView = [[UIView alloc] init];
    [_bottomView addSubview:_deepView];
    
    UILongPressGestureRecognizer *gesturRecognizer=[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(deepCustomer:)];
    gesturRecognizer.minimumPressDuration = 0;
    [_deepView addGestureRecognizer:gesturRecognizer];
    
    _deepView.sd_layout
    .topSpaceToView(_remarkLabel,16).heightIs(41).widthIs(450);
    
    _deepImage = [UIImageView new];
    _deepImage.image = [UIImage imageNamed:@"customer_deep"];
    [_deepView addSubview:_deepImage];
    _deepImage.sd_layout
    .centerYEqualToView(_deepView).leftSpaceToView(_deepView,20).widthIs(20).heightEqualToWidth();
    
    _deepLabel = [UILabel new];
    _deepLabel.text = @"客户深度管理";
    [_deepView addSubview:_deepLabel];
    _deepLabel.sd_layout
    .topSpaceToView(_deepView,10).leftSpaceToView(_deepImage,10).widthIs(120).heightIs(20);
    
//    _deepLine = [[UIView alloc] initWithFrame:CGRectMake(0, 397, 450, 1)];
    _deepLine = [[UIView alloc] init];
    _deepLine.backgroundColor = [UIColor lightGrayColor];
    [_deepView addSubview:_deepLine];
    _deepLine.sd_layout
    .topSpaceToView(_deepView,40).heightIs(1).widthIs(450);
    
//    _lookView = [[UIView alloc] initWithFrame:CGRectMake(0, 397, 450, 41)];
    _lookView = [[UIView alloc] init];
    [_bottomView addSubview:_lookView];
    
    _lookImage = [UIImageView new];
    _lookImage.image = [UIImage imageNamed:@"customer_look"];
    [_lookView addSubview:_lookImage];
    _lookImage.sd_layout
    .centerYEqualToView(_lookView).leftSpaceToView(_lookView,20).widthIs(20).heightEqualToWidth();
    
    UILongPressGestureRecognizer *lookGesturRecognizer=[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(lookCustomer:)];
    lookGesturRecognizer.minimumPressDuration = 0;
    [_lookView addGestureRecognizer:lookGesturRecognizer];
    
    _lookView.sd_layout
    .topSpaceToView(_deepView,0).heightIs(41).widthIs(450);
    
    _lookLabel = [UILabel new];
    _lookLabel.text = @"客户查重";
    [_lookView addSubview:_lookLabel];
    _lookLabel.sd_layout
    .topSpaceToView(_lookView,10).leftSpaceToView(_lookImage,10).widthIs(120).heightIs(20);
    
//    _lookLine = [[UIView alloc] initWithFrame:CGRectMake(0, 438, 450, 1)];
    _lookLine = [[UIView alloc] init];
    _lookLine.backgroundColor = [UIColor lineColor];
    [_lookView addSubview:_lookLine];
    _lookLine.sd_layout
    .topSpaceToView(_lookView,40).heightIs(1).widthIs(450);
    
    
//    _transferView = [[UIView alloc] initWithFrame:CGRectMake(0, 438, 450, 41)];
    _transferView = [[UIView alloc] init];
    [_bottomView addSubview:_transferView];
    
    _transferImage = [UIImageView new];
    _transferImage.image = [UIImage imageNamed:@"customer_transfer"];
    [_transferView addSubview:_transferImage];
    _transferImage.sd_layout
    .centerYEqualToView(_transferView).leftSpaceToView(_transferView,20).widthIs(20).heightEqualToWidth();
    
    UILongPressGestureRecognizer *transferGesturRecognizer=[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(transferCustomer:)];
    transferGesturRecognizer.minimumPressDuration = 0;
    [_transferView addGestureRecognizer:transferGesturRecognizer];
    
    _transferView.sd_layout
    .topSpaceToView(_lookView,0).heightIs(41).widthIs(450);
    
    _transferLabel = [UILabel new];
    _transferLabel.text = @"客户转移";
    [_transferView addSubview:_transferLabel];
    _transferLabel.sd_layout
    .topSpaceToView(_transferView,10).leftSpaceToView(_transferImage,10).widthIs(120).heightIs(20);
    
//    _transferLine = [[UIView alloc] initWithFrame:CGRectMake(0, 479, 450, 1)];
    _transferLine = [[UIView alloc] init];
    _transferLine.backgroundColor = [UIColor lineColor];
    [_transferView addSubview:_transferLine];
    _transferLine.sd_layout
    .topSpaceToView(_transferView,40).heightIs(1).widthIs(450);
    
//    _lockView = [[UIView alloc] initWithFrame:CGRectMake(0, 479, 450, 41)];
    _lockView = [[UIView alloc] init];
    [_bottomView addSubview:_lockView];
    
    UILongPressGestureRecognizer *lockGesturRecognizer=[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(lockCustomer:)];
    lockGesturRecognizer.minimumPressDuration = 0;
    [_lockView addGestureRecognizer:lockGesturRecognizer];
    
    _lockView.sd_layout
    .topSpaceToView(_transferView,0).heightIs(41).widthIs(450);
    
    _lockImage = [UIImageView new];
    _lockImage.image = [UIImage imageNamed:@"customer_lock"];
    [_lockView addSubview:_lockImage];
    _lockImage.sd_layout
    .centerYEqualToView(_lockView).leftSpaceToView(_lockView,20).widthIs(20).heightEqualToWidth();
    
    _lockLabel = [UILabel new];
    _lockLabel.text = @"锁定";
    [_lockView addSubview:_lockLabel];
    _lockLabel.sd_layout
    .topSpaceToView(_lockView,10).leftSpaceToView(_lockImage,10).widthIs(120).heightIs(20);
    
//    _lockLine = [[UIView alloc] initWithFrame:CGRectMake(0, 479, 450, 1)];
    _lockLine = [[UIView alloc] init];
    _lockLine.backgroundColor = [UIColor lineColor];
    [_lockView addSubview:_lockLine];
    _lockLine.sd_layout
    .topSpaceToView(_lockView,40).heightIs(1).widthIs(450);
    
//    _distView = [[UIView alloc] initWithFrame:CGRectMake(0, 520, 450, 41)];
    _distView = [[UIView alloc] init];
    [_bottomView addSubview:_distView];
    
    _distImage = [UIImageView new];
    _distImage.image = [UIImage imageNamed:@"customer_dist"];
    [_distView addSubview:_distImage];
    _distImage.sd_layout
    .centerYEqualToView(_distView).leftSpaceToView(_distView,20).widthIs(20).heightEqualToWidth();
    
    UILongPressGestureRecognizer *distGesturRecognizer=[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(distCustomer:)];
    distGesturRecognizer.minimumPressDuration = 0;
    [_distView addGestureRecognizer:distGesturRecognizer];
    
    _distView.sd_layout
    .topSpaceToView(_lockView,0).heightIs(41).widthIs(450);
    
    _distLabel = [UILabel new];
    _distLabel.text = @"分配";
    [_distView addSubview:_distLabel];
    _distLabel.sd_layout
    .topSpaceToView(_distView,10).leftSpaceToView(_distImage,10).widthIs(120).heightIs(20);
    
//    _distLine = [[UIView alloc] initWithFrame:CGRectMake(0, 479, 450, 1)];
    _distLine = [[UIView alloc] init];
    _distLine.backgroundColor = [UIColor lineColor];
    [_distView addSubview:_distLine];
    _distLine.sd_layout
    .topSpaceToView(_distView,40).heightIs(1).widthIs(450);
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)setCustomer:(Customer *)customer{
    _customer = customer;
    [self setUpData];
}
- (void)setUpData{
    if ([NSStringUtils isEmpty:_customer.name])
        _nameLabel.text = @"";
    else
        _nameLabel.text = _customer.name;
    
    if([NSStringUtils isEmpty:_customer.title])
        _titleLabel.text = @"";
    else
        _titleLabel.text = _customer.title;
    
    if ([NSStringUtils isEmpty:_customer.department]) {
        _deptLabel.text = @"";
    }else{
        _deptLabel.text = _customer.department;
    }
    
    if ([NSStringUtils isEmpty:_customer.mobile]) {
        _mobileLabel.text = @"";
    }else{
        _mobileLabel.text = _customer.mobile;
    }
    
    if ([NSStringUtils isEmpty:_customer.tel]) {
        _telLabel.text = @"";
    }else{
        _telLabel.text = _customer.tel;
    }
    
    if ([NSStringUtils isEmpty:_customer.mail]) {
        _mailLabel.text = @"";
    }else{
        _mailLabel.text = _customer.mail;
    }
    
    if ([NSStringUtils isEmpty:_customer.address]) {
        _addressLabel.text = @"";
    }else{
        _addressLabel.text = _customer.address;
    }
    
    if ([NSStringUtils isEmpty:_customer.website]) {
        _webLabel.text = @"";
    }else{
        _webLabel.text = _customer.website;
    }
    
    if ([NSStringUtils isEmpty:_customer.remark]) {
        _remarkLabel.text = @"";
    }else{
        _remarkLabel.text = _customer.remark;
    }
    _webText.sd_layout.topSpaceToView(_addressLabel, 15);
    _remakText.sd_layout.topSpaceToView(_webLabel, 15);
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

- (void)lookCustomer:(UITapGestureRecognizer *)rec{
    if (rec.state == UIGestureRecognizerStateBegan) {
        
    }else if(rec.state == UIGestureRecognizerStateEnded){
        CustomerDupTableViewController *vc = [[CustomerDupTableViewController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        vc.view.backgroundColor = [UIColor whiteColor];
        vc.customer = _customer;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)transferCustomer:(UITapGestureRecognizer *)rec{
    if (rec.state == UIGestureRecognizerStateBegan) {
        
    }else if(rec.state == UIGestureRecognizerStateEnded){
        
        CustomerTransferTableViewController *vc = [[CustomerTransferTableViewController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        vc.view.backgroundColor = [UIColor whiteColor];
        vc.customer = _customer;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)lockCustomer:(UITapGestureRecognizer *)rec{
    
    if (rec.state == UIGestureRecognizerStateBegan) {
        
    }else if(rec.state == UIGestureRecognizerStateEnded){
        
        _hud = [Utils createHUD];
        NSString *userId = [NSString stringWithFormat:@"%ld",[Config getOrgUserID]];;
        NSString *token = [Config getToken];
        NSString *dbid = [NSString stringWithFormat:@"%ld",[Config getDbID]];
        
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
        
        NSString* urlStr = [NSString stringWithFormat:@"%@%@",BASE_URL,API_CUSTOMER_LOCK];
        
        NSString *cid = [NSString stringWithFormat:@"%ld",_customer.id];
        NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"POST" URLString:urlStr parameters:@{@"id":cid}                                                                                    error:nil];
        [request addValue:userId forHTTPHeaderField:@"userId"];
        [request addValue:token forHTTPHeaderField:@"token"];
        [request addValue:dbid forHTTPHeaderField:@"dbid"];
        
        NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id _Nonnull responseObject, NSError *error) {
            if (error) {
                _hud.label.text = @"请检测网络";
                [_hud hideAnimated:YES afterDelay:1];
            } else {
                NSString *responseString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
                NSLog(@"DATA-->%@", responseString);
                
                if (responseObject) {
                    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
                    if ([dictionary[@"result"] intValue] == 1) {
                        _hud.label.text = @"锁定成功";
                        [_hud hideAnimated:YES afterDelay:1];
                    }else{
                        _hud.label.text = @"锁定失败";
                        [_hud hideAnimated:YES afterDelay:1];
                    }
                }else{
                    _hud.label.text = @"锁定失败";
                    [_hud hideAnimated:YES afterDelay:1];
                }
                
            }
        }];
        [dataTask resume];
    }
    
}

- (void)distCustomer:(UITapGestureRecognizer *)rec{
    if (rec.state == UIGestureRecognizerStateBegan) {
        
    }else if(rec.state == UIGestureRecognizerStateEnded){
        CustomerDistTableViewController *vc = [[CustomerDistTableViewController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        vc.view.backgroundColor = [UIColor whiteColor];
        vc.customer = _customer;
        [self.navigationController pushViewController:vc animated:YES];
    }
}
@end
