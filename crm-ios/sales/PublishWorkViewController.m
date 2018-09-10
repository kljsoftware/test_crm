//
//  PublishWorkViewController.m
//  sales
//
//  Created by user on 2017/4/6.
//  Copyright © 2017年 rayootech. All rights reserved.
//

#import "PublishWorkViewController.h"
#import "ImagePickerView.h"
#import "PlaceholderTextView.h"
#import "WorkChooseCustomerTableViewController.h"
#import "WorkChooseColleagueTableViewController.h"
#import "Url.h"
#import <CoreLocation/CoreLocation.h>
#import "CustomerDetailsViewController.h"
#import "ColleagueDetailsViewController.h"

#define kScreenWidth        [[UIScreen mainScreen] bounds].size.width
#define kScreenHeight       [[UIScreen mainScreen] bounds].size.height
@interface PublishWorkViewController () <UITextViewDelegate,WorkChooseCustomerCellDelegate,WorkChooseColleaguesCellDelegate,CLLocationManagerDelegate>

@property (weak, nonatomic) IBOutlet UIView *photoView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *photoViewHieghtConstraint;
@property (nonatomic,weak)  IBOutlet PlaceholderTextView *contentView;
@property (nonatomic,weak)  IBOutlet UIView     *photoLine;
@property (nonatomic,strong) ImagePickerView    *pickerView;
@property (nonatomic,strong) UIButton           *button;
@property (nonatomic,assign) NSInteger          count;
@property (nonatomic,strong) MBProgressHUD      *HUD;

@property (nonatomic,strong) UIView             *signView;
@property (nonatomic,strong) UILabel            *signLabel;
@property (nonatomic,strong) UIButton           *localBtn;
@property (nonatomic,strong) UIView             *signLine;

@property (nonatomic,strong) UIView             *dateView;
@property (nonatomic,strong) UILabel            *dateLabel;
@property (nonatomic,strong) UIButton           *dateBtn;
@property (nonatomic,strong) UIView             *dateLine;

@property (nonatomic,strong) UIView         *customerView;
@property (nonatomic,strong) UILabel        *customerLabel;
@property (nonatomic,strong) UIView         *customerHeaderView;

@property (nonatomic,strong) UIView         *colleagueView;
@property (nonatomic,strong) UILabel        *colleagueLabel;
@property (nonatomic,strong) UIView         *colleagueHeaderView;

@property (nonatomic,weak) IBOutlet UIView             *bottomBarView;
@property (nonatomic,weak) IBOutlet NSLayoutConstraint *bottomBarYConstraint;
@property (nonatomic,strong) NSLayoutConstraint *bottomBarHeightConstraint;
@property (nonatomic,strong) NSLayoutConstraint *bottomBarWidthConstraint;

@property (nonatomic,strong) UIAlertController  *dateAlert;
@property (nonatomic,strong) UIDatePicker       *datePicker;

@property (nonatomic,strong) Customer           *customer;
@property (nonatomic, strong) NSArray           *colleagues;
@property (nonatomic,strong) NSString           *stafflist;
@property (nonatomic,strong) CLLocationManager  *locationManager;
@property (nonatomic,strong) NSString           *currentCity;
@end

