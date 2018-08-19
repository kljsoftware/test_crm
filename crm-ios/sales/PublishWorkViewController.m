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
#import <SDAutoLayout.h>
#import <QiniuSDK.h>
#import <AFNetworking.h>
#import <MJExtension.h>
#import <MBProgressHUD.h>
#import "Config.h"
#import "SalesApi.h"
#import "Url.h"
#import "UIColor+Util.h"
#import "Utils.h"
#import "NSStringUtils.h"
#import <CoreLocation/CoreLocation.h>
#define kScreenWidth        [[UIScreen mainScreen] bounds].size.width
#define kScreenHeight       [[UIScreen mainScreen] bounds].size.height
@interface PublishWorkViewController () <UITextViewDelegate,WorkChooseCustomerCellDelegate,WorkChooseColleaguesCellDelegate,CLLocationManagerDelegate>

@property (weak, nonatomic) IBOutlet UIView *photoView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *photoViewHieghtConstraint;
@property (nonatomic,weak)  IBOutlet PlaceholderTextView *contentView;
@property (nonatomic,weak)  IBOutlet UIView     *photoLine;
@property (nonatomic,strong) ImagePickerView *pickerView;
@property (nonatomic,strong) UIButton *button;
@property (nonatomic,assign) NSInteger count;
@property (nonatomic,strong) MBProgressHUD *HUD;

@property (nonatomic,strong) UIView             *signView;
@property (nonatomic,strong) UILabel            *signLabel;
@property (nonatomic,strong) UILabel            *localLabel;
@property (nonatomic,strong) UIView             *signLine;

@property (nonatomic,strong) UIView             *dateView;
@property (nonatomic,strong) UILabel            *dateLabel;
@property (nonatomic,strong) UILabel            *dateLabel2;
@property (nonatomic,strong) UIView             *dateLine;

@property (nonatomic,weak) IBOutlet UIView             *bottomBarView;
@property (nonatomic,weak) IBOutlet NSLayoutConstraint *bottomBarYConstraint;
@property (nonatomic,strong) NSLayoutConstraint *bottomBarHeightConstraint;
@property (nonatomic,strong) NSLayoutConstraint *bottomBarWidthConstraint;

@property (nonatomic,strong) UIView             *customerView;
@property (nonatomic,strong) UIImageView        *customerImage;
@property (nonatomic,strong) UIView             *colleagueView;
@property (nonatomic,strong) UIImageView        *colleageImage;
@property (nonatomic,strong) UIView             *locationView;
@property (nonatomic,strong) UIImageView        *locationImage;
@property (nonatomic,strong) UIView             *bottomDateView;
@property (nonatomic,strong) UIImageView        *dateImage;

@property (nonatomic,strong) UIAlertController  *dateAlert;
@property (nonatomic,strong) UIDatePicker       *datePicker;

@property (nonatomic,strong) NSString           *customerid;
@property (nonatomic,strong) NSString           *stafflist;
@property (nonatomic,strong) CLLocationManager  *locationManager;
@property (nonatomic,strong) NSString           *currentCity;
@end

