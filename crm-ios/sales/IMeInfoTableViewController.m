//
//  IMeInfoTableViewController.m
//  sales
//
//  Created by user on 2017/4/25.
//  Copyright © 2017年 rayootech. All rights reserved.
//

#import "IMeInfoTableViewController.h"
#import "OrgUserInfo.h"
#import "Config.h"
#import "UIImageView+Util.h"
#import "TZImagePickerController.h"

#import "ONameUpdateViewController.h"
#import "OAreaUpdateViewController.h"
#import "ODescUpdateViewController.h"
#import "OEmailUpdateViewController.h"
#import "OWeChatUpdateViewController.h"
#import "BindEmailViewController.h"
#import "MeTitleUpdateViewController.h"


@interface IMeInfoTableViewController ()<TZImagePickerControllerDelegate,ONameUpdateDelegate,OWeChatUpdateDelegate,OAreaUpdateDelegate,TitleUpdateDelegate,EmailUpdateDelegate>

@property (nonatomic,weak) IBOutlet UIImageView     *avatarImage;
@property (nonatomic,weak) IBOutlet UILabel         *nameLabel;
@property (nonatomic,weak) IBOutlet UILabel         *sexLabel;

@property (nonatomic,weak) IBOutlet UILabel         *areaLabel;
@property (nonatomic,weak) IBOutlet UILabel         *emailLabel;
@property (nonatomic,weak) IBOutlet UILabel         *wechatLabel;
@property (nonatomic,weak) IBOutlet UILabel         *titleLabel;
@property (nonatomic,strong) OrgUserInfo            *orgUser;
@property (nonatomic,assign) BOOL                   imageflag;
@property (nonatomic,strong) UIImage                *image;
@property (nonatomic,strong) NSString               *avatar;
@property (nonatomic,strong) MBProgressHUD          *hud;
@end

@implementation IMeInfoTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"个人信息";
    _imageflag = false;
    [self setUpView];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(saveButtonClicked)];}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setUpView{
    _orgUser = [Config getOrgUser];
    [_avatarImage loadPortrait:_orgUser.avatar];
    _nameLabel.text = _orgUser.name;
    _emailLabel.text = _orgUser.email;
    _wechatLabel.text = _orgUser.wechat;
    _areaLabel.text = _orgUser.area;
    _titleLabel.text = _orgUser.title;
    if (_orgUser.sex == 0) {
        _sexLabel.text = @"男";
    }else{
        _sexLabel.text = @"女";
    }
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
    }else if([indexPath section] == 1){
        if ([indexPath row] == 0) {
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"OMeViewController" bundle:nil];
            OAreaUpdateViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"OArea"];
            vc.hidesBottomBarWhenPushed = YES;
            vc.view.backgroundColor = [UIColor whiteColor];
            vc.delegate = self;
            vc.model = _areaLabel.text;
            [self.navigationController pushViewController:vc animated:YES];
        }
        else if([indexPath row] == 1){
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"IMe" bundle:nil];
            BindEmailViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"BindEmail"];
            vc.hidesBottomBarWhenPushed = YES;
            vc.view.backgroundColor = [UIColor whiteColor];
            vc.model = _emailLabel.text;
            vc.delegate = self;
            if ([NSStringUtils isEmpty:_emailLabel.text]) {
                vc.type = 2;
            }else{
                vc.type = 1;
            }
            [self.navigationController pushViewController:vc animated:YES];
        }else if([indexPath row] == 2){
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"OMeViewController" bundle:nil];
            OWeChatUpdateViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"OWeChat"];
            vc.hidesBottomBarWhenPushed = YES;
            vc.view.backgroundColor = [UIColor whiteColor];
            vc.delegate = self;
            vc.model = _wechatLabel.text;
            [self.navigationController pushViewController:vc animated:YES];
        }else if([indexPath row] == 3){
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"IMe" bundle:nil];
            MeTitleUpdateViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"MeTitle"];
            vc.hidesBottomBarWhenPushed = YES;
            vc.view.backgroundColor = [UIColor whiteColor];
            vc.delegate = self;
            vc.model = _titleLabel.text;
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

- (void)wechatUpdate:(NSString *)wechat{
    _wechatLabel.text = wechat;
}

- (void)titleUpdate:(NSString *)title{
    _titleLabel.text = title;
}

- (void)emailUpdate:(NSString *)email{
    _emailLabel.text = email;
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
    NSString *userId = [NSString stringWithFormat:@"%lld",[Config getOwnID]];;
    NSString *token = [Config getToken];
    NSString *dbid = [NSString stringWithFormat:@"%ld",[Config getDbID]];
    NSString *orgId = [NSString stringWithFormat:@"%ld",[Config getOrgUserID]];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    
    NSString* urlStr = [NSString stringWithFormat:@"%@%@",BASE_URL,API_COMMON_QINIU_KEY_TOKEN];
    NSString *key = [@"head_" stringByAppendingString:dbid];
    key = [key stringByAppendingString:@"_"];
    key = [key stringByAppendingString:orgId];
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
    
    NSString *dbid = [NSString stringWithFormat:@"%ld",[Config getDbID]];
    NSString *orgId = [NSString stringWithFormat:@"%ld",[Config getOrgUserID]];
    NSString *key = [@"head_" stringByAppendingString:dbid];
    key = [key stringByAppendingString:@"_"];
    key = [key stringByAppendingString:orgId];
    
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
    _orgUser.name = _nameLabel.text;
    _orgUser.area = _areaLabel.text;
//    _orgUser.email = _emailLabel.text;
    _orgUser.wechat = _wechatLabel.text;
    _orgUser.title = _titleLabel.text;
    if ([_sexLabel.text isEqualToString:@"男"]) {
        _orgUser.sex = 0;
    }else{
        _orgUser.sex = 1;
    }
    if (_imageflag) {
        _orgUser.avatar = _avatar;
    }
    NSDictionary *editval = _orgUser.mj_keyValues;
    _hud.label.text = @"修改中";
    NSString *userId = [NSString stringWithFormat:@"%ld",[Config getOrgUserID]];;
    NSString *token = [Config getToken];
    NSString *dbid = [NSString stringWithFormat:@"%ld",[Config getDbID]];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    NSString* urlStr = [NSString stringWithFormat:@"%@%@",BASE_URL,API_ORGUSER_INFO_SAVE];
    NSMutableURLRequest *request = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:urlStr parameters:editval                                                                                   error:nil];
    
    [request addValue:userId forHTTPHeaderField:@"userId"];
    [request addValue:token forHTTPHeaderField:@"token"];
    [request addValue:dbid forHTTPHeaderField:@"dbid"];
    
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
                    [Config saveOrgProfile:_orgUser];
                    _hud.label.text = @"修改成功";
                    NSNotification *notice = [NSNotification notificationWithName:@"updateOrgUserInfo" object:nil];
                    [[NSNotificationCenter defaultCenter]postNotification:notice];
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