@implementation PublishWorkViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"工作发布";
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancelButtonClicked)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"发送" style:UIBarButtonItemStylePlain target:self action:@selector(sendItemClicked:)];
    _contentView.delegate = self;
    [self setUpView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    _stafflist = @"";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)setUpView{
    //imagePickerView parameter settings
    _contentView.placeholder = @"工作内容";
    ImagePickerConfig *config = [ImagePickerConfig new];
    config.sectionInset = UIEdgeInsetsMake(20, 20, 20, 20);
    config.minimumLineSpacing = 5;
    config.minimumInteritemSpacing = 5;
    config.itemSize = CGSizeMake((kScreenWidth-40-15)/4, (kScreenWidth-40-15)/4);
    
    ImagePickerView *pickerView = [[ImagePickerView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0) config:config];
    //Height changed with photo selection
    __weak typeof(self) weakSelf = self;
    pickerView.viewHeightChanged = ^(CGFloat height) {
        weakSelf.photoViewHieghtConstraint.constant = height;
        [weakSelf.view setNeedsLayout];
        [weakSelf.view layoutIfNeeded];
    };
    pickerView.currentController = self;
    [self.photoView addSubview:pickerView];
    self.pickerView = pickerView;
    
    //refresh superview height
    [pickerView refreshImagePickerViewWithPhotoArray:nil];
    
    _signView = [[UIView alloc] init];
    [self.view addSubview:_signView];
    
    _signView.sd_layout.topSpaceToView(_photoLine,0).heightIs(40).widthIs(640);
    
    _signLabel = [UILabel new];
    _signLabel.text = @"签到:";
    _signLabel.textColor = [UIColor blackColor];
    
    [_signView addSubview:_signLabel];
    _signLabel.sd_layout.centerYEqualToView(_signView).leftSpaceToView(_signView,20).widthIs(40).heightIs(20);
    
    _localBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _localBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [_localBtn setTitle:@"未定位" forState:UIControlStateNormal];
    [_localBtn setTitleColor:[UIColor colorWithHex:0x333333] forState:UIControlStateNormal];
    [_localBtn addTarget:self action:@selector(locationCity) forControlEvents:UIControlEventTouchUpInside];
    [_signView addSubview:_localBtn];
    
    _localBtn.sd_layout.centerYEqualToView(_signView).leftSpaceToView(_signLabel,20).widthIs(200).heightIs(20);
    
    _signLine = [UIView new];
    [self.view addSubview:_signLine];
    _signLine.sd_layout.topSpaceToView(_signView,0).heightIs(1).widthIs(640);
    _signLine.backgroundColor = [UIColor lightGrayColor];
    
    _dateView = [[UIView alloc] init];
    [self.view addSubview:_dateView];
    _dateView.sd_layout.topSpaceToView(_signLine,0).heightIs(40).widthIs(640);

    _dateLabel = [UILabel new];
    _dateLabel.text = @"日期:";
    _dateLabel.textColor = [UIColor blackColor];
    [_dateView addSubview:_dateLabel];
    _dateLabel.sd_layout.centerYEqualToView(_dateView).leftSpaceToView(_dateView,20).widthIs(40).heightIs(20);
    
    _dateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _dateBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    NSDate *d = [NSDate new];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    [_dateBtn setTitle:[formatter stringFromDate:d] forState:UIControlStateNormal];
    [_dateBtn setTitleColor:[UIColor colorWithHex:0x333333] forState:UIControlStateNormal];
    [_dateBtn addTarget:self action:@selector(dateClicked) forControlEvents:UIControlEventTouchUpInside];
    [_dateView addSubview:_dateBtn];
    
    _dateBtn.sd_layout.centerYEqualToView(_dateView).leftSpaceToView(_dateLabel,20).widthIs(200).heightIs(20);
    
    _dateLine = [UIView new];
    [self.view addSubview:_dateLine];
    _dateLine.sd_layout.topSpaceToView(_dateView,0).heightIs(1).widthIs(640);
    _dateLine.backgroundColor = [UIColor lightGrayColor];
    
    _customerView = [[UIView alloc] init];
    [self.view addSubview:_customerView];
    _customerView.sd_layout.topSpaceToView(_dateLine,0).heightIs(40).widthIs(640);
    
    _customerLabel = [UILabel new];
    _customerLabel.text = @"顾客:";
    _customerLabel.textColor = [UIColor blackColor];
    [_customerView addSubview:_customerLabel];
    _customerLabel.sd_layout.centerYEqualToView(_customerView).leftSpaceToView(_customerView,20).widthIs(40).heightIs(20);
    
    _customerHeaderView = [UIView new];
    [_customerView addSubview:_customerHeaderView];
    _customerHeaderView.sd_layout.centerYEqualToView(_customerView).leftSpaceToView(_customerLabel,20).rightSpaceToView(_customerView, 20).heightIs(20);

    UIView *lineView1 = [UIView new];
    lineView1.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:lineView1];
    lineView1.sd_layout.topSpaceToView(_customerView,0).heightIs(1).widthIs(640);
    
    _colleagueView = [[UIView alloc] init];
    [self.view addSubview:_colleagueView];
    _colleagueView.sd_layout.topSpaceToView(lineView1,0).heightIs(40).widthIs(640);
    
    _colleagueLabel = [UILabel new];
    _colleagueLabel.text = @"同事:";
    _colleagueLabel.textColor = [UIColor blackColor];
    [_colleagueView addSubview:_colleagueLabel];
    _colleagueLabel.sd_layout.centerYEqualToView(_colleagueView).leftSpaceToView(_colleagueView,20).widthIs(40).heightIs(20);
    
    _colleagueHeaderView = [UIView new];
    [_colleagueView addSubview:_colleagueHeaderView];
    _colleagueHeaderView.sd_layout.centerYEqualToView(_colleagueView).leftSpaceToView(_colleagueLabel,20).rightSpaceToView(_colleagueView, 20).heightIs(20);
    
    UIView *lineView2 = [UIView new];
    lineView2.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:lineView2];
    lineView2.sd_layout.topSpaceToView(_colleagueView,0).heightIs(1).widthIs(640);
    
    [self addBottomBar];
}

