
//
//  CirclePublishViewController.m
//  sales
//
//  Created by user on 2016/11/24.
//  Copyright © 2016年 rayootech. All rights reserved.
//

#import "CirclePublishViewController.h"
#import "ImagePickerView.h"
#import "OMeViewController.h"
#import "Config.h"
#import "SalesApi.h"
#import "Url.h"
#import "PlaceholderTextView.h"

#define kScreenWidth        [[UIScreen mainScreen] bounds].size.width
#define kScreenHeight       [[UIScreen mainScreen] bounds].size.height
@interface CirclePublishViewController ()
@property (weak, nonatomic) IBOutlet UIView *photoView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *photoViewHieghtConstraint;
@property (nonatomic,weak)  IBOutlet PlaceholderTextView *contentView;
@property (nonatomic,strong) ImagePickerView *pickerView;
@property (nonatomic,strong) UIButton *button;
@property (nonatomic,assign) NSInteger count;
@property (nonatomic,strong) MBProgressHUD *HUD;
@end

@implementation CirclePublishViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _count = 0;
    self.title = @"圈子发布";
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"发送" style:UIBarButtonItemStylePlain target:self action:@selector(sendButtonClicked)];
    
    [self setUpView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setUpView{
    //imagePickerView parameter settings
    _contentView.placeholder = @"圈子内容";
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
}

- (void)sendButtonClicked{
//    [self getQiniuNoKeyToken];
    _HUD = [Utils createHUD];
    
    NSString *comStr = self.contentView.text;
    comStr = [comStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (comStr.length <= 0) {
        NSLog(@"----");
        _HUD.label.text = @"圈子内容不能为空";
        [_HUD hideAnimated:YES afterDelay:1];
        return;
    }
    _HUD.label.text = @"圈子发送中";
    NSArray<UIImage *> *datas = [_pickerView getPhotos];
    if (datas != nil && datas.count > 0) {
        [self getQiniuNoKeyToken];
    }else{
        [self publishCircle:@""];
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
                [self publishCircle:json];
            }
        } option:uploadOption];
    }
}

- (void)publishCircle:(NSString *)picurl{
    NSString *userId = [NSString stringWithFormat:@"%lld",[Config getOwnID]];;
    NSString *token = [Config getToken];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    
    NSString* urlStr = [NSString stringWithFormat:@"%@%@",BASE_URL,API_CIRCLE_NEW];
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"POST" URLString:urlStr parameters:@{@"content":_contentView.text,@"picurl":picurl}                                                                                    error:nil];
    [request addValue:userId forHTTPHeaderField:@"userId"];
    [request addValue:token forHTTPHeaderField:@"token"];
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id _Nonnull responseObject, NSError *error) {
        if (error) {
            _HUD.label.text = @"发送失败";
        } else {
            
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