@implementation PublishWorkViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"工作发布";
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消"
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:@selector(cancelButtonClicked)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"发送" style:UIBarButtonItemStylePlain target:self action:@selector(sendButtonClicked)];
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
    config.itemSize = CGSizeMake(80, 80);
    config.photosMaxCount = 9;
    
    ImagePickerView *pickerView = [[ImagePickerView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0) config:config];
    //Height changed with photo selection
    __weak typeof(self) weakSelf = self;
    pickerView.viewHeightChanged = ^(CGFloat height) {
        weakSelf.photoViewHieghtConstraint.constant = height;
        [weakSelf.view setNeedsLayout];
        [weakSelf.view layoutIfNeeded];
    };
    pickerView.navigationController = self.navigationController;
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
    
    _localLabel = [UILabel new];
    _localLabel.text = @"未定位";
    _signLabel.textColor = [UIColor blackColor];
    [_signView addSubview:_localLabel];
    
    _localLabel.sd_layout.centerYEqualToView(_signView).leftSpaceToView(_signLabel,20).widthIs(200).heightIs(20);
    
    _signLine = [UIView new];
    [self.view addSubview:_signLine];
    _signLine.sd_layout.topSpaceToView(_signView,0).heightIs(1).widthIs(640);
    _signLine.backgroundColor = [UIColor lightGrayColor];
    
    _dateView = [[UIView alloc] init];
    [self.view addSubview:_dateView];
    _dateView.sd_layout.topSpaceToView(_signLine,0).heightIs(40).widthIs(640);
    
    _dateLabel = [UILabel new];
    _dateLabel.text = @"日期";
    _dateLabel.textColor = [UIColor blackColor];
    
    [_dateView addSubview:_dateLabel];
    _dateLabel.sd_layout.centerYEqualToView(_dateView).leftSpaceToView(_dateView,20).widthIs(40).heightIs(20);
    
    _dateLabel2 = [UILabel new];
    NSDate *d = [NSDate new];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    _dateLabel2.text = [formatter stringFromDate:d];
    _dateLabel2.textColor = [UIColor blackColor];
    [_dateView addSubview:_dateLabel2];
    
    _dateLabel2.sd_layout.centerYEqualToView(_dateView).leftSpaceToView(_dateLabel,20).widthIs(200).heightIs(20);
    
    _dateLine = [UIView new];
    [self.view addSubview:_dateLine];
    _dateLine.sd_layout.topSpaceToView(_dateView,0).heightIs(1).widthIs(640);
    _dateLine.backgroundColor = [UIColor lightGrayColor];
    
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
    _customerView = [[UIView alloc] init];
    [_bottomBarView addSubview:_customerView];
    _customerView.sd_layout.leftSpaceToView(_bottomBarView,0).heightIs(40).widthIs(kScreenWidth / 4);
    _customerImage = [UIImageView new];
    _customerImage.image = [UIImage imageNamed:@"work_customer"];
    [_customerView addSubview:_customerImage];
    _customerImage.sd_layout.centerXEqualToView(_customerView).centerYEqualToView(_customerView).widthIs(25).heightEqualToWidth();
    UILongPressGestureRecognizer *gesturRecognizer1=[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(customerClick:)];
    gesturRecognizer1.minimumPressDuration = 0;
    [_customerView addGestureRecognizer:gesturRecognizer1];
    
    _colleagueView = [[UIView alloc] init];
    [_bottomBarView addSubview:_colleagueView];
    _colleagueView.sd_layout.leftSpaceToView(_customerView,0).heightIs(40).widthIs(kScreenWidth / 4);
    _colleageImage = [UIImageView new];
    _colleageImage.image = [UIImage imageNamed:@"work_colleague"];
    [_colleagueView addSubview:_colleageImage];
    _colleageImage.sd_layout.centerXEqualToView(_colleagueView).centerYEqualToView(_colleagueView).widthIs(25).heightEqualToWidth();
    UILongPressGestureRecognizer *gesturRecognizer2=[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(colleagueClick:)];
    gesturRecognizer2.minimumPressDuration = 0;
    [_colleagueView addGestureRecognizer:gesturRecognizer2];
    
    _locationView = [[UIView alloc] init];
    [_bottomBarView addSubview:_locationView];
    _locationView.sd_layout.leftSpaceToView(_colleagueView,0).heightIs(40).widthIs(kScreenWidth / 4);
    _locationImage = [UIImageView new];
    _locationImage.image = [UIImage imageNamed:@"work_location"];
    [_locationView addSubview:_locationImage];
    _locationImage.sd_layout.centerXEqualToView(_locationView).centerYEqualToView(_locationView).widthIs(25).heightEqualToWidth();
    UILongPressGestureRecognizer *gesturRecognizer3=[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(locationClick:)];
    gesturRecognizer3.minimumPressDuration = 0;
    [_locationView addGestureRecognizer:gesturRecognizer3];
    
    _bottomDateView = [[UIView alloc] init];
    [_bottomBarView addSubview:_bottomDateView];
    _bottomDateView.sd_layout.leftSpaceToView(_locationView,0).heightIs(40).widthIs(kScreenWidth / 4);
    _dateImage = [UIImageView new];
    _dateImage.image = [UIImage imageNamed:@"work_date"];
    [_bottomDateView addSubview:_dateImage];
    _dateImage.sd_layout.centerXEqualToView(_bottomDateView).centerYEqualToView(_bottomDateView).widthIs(25).heightEqualToWidth();
    
    UILongPressGestureRecognizer *gesturRecognizer=[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(dateClick:)];
    gesturRecognizer.minimumPressDuration = 0;
    [_bottomDateView addGestureRecognizer:gesturRecognizer];
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
        if (!_dateAlert) {
            _dateAlert = [UIAlertController alertControllerWithTitle:@"" message:@"\n\n\n\n\n\n\n\n\n\n" preferredStyle:UIAlertControllerStyleActionSheet];
            UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                NSDate *date = _datePicker.date;
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                [formatter setDateFormat:@"yyyy-MM-dd"];
                NSLog(@"%@",[formatter stringFromDate:date]);
                _dateLabel2.text = [formatter stringFromDate:date];
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
- (void)finialCustomerId:(NSString *)customerid{
    _customerid = customerid;
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
- (void)finialColleaguesIds:(NSString *)colleagueids{
    NSLog(@"ids is %@",colleagueids);
    _stafflist = colleagueids;
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
            _currentCity = plackMark.name;
            if (!_currentCity) {
                _currentCity = @"未定位";
            }else{
                _currentCity = [NSString stringWithFormat:@"%@·%@·%@",plackMark.locality,plackMark.subLocality,plackMark.name];
            }
            
            _localLabel.text = _currentCity;
        }
    }];
}
- (void)sendButtonClicked{
    _HUD = [Utils createHUD];
    
    NSString *comStr = self.contentView.text;
    comStr = [comStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (comStr.length <= 0) {
        _HUD.label.text = @"工作内容不能为空";
        [_HUD hideAnimated:YES afterDelay:1];
        return;
    }
    if ([NSStringUtils isEmpty:_customerid]) {
        _HUD.label.text = @"请选择一个客户";
        [_HUD hideAnimated:YES afterDelay:1];
        return;
    }
    _HUD.label.text = @"工作发送中";
    NSArray<UIImage *> *datas = [_pickerView getPhotos];
    if (datas != nil && datas.count > 0) {
        [self getQiniuNoKeyToken];
    }else{
        [self publishWork:@""];
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
            _HUD.label.text = @"发送失败";
            [_HUD hideAnimated:YES afterDelay:1];
        } else {
            
            if (responseObject) {
                NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
                if ([dictionary[@"result"] intValue] == 1) {
                    [self upload:dictionary[@"uptoken"] ];
                    
                }else{
                    _HUD.label.text = @"发送失败";
                    [_HUD hideAnimated:YES afterDelay:1];
                }
            }else{
                _HUD.label.text = @"发送失败";
                [_HUD hideAnimated:YES afterDelay:1];
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
                _HUD.label.text = @"发送失败";
                [_HUD hideAnimated:YES afterDelay:1];
                return ;
            }
            NSLog(@"resp ===== %@", resp);
            Url *url = [Url new];
            url.url = resp[@"key"];
            _count++;
            [list addObject:url];
            if (_count == datas.count) {
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
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"POST" URLString:urlStr parameters:@{@"content":_contentView.text,@"picurl":picurl,@"worktime":_dateLabel2.text,@"lal":@"20,116",@"address":_localLabel.text,@"cid":_customerid,@"stafflist":_stafflist,@"worktype":[NSString stringWithFormat:@"%ld",_worktype]}                                                                                    error:nil];
    [request addValue:userId forHTTPHeaderField:@"userId"];
    [request addValue:token forHTTPHeaderField:@"token"];
    [request addValue:dbid forHTTPHeaderField:@"dbid"];
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id _Nonnull responseObject, NSError *error) {
        if (error) {
            NSLog(@"Error:-->%@", error);
            _HUD.label.text = @"发送失败";
        } else {
            NSString *responseString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            NSLog(@"DATA-->%@", responseString);
            if (responseObject) {
                NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
                if ([dictionary[@"result"] intValue] == 1) {
                    _HUD.label.text = @"发送成功";
                    [self cancelButtonClicked];
                }else{
                    _HUD.label.text = @"发送失败";
                }
            }else{
                _HUD.label.text = @"发送失败";
            }
        }
        [_HUD hideAnimated:YES afterDelay:1];
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