- (void)cancelButtonClicked
{
    if (self.navigationController.viewControllers.count <= 1) {
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)addBottomBar{
    [self.view bringSubviewToFront:_bottomBarView];
    UIView *view1 = [[UIView alloc] init];
    [_bottomBarView addSubview:view1];
    view1.sd_layout.leftSpaceToView(_bottomBarView,0).heightIs(40).widthIs(kScreenWidth / 4);
    UIImageView *imgView1 = [UIImageView new];
    imgView1.image = [UIImage imageNamed:@"work_customer"];
    [view1 addSubview:imgView1];
    imgView1.sd_layout.centerXEqualToView(view1).centerYEqualToView(view1).widthIs(25).heightEqualToWidth();
    UILongPressGestureRecognizer *gesturRecognizer1=[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(customerClick:)];
    gesturRecognizer1.minimumPressDuration = 0;
    [view1 addGestureRecognizer:gesturRecognizer1];
    
    UIView *view2 = [[UIView alloc] init];
    [_bottomBarView addSubview:view2];
    view2.sd_layout.leftSpaceToView(view1,0).heightIs(40).widthIs(kScreenWidth / 4);
    UIImageView *imgView2 = [UIImageView new];
    imgView2.image = [UIImage imageNamed:@"work_colleague"];
    [view2 addSubview:imgView2];
    imgView2.sd_layout.centerXEqualToView(view2).centerYEqualToView(view2).widthIs(25).heightEqualToWidth();
    UILongPressGestureRecognizer *gesturRecognizer2=[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(colleagueClick:)];
    gesturRecognizer2.minimumPressDuration = 0;
    [view2 addGestureRecognizer:gesturRecognizer2];
    
    UIView *view3 = [[UIView alloc] init];
    [_bottomBarView addSubview:view3];
    view3.sd_layout.leftSpaceToView(view2,0).heightIs(40).widthIs(kScreenWidth / 4);
    UIImageView *imgView3 = [UIImageView new];
    imgView3.image = [UIImage imageNamed:@"work_location"];
    [view3 addSubview:imgView3];
    imgView3.sd_layout.centerXEqualToView(view3).centerYEqualToView(view3).widthIs(25).heightEqualToWidth();
    UILongPressGestureRecognizer *gesturRecognizer3=[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(locationClick:)];
    gesturRecognizer3.minimumPressDuration = 0;
    [view3 addGestureRecognizer:gesturRecognizer3];
    
    UIView *view4 = [[UIView alloc] init];
    [_bottomBarView addSubview:view4];
    view4.sd_layout.leftSpaceToView(view3,0).heightIs(40).widthIs(kScreenWidth / 4);
    UIImageView *imgView4 = [UIImageView new];
    imgView4.image = [UIImage imageNamed:@"work_date"];
    [view4 addSubview:imgView4];
    imgView4.sd_layout.centerXEqualToView(view4).centerYEqualToView(view4).widthIs(25).heightEqualToWidth();
    
    UILongPressGestureRecognizer *gesturRecognizer=[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(dateClick:)];
    gesturRecognizer.minimumPressDuration = 0;
    [view4 addGestureRecognizer:gesturRecognizer];
}

#pragma mark - 调整bar的高度

- (void)keyboardWillShow:(NSNotification *)notification
{
    CGRect keyboardBounds = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    _bottomBarYConstraint.constant = keyboardBounds.size.height;
    
    [self setBottomBarHeight];
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    _bottomBarYConstraint.constant = 0;
    
    [self setBottomBarHeight];
}

- (void)setBottomBarHeight
{
#if 0
    NSTimeInterval animationDuration;
    [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];
    
    UIViewKeyframeAnimationOptions animationOptions;
    animationOptions = [notification.userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue] << 16;
#endif
    // 用注释的方法有可能会遮住键盘
    
    [self.view setNeedsUpdateConstraints];
    [UIView animateKeyframesWithDuration:0.25       //animationDuration
                                   delay:0
                                 options:7 << 16    //animationOptions
                              animations:^{
                                  [self.view layoutIfNeeded];
                              } completion:nil];
}
- (void)dateClick:(UITapGestureRecognizer *)rec{
    if (rec.state == UIGestureRecognizerStateBegan) {
        
    }else if(rec.state == UIGestureRecognizerStateEnded){
        [self dateClicked];
    }
}

- (void)dateClicked {
    if (!_dateAlert) {
        _dateAlert = [UIAlertController alertControllerWithTitle:@"" message:@"\n\n\n\n\n\n\n\n\n\n" preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            NSDate *date = self.datePicker.date;
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"yyyy-MM-dd"];
            NSLog(@"%@",[formatter stringFromDate:date]);
            [self.dateBtn setTitle:[formatter stringFromDate:date] forState:UIControlStateNormal];
        }];
        _datePicker = [[UIDatePicker alloc] init];
        _datePicker.datePickerMode = UIDatePickerModeDate;
        [_dateAlert.view addSubview:_datePicker];
        _datePicker.sd_layout.centerXEqualToView(_dateAlert.view);
        [_dateAlert addAction:cancel];
    }
    [self presentViewController:_dateAlert animated:YES completion:^{
        
    }];
}

