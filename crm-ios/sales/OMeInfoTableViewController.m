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
#import "ONameUpdateViewController.h"
#import "OAreaUpdateViewController.h"
#import "ODescUpdateViewController.h"
#import "OEmailUpdateViewController.h"
#import "OWeChatUpdateViewController.h"
#import "OWeiBoUpdateViewController.h"
#import "OLinkedUpdateViewController.h"
#import "User.h"
#import "TZImagePickerController.h"
#import "SalesApi.h"
#import "Utils.h"
#import <QiniuSDK.h>
#import <MJExtension.h>
#import <AFNetworking.h>
#import <MBProgressHUD.h>
@interface OMeInfoTableViewController ()<TZImagePickerControllerDelegate,ONameUpdateDelegate,OAreaUpdateDelegate,ODescUpdateDelegate,OEmailUpdateDelegate,OWeChatUpdateDelegate,OWeiBoUpdateDelegate,OLinkedUpdateDelegate>
@property (nonatomic,weak) IBOutlet UIImageView     *avatarImage;
@property (nonatomic,weak) IBOutlet UILabel         *nameLabel;
@property (nonatomic,weak) IBOutlet UILabel         *mobileLabel;

@property (nonatomic,weak) IBOutlet UILabel         *sexLabel;
@property (nonatomic,weak) IBOutlet UILabel         *areaLabel;
@property (nonatomic,weak) IBOutlet UILabel         *descLabel;

@property (nonatomic,weak) IBOutlet UILabel         *emailLabel;
@property (nonatomic,weak) IBOutlet UILabel         *wechatLabel;
@property (nonatomic,weak) IBOutlet UILabel         *weiboLabel;
@property (nonatomic,weak) IBOutlet UILabel         *linkedLabel;
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
    [_avatarImage loadPortrait:_user.avatar];
    _nameLabel.text = _user.name;
    _mobileLabel.text = _user.mobile;
    _emailLabel.text = _user.email;
    _areaLabel.text = _user.area;
    _linkedLabel.text = _user.linkedin;
    _descLabel.text = _user.Description;
    _weiboLabel.text = _user.weibo;
    _wechatLabel.text = _user.wechat;
    if ([_user.sex isEqualToString:@"1"]) {
        _sexLabel.text = @"男";
    }else{
        _sexLabel.text = @"女";
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    NSIndexPath *index = [[NSIndexPath alloc] initWithIndex:section];
    if (index.section == 0) {
        return 24;
    }
    return 5;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([indexPath section] == 0) {
        if ([indexPath row] == 0) {
            TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:self];
            imagePickerVc.allowCrop = YES;
            [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL flag) {
                _avatarImage.image = photos[0];
                _image = photos[0];
                _imageflag = true;
            }];
            [self presentViewController:imagePickerVc animated:YES completion:nil];
        }else if ([indexPath row] == 1){
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"OMeViewController" bundle:nil];
            ONameUpdateViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"OName"];
            vc.hidesBottomBarWhenPushed = YES;
            vc.view.backgroundColor = [UIColor whiteColor];
            vc.delegate = self;
            vc.model = _nameLabel.text;
            [self.navigationController pushViewController:vc animated:YES];
        }else if([indexPath row] == 2){
        }
    }else if([indexPath section] == 1){
        if ([indexPath row] == 0) {
            [tableView deselectRowAtIndexPath:indexPath animated:NO];
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
            }];
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
        else if([indexPath row] == 1){
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"OMeViewController" bundle:nil];
            OAreaUpdateViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"OArea"];
            vc.hidesBottomBarWhenPushed = YES;
            vc.view.backgroundColor = [UIColor whiteColor];
            vc.delegate = self;
            vc.model = _areaLabel.text;
            [self.navigationController pushViewController:vc animated:YES];
        }else if([indexPath row] == 2){
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"OMeViewController" bundle:nil];
            ODescUpdateViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"ODesc"];
            vc.hidesBottomBarWhenPushed = YES;
            vc.view.backgroundColor = [UIColor whiteColor];
            vc.delegate = self;
            vc.model = _descLabel.text;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }else if([indexPath section] == 2){
        if ([indexPath row] == 0) {
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"OMeViewController" bundle:nil];
            OEmailUpdateViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"OEmail"];
            vc.hidesBottomBarWhenPushed = YES;
            vc.view.backgroundColor = [UIColor whiteColor];
            vc.delegate = self;
            vc.model = _emailLabel.text;
            [self.navigationController pushViewController:vc animated:YES];
        }else if([indexPath row] == 1){
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"OMeViewController" bundle:nil];
            OWeChatUpdateViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"OWeChat"];
            vc.hidesBottomBarWhenPushed = YES;
            vc.view.backgroundColor = [UIColor whiteColor];
            vc.delegate = self;
            vc.model = _wechatLabel.text;
            [self.navigationController pushViewController:vc animated:YES];
        }else if([indexPath row] == 2){
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"OMeViewController" bundle:nil];
            OWeiBoUpdateViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"OWeiBo"];
            vc.hidesBottomBarWhenPushed = YES;
            vc.view.backgroundColor = [UIColor whiteColor];
            vc.delegate = self;
            vc.model = _weiboLabel.text;
            [self.navigationController pushViewController:vc animated:YES];
        }else if([indexPath row] == 3){
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"OMeViewController" bundle:nil];
            OLinkedUpdateViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"OLinked"];
            vc.hidesBottomBarWhenPushed = YES;
            vc.view.backgroundColor = [UIColor whiteColor];
            vc.delegate = self;
            vc.model = _linkedLabel.text;
            [self.navigationController pushViewController:vc animated:YES];
        }

    }
}

- (void)nameUpdate:(NSString *)name{
    _nameLabel.text = name;
}

- (void)areaUpdate:(NSString *)area{
    _areaLabel.text = area;
}

- (void)descUpdate:(NSString *)desc{
    _descLabel.text = desc;
}

- (void)emailUpdate:(NSString *)email{
    _emailLabel.text = email;
}

- (void)wechatUpdate:(NSString *)wechat{
    _wechatLabel.text = wechat;
}

- (void)weiboUpdate:(NSString *)weibo{
    _weiboLabel.text = weibo;
}

- (void)linkedUpdate:(NSString *)linked{
    _linkedLabel.text = linked;
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
    _user.name = _nameLabel.text;
    _user.mobile = _mobileLabel.text;
    _user.area = _areaLabel.text;
    _user.Description = _descLabel.text;
    _user.email = _emailLabel.text;
    _user.wechat = _wechatLabel.text;
    _user.weibo = _weiboLabel.text;
    _user.linkedin = _linkedLabel.text;
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
//                    dispatch_async(dispatch_get_main_queue(), ^{
//                        NSNotification *notice = [NSNotification notificationWithName:@"updateOrgUserInfo" object:nil];
//                        [[NSNotificationCenter defaultCenter]postNotification:notice];
//                    });
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
