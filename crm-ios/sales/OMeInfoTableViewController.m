//
//  OMeInfoTableViewController.m
//  sales
//
//  Created by user on 2017/1/12.
//  Copyright © 2017年 rayootech. All rights reserved.
//

#import "OMeInfoTableViewController.h"
#import "UIImageView+Util.h"
#import "Config.h"
#import "User.h"
#import "TZImagePickerController.h"
#import "SalesApi.h"
#import "Utils.h"
#import <QiniuSDK.h>
#import <MJExtension.h>
#import <AFNetworking.h>
#import <MBProgressHUD.h>

@interface OMeInfoTableViewController ()<TZImagePickerControllerDelegate, UITextFieldDelegate, UITextViewDelegate>

@property (nonatomic,weak) IBOutlet UIImageView     *avatarImage;
@property (nonatomic,weak) IBOutlet UITextField         *nameTF;
@property (nonatomic,weak) IBOutlet UILabel         *mobileLabel;
@property (nonatomic,weak) IBOutlet UILabel         *sexLabel;
@property (nonatomic,weak) IBOutlet UITextField         *areaTF;
@property (nonatomic,weak) IBOutlet UITextField         *emailTF;
@property (nonatomic,weak) IBOutlet UITextField         *wechatTF;
@property (nonatomic,weak) IBOutlet UITextField         *weiboTF;
@property (nonatomic,weak) IBOutlet UITextField         *linkedinTF;
@property (nonatomic,weak) IBOutlet UITextView         *descTV;
@property (nonatomic,assign) BOOL                   imageflag;
@property (nonatomic,strong) UIImage                *image;
@property (nonatomic,strong) NSString               *avatar;
@property (nonatomic,strong) User                   *user;
@property (nonatomic,strong) MBProgressHUD          *hud;
@end

@implementation OMeInfoTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"个人信息";
    _imageflag = false;
    [self setUpView];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(saveButtonClicked)];
}
- (void)setUpView{
    _user = [Config getUser];
    _avatarImage.layer.cornerRadius = 22;
    _avatarImage.layer.masksToBounds = true;
    [_avatarImage loadPortrait:_user.avatar];
    _nameTF.text = _user.name;
    _mobileLabel.text = _user.mobile;
    _emailTF.text = _user.email;
    _areaTF.text = _user.area;
    _linkedinTF.text = _user.linkedin;
    _descTV.text = _user.Description;
    _weiboTF.text = _user.weibo;
    _wechatTF.text = _user.wechat;
    _sexLabel.text = [_user.sex isEqualToString:@"1"] ? @"男" : @"女";
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([indexPath row] == 0) {
        TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:self];
        imagePickerVc.allowCrop = YES;
        [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL flag) {
            _avatarImage.image = photos[0];
            _image = photos[0];
            _imageflag = true;
        }];
        [self presentViewController:imagePickerVc animated:YES completion:nil];
        
    } else if ([indexPath row] == 3) {
        [tableView deselectRowAtIndexPath:indexPath animated:NO];
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction *nanAction = [UIAlertAction actionWithTitle:@"男" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            _sexLabel.text = @"男";
        }];
        UIAlertAction *nvAction = [UIAlertAction actionWithTitle:@"女" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            _sexLabel.text = @"女";
        }];
        [alertController addAction:cancelAction];
        [alertController addAction:nanAction];
        [alertController addAction:nvAction];
        [self presentViewController:alertController animated:YES completion:nil];   
    }
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

- (void)nameUpdate:(NSString *)name{
    _nameTF.text = name;
}

- (void)areaUpdate:(NSString *)area{
    _areaTF.text = area;
}

- (void)descUpdate:(NSString *)desc{
    _descTV.text = desc;
}

- (void)emailUpdate:(NSString *)email{
    _emailTF.text = email;
}

- (void)wechatUpdate:(NSString *)wechat{
    _wechatTF.text = wechat;
}

- (void)weiboUpdate:(NSString *)weibo{
    _weiboTF.text = weibo;
}

- (void)linkedUpdate:(NSString *)linked{
    _linkedinTF.text = linked;
}
- (void)saveButtonClicked{
    _hud = [Utils createHUD];
    if (_imageflag) {
        [self getQiniuKeyToken];
    }else{
        [self updateInfo];
    }
}