- (void)customerClick:(UITapGestureRecognizer *)rec{
    if (rec.state == UIGestureRecognizerStateBegan) {
        
    }else if(rec.state == UIGestureRecognizerStateEnded){
        [_contentView resignFirstResponder];
        WorkChooseCustomerTableViewController *vc = [[WorkChooseCustomerTableViewController alloc] init];
        vc.delegate = self;
        [self.navigationController pushViewController:vc animated:YES];
    }
}
- (void)workChooseCustomer:(Customer *)customer {
    self.customer = customer;
    
    for (UIView *view in self.customerHeaderView.subviews) {
        [view removeFromSuperview];
    }
    
    UIImageView *customerImgView = [[UIImageView alloc] init];
    customerImgView.userInteractionEnabled = true;
    [customerImgView loadPortrait:customer.avatar];
    customerImgView.layer.cornerRadius = 18;
    customerImgView.layer.masksToBounds = true;
    [_customerHeaderView addSubview:customerImgView];
    customerImgView.sd_layout.centerYEqualToView(_customerHeaderView).leftEqualToView(_customerHeaderView).widthIs(36).heightIs(36);
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(customerTap:)];
    [customerImgView addGestureRecognizer:tap];
}

- (void)customerTap:(UITapGestureRecognizer *)tap {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Customer" bundle:nil];
    CustomerDetailsViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"CustomerDetails"];
    vc.uneditable = true;
    vc.customer = self.customer;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)locationClick:(UITapGestureRecognizer *)rec{
    if (rec.state == UIGestureRecognizerStateBegan) {
        
    }else if(rec.state == UIGestureRecognizerStateEnded){
        [self locationCity];
    }
}

