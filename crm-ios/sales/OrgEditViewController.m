//
//  OrgEditViewController.m
//  sales
//
//  Created by user on 2017/4/19.
//  Copyright © 2017年 rayootech. All rights reserved.
//

#import "OrgEditViewController.h"
#import "TZImagePickerController.h"

@interface OrgEditViewController () <TZImagePickerControllerDelegate>

@property (nonatomic,weak) IBOutlet UIImageView         *logoImage;
@property (nonatomic,weak) IBOutlet UITextField         *nameText;
@property (nonatomic,weak) IBOutlet UITextField         *desText;
@property (nonatomic,strong) MBProgressHUD              *hud;
@property (nonatomic,assign) BOOL                       imageflag;
@property (nonatomic,strong) UIImage                    *image;

@property (nonatomic,strong) NSString                   *oid;
@property (nonatomic,strong) NSString                   *name;
@property (nonatomic,strong) NSString                   *desc;
@property (nonatomic,strong) NSString                   *logo;
@end

@implementation OrgEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"编辑组织";
    _imageflag = false;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(saveButtonClicked)];
    _logoImage.userInteractionEnabled = YES;
    UILongPressGestureRecognizer *gesturRecognizer=[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(choosePicture:)];
    gesturRecognizer.minimumPressDuration = 0;
    [_logoImage addGestureRecognizer:gesturRecognizer];
}

- (void)setOrganizations:(Organizations *)organization{
    _organizations = organization;
    _logo = organization.logo;
    if (_logo == nil) {
        _logo = @"";
    }
    [_logoImage loadPortrait:_logo];
    _nameText.text = organization.name;
    _desText.text = organization.Description;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (void)choosePicture:(UITapGestureRecognizer *)rec{
    if (rec.state == UIGestureRecognizerStateBegan) {
    }else if(rec.state == UIGestureRecognizerStateEnded){
        TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:self];
        imagePickerVc.allowCrop = YES;
        [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL flag) {
            _logoImage.image = photos[0];
            _image = photos[0];
            _imageflag = true;
            
        }];
        [self presentViewController:imagePickerVc animated:YES completion:nil];

    }
}

- (void)saveButtonClicked{
    _hud = [Utils createHUD];
    _name = _nameText.text;
    _desc = _desText.text;
    _oid = [NSString stringWithFormat:@"%ld",_organizations.id];
    if ([NSStringUtils isEmpty:_name]) {
        _hud.label.text = @"名称不能为空";
        [_hud hideAnimated:YES afterDelay:1];
        return;
    }
    if ([NSStringUtils isEmpty:_desc]) {
        _hud.label.text = @"描述不能为空";
        [_hud hideAnimated:YES afterDelay:1];
        return;
    }
    if (_imageflag) {
        [self getQiniuNoKeyToken];
    }else{
        [self orgEdit:_oid Name:_name Desc:_desc Logo:@""];
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
            _hud.label.text = @"编辑失败";
            [_hud hideAnimated:YES afterDelay:1];
        } else {
            
            if (responseObject) {
                NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
                if ([dictionary[@"result"] intValue] == 1) {
                    [self upload:dictionary[@"uptoken"] ];
                    
                }else{
                    _hud.label.text = @"发送失败";
                    [_hud hideAnimated:YES afterDelay:1];
                }
            }else{
                _hud.label.text = @"发送失败";
                [_hud hideAnimated:YES afterDelay:1];
            }
        }
        
    }];
    [dataTask resume];
    
}

- (void) upload:(NSString *)token{
    NSString *filepath = [self getImagePath:_image];
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
            _hud.label.text = @"发送失败";
            [_hud hideAnimated:YES afterDelay:1];
            return ;
        }
        
        _logo = resp[@"key"];
        NSDate *date = [NSDate new];
        NSString *time = [NSString stringWithFormat:@"%ld",(long)[date timeIntervalSince1970]];
        _logo = [_logo stringByAppendingString:@"?v="];
        _logo = [_logo stringByAppendingString:time];
        [self orgEdit:_oid Name:_name Desc:_desc Logo:_logo];
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

- (void)orgEdit:(NSString *)oid Name:(NSString *)name Desc:(NSString *)desc Logo:(NSString *)logo{
    NSString *userId = [NSString stringWithFormat:@"%lld",[Config getOwnID]];;
    NSString *token = [Config getToken];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    
    NSString* urlStr = [NSString stringWithFormat:@"%@%@",BASE_URL,API_ORGANIZATION_EDIT];
    
    
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"POST" URLString:urlStr parameters:@{@"name":name,@"description":desc,@"logo":logo,@"oid":oid}                                                                                    error:nil];
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
                    _hud.label.text = @"编辑成功";
                    [_hud hideAnimated:YES afterDelay:1];
                    _organizations.name = _name;
                    _organizations.Description = _desc;
                    _organizations.logo = _logo;
                    [_delegate editOrganization:_organizations];
                    NSNotification *notice = [NSNotification notificationWithName:@"updateOrganizationList" object:nil];
                    [[NSNotificationCenter defaultCenter]postNotification:notice];
                    if (self.navigationController.viewControllers.count <= 1) {
                        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
                    } else {
                        [self.navigationController popViewControllerAnimated:YES];
                    }
                }else{
                    _hud.label.text = @"编辑失败";
                    [_hud hideAnimated:YES afterDelay:1];
                }
            }else{
                _hud.label.text = @"编辑失败";
                [_hud hideAnimated:YES afterDelay:1];
            }
        }
    }];
    [dataTask resume];
}
@end