- (void)getQiniuKeyToken{
    NSString *userId = [NSString stringWithFormat:@"%lld",[Config getOwnID]];
    NSString *token = [Config getToken];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    
    NSString* urlStr = [NSString stringWithFormat:@"%@%@",BASE_URL,API_COMMON_QINIU_KEY_TOKEN];
    NSString *key = [@"head_" stringByAppendingString:userId];
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"POST" URLString:urlStr parameters:@{@"bucketName":@"wwf-crm",@"key":key}                                                                                    error:nil];
    [request addValue:userId forHTTPHeaderField:@"userId"];
    [request addValue:token forHTTPHeaderField:@"token"];
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id _Nonnull responseObject, NSError *error) {
        if (error) {
            _hud.label.text = @"修改失败";
            [_hud hideAnimated:YES afterDelay:1];
        } else {
            
            if (responseObject) {
                NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
                if ([dictionary[@"result"] intValue] == 1) {
                    [self upload:dictionary[@"uptoken"] ];
                    
                }else{
                    _hud.label.text = @"修改失败";
                    [_hud hideAnimated:YES afterDelay:1];
                }
            }else{
                _hud.label.text = @"修改失败";
                [_hud hideAnimated:YES afterDelay:1];
            }
        }
        
    }];
    [dataTask resume];
}

- (void) upload:(NSString *)token{
    NSString *filepath = [self getImagePath:_image];
    NSString *userId = [NSString stringWithFormat:@"%lld",[Config getOwnID]];
    NSString *key = [@"head_" stringByAppendingString:userId];
    QNUploadManager *upManager = [[QNUploadManager alloc] init];
    QNUploadOption *uploadOption = [[QNUploadOption alloc] initWithMime:nil progressHandler:^(NSString *key, float percent) {
        NSLog(@"percent == .%.2f", percent);
    }
                                                                 params:nil
                                                               checkCrc:NO
                                                     cancellationSignal:nil];
    [upManager putFile:filepath key:key token:token complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
        NSLog(@"info ===== %@", info);
        int status = [info statusCode];
        if (status != 200) {
            _hud.label.text = @"修改失败";
            [_hud hideAnimated:YES afterDelay:1];
            return ;
        }
        
        _avatar = resp[@"key"];
        NSDate *date = [NSDate new];
        NSString *time = [NSString stringWithFormat:@"%ld",(long)[date timeIntervalSince1970]];
        _avatar = [_avatar stringByAppendingString:@"?v="];
        _avatar = [_avatar stringByAppendingString:time];
        [self updateInfo];
    } option:uploadOption];
    
    
}
//照片获取本地路径转换
- (NSString *)getImagePath:(UIImage *)Image {
    NSString *filePath = nil;
    NSData *data = nil;
    if (UIImagePNGRepresentation(Image) == nil) {
        data = UIImageJPEGRepresentation(Image, 1.0);
    } else {
//        data = UIImagePNGRepresentation(Image);
        data = UIImageJPEGRepresentation(Image, 0.5);
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

- (void)updateInfo{
    _user.id = _user.id;
    _user.name = _nameTF.text;
    _user.mobile = _mobileLabel.text;
    _user.area = _areaTF.text;
    _user.Description = _descTV.text;
    _user.email = _emailTF.text;
    _user.wechat = _wechatTF.text;
    _user.weibo = _weiboTF.text;
    _user.linkedin = _linkedinTF.text;
    if ([_sexLabel.text isEqualToString:@"男"]) {
        _user.sex = @"1";
    }else{
        _user.sex = @"0";
    }
    if (_imageflag) {
        _user.avatar = _avatar;
    }
    NSDictionary *jsonObject = _user.mj_keyValues;
    _hud.label.text = @"修改中";
    NSString *userId = [NSString stringWithFormat:@"%lld",[Config getOwnID]];;
    NSString *token = [Config getToken];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    NSString* urlStr = [NSString stringWithFormat:@"%@%@",BASE_URL,API_USERINFO_UPDATE];
    NSMutableURLRequest *request = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:urlStr parameters:jsonObject                                                                                   error:nil];
    
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
                    [Config saveProfile:_user];
                    NSNotification *notice = [NSNotification notificationWithName:@"updateUserInfo" object:nil];
                    [[NSNotificationCenter defaultCenter]postNotification:notice];
                    
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

@end