- (void)colleagueClick:(UITapGestureRecognizer *)rec{
    if (rec.state == UIGestureRecognizerStateBegan) {
        
    }else if(rec.state == UIGestureRecognizerStateEnded){
        [_contentView resignFirstResponder];
        WorkChooseColleagueTableViewController *vc = [[WorkChooseColleagueTableViewController alloc] init];
        vc.delegate = self;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)workChooseColleagues:(NSArray *)colleagues {
    
    for (UIView *view in self.colleagueHeaderView.subviews) {
        [view removeFromSuperview];
    }
    
    NSMutableArray *ids = [[NSMutableArray alloc] init];
    for (OrgUserInfo *info in colleagues) {
        [ids addObject:[NSString stringWithFormat:@"%ld",info.id]];
        
        UIImageView *colleagueImgView = [[UIImageView alloc] init];
        colleagueImgView.tag = ids.count;
        colleagueImgView.userInteractionEnabled = true;
        [colleagueImgView loadPortrait:info.avatar];
        colleagueImgView.layer.cornerRadius = 18;
        colleagueImgView.layer.masksToBounds = true;
        [_colleagueHeaderView addSubview:colleagueImgView];
        colleagueImgView.sd_layout.centerYEqualToView(_colleagueHeaderView).leftSpaceToView(_colleagueHeaderView, (ids.count-1)*40).widthIs(36).heightIs(36);
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(colleagueTap:)];
        [colleagueImgView addGestureRecognizer:tap];
    }
    self.stafflist = [ids componentsJoinedByString:@","];
    self.colleagues = colleagues;
}

- (void)colleagueTap:(UITapGestureRecognizer *)tap {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Colleague" bundle:nil];
    ColleagueDetailsViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"ColleagueDetails"];
    vc.uneditable = true;
    vc.orgUserInfo = self.colleagues[tap.view.tag-1];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)locationCity{
    if ([CLLocationManager locationServicesEnabled]) {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
        _currentCity = @"";
        if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
            [self.locationManager requestWhenInUseAuthorization];
        }
        [_locationManager startUpdatingLocation];
    }else{
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"定位" message:@"请在设置中打开定位权限" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *sure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    
        }];
        
        [alert addAction:sure];
        [self presentViewController:alert animated:YES completion:^{}];
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    NSLog(@"%@",error);
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    [_locationManager stopUpdatingLocation];
    CLLocation *currentLocation = [locations lastObject];
    CLGeocoder *geoCoder = [[CLGeocoder alloc] init];
    [geoCoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if (placemarks.count > 0) {
            CLPlacemark *plackMark = placemarks[0];
            self.currentCity = plackMark.name;
            if (!self.currentCity) {
                self.currentCity = @"未定位";
            }else{
                self.currentCity = [NSString stringWithFormat:@"%@·%@·%@",plackMark.locality,plackMark.subLocality,plackMark.name];
            }
            
            [self.localBtn setTitle:self.currentCity forState:UIControlStateNormal];
        }
    }];
}
- (void)sendItemClicked:(UIBarButtonItem *)item {
    if ([item.title isEqualToString:@"发送"]) {
        NSString *comStr = self.contentView.text;
        comStr = [comStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        if (comStr.length <= 0) {
            [Utils showHUD:@"工作内容不能为空"];
            return;
        }
        if (!self.customer) {
            [Utils showHUD:@"请选择一个客户"];
            return;
        }
        _HUD = [Utils createHUD];
        _HUD.label.text = @"工作发送中";
        NSArray<UIImage *> *datas = [_pickerView getPhotos];
        if (datas != nil && datas.count > 0) {
            [self getQiniuNoKeyToken];
        }else{
            [self publishWork:@""];
        }
    } else {
        [_pickerView endEdit];
    }
}

- (void)getQiniuNoKeyToken{
    NSString *userId = [NSString stringWithFormat:@"%lld",[Config getOwnID]];;
    NSString *token = [Config getToken];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    
    NSString* urlStr = [NSString stringWithFormat:@"%@%@",BASE_URL,API_COMMON_QINIU_NOKEY_TOKEN];
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"POST" URLString:urlStr parameters:@{@"bucketName":@"wwf-crm"}                                                                                    error:nil];
    [request addValue:userId forHTTPHeaderField:@"userId"];
    [request addValue:token forHTTPHeaderField:@"token"];
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id _Nonnull responseObject, NSError *error) {
        if (error) {
            self.HUD.label.text = @"发送失败";
            [self.HUD hideAnimated:YES afterDelay:1];
        } else {
            
            if (responseObject) {
                NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
                if ([dictionary[@"result"] intValue] == 1) {
                    [self upload:dictionary[@"uptoken"] ];
                    
                }else{
                    self.HUD.label.text = @"发送失败";
                    [self.HUD hideAnimated:YES afterDelay:1];
                }
            }else{
                self.HUD.label.text = @"发送失败";
                [self.HUD hideAnimated:YES afterDelay:1];
            }
        }
        
    }];
    [dataTask resume];
    
}

- (void) upload:(NSString *)token{
    NSArray<UIImage *> *datas = [_pickerView getPhotos];
    NSMutableArray<Url *> *list = [NSMutableArray new];
    for (UIImage *image in datas) {
        NSString *filepath = [self getImagePath:image];
        QNUploadManager *upManager = [[QNUploadManager alloc] init];
        QNUploadOption *uploadOption = [[QNUploadOption alloc] initWithMime:nil progressHandler:^(NSString *key, float percent) {
            NSLog(@"percent == .%.2f", percent);
        }
                                                                     params:nil
                                                                   checkCrc:NO
                                                         cancellationSignal:nil];
        [upManager putFile:filepath key:nil token:token complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
            NSLog(@"info ===== %@", info);
            int status = [info statusCode];
            if (status != 200) {
                self.HUD.label.text = @"发送失败";
                [self.HUD hideAnimated:YES afterDelay:1];
                return ;
            }
            NSLog(@"resp ===== %@", resp);
            Url *url = [Url new];
            url.url = resp[@"key"];
            self.count++;
            [list addObject:url];
            if (self.count == datas.count) {
                NSArray *a = [Url mj_keyValuesArrayWithObjectArray:list];
                NSString *json = [a mj_JSONString];
                [self publishWork:json];
            }
        } option:uploadOption];
    }
}

- (void)publishWork:(NSString *)picurl{
    NSString *userId = [NSString stringWithFormat:@"%ld",[Config getOrgUserID]];;
    NSString *token = [Config getToken];
    NSString *dbid = [NSString stringWithFormat:@"%ld",[Config getDbID]];;
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    
    NSString* urlStr = [NSString stringWithFormat:@"%@%@",BASE_URL,API_WORK_PUBLISH];
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"POST" URLString:urlStr parameters:@{@"content":_contentView.text,@"picurl":picurl,@"worktime":_dateBtn.titleLabel.text,@"lal":@"20,116",@"address":_localBtn.titleLabel.text,@"cid":[NSString stringWithFormat:@"%ld",_customer.id],@"stafflist":_stafflist,@"worktype":[NSString stringWithFormat:@"%ld",_worktype]}                                                                                    error:nil];
    [request addValue:userId forHTTPHeaderField:@"userId"];
    [request addValue:token forHTTPHeaderField:@"token"];
    [request addValue:dbid forHTTPHeaderField:@"dbid"];
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id _Nonnull responseObject, NSError *error) {
        if (error) {
            NSLog(@"Error:-->%@", error);
            self.HUD.label.text = @"发送失败";
        } else {
            NSString *responseString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            NSLog(@"DATA-->%@", responseString);
            if (responseObject) {
                NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
                if ([dictionary[@"result"] intValue] == 1) {
                    self.HUD.label.text = @"发送成功";
                    [self cancelButtonClicked];
                }else{
                    self.HUD.label.text = @"发送失败";
                }
            }else{
                self.HUD.label.text = @"发送失败";
            }
        }
        [self.HUD hideAnimated:YES afterDelay:1];
    }];
    [dataTask resume];
}

//照片获取本地路径转换
- (NSString *)getImagePath:(UIImage *)Image {
    NSString *filePath = nil;
    NSData *data = nil;
    if (UIImagePNGRepresentation(Image) == nil) {
        data = UIImageJPEGRepresentation(Image, 1.0);
    } else {
//        data = UIImagePNGRepresentation(Image);
        data = UIImageJPEGRepresentation(Image, 0.7);
    }
    
    //图片保存的路径
    //这里将图片放在沙盒的documents文件夹中
    NSString *DocumentsPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    
    //文件管理器
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    //把刚刚图片转换的data对象拷贝至沙盒中
    [fileManager createDirectoryAtPath:DocumentsPath withIntermediateDirectories:YES attributes:nil error:nil];
    NSString *ImagePath = [[NSString alloc] initWithFormat:@"/theFirstImage.png"];
    [fileManager createFileAtPath:[DocumentsPath stringByAppendingString:ImagePath] contents:data attributes:nil];
    
    //得到选择后沙盒中图片的完整路径
    filePath = [[NSString alloc] initWithFormat:@"%@%@", DocumentsPath, ImagePath];
    return filePath;
}

@end
