//
//  AddContactViewController.m
//  sales
//
//  Created by user on 2016/12/2.
//  Copyright © 2016年 rayootech. All rights reserved.
//

#import "AddContactViewController.h"
#import "EnteringContactViewController.h"
#import "PackageAPI.h"
#import "XMLUtil.h"

#define ERROR_OK @"1"
#define ERROR_SERVER @"服务器请求超时，请重试"
#define ERROR_NULL @"识别结果为空，请重新拍照或者导入"
#define ERROR_TIMEOUT @"识别错误，请检查手机时间"
#define ERROR_NotReachable @"无网络连接，请连接网络"
@interface AddContactViewController () <MFMessageComposeViewControllerDelegate,MFMailComposeViewControllerDelegate>
@property (nonatomic,strong) UIImagePickerController    *pickerController;
@property (nonatomic,strong) UIImageView                *positiveImageView;
@property (nonatomic,strong) NSString                   *resultStr;
@property (nonatomic,strong) NSString                   *dataStr;
@property (nonatomic,strong) MBProgressHUD              *hud;
@end

@implementation AddContactViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"添加联系人";
    _positiveImageView = [UIImageView new];
    _positiveImageView.image = [UIImage imageNamed:@"cardtext"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (void)takePhoto {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        _pickerController = [[UIImagePickerController alloc] init];
        _pickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
        _pickerController.delegate = self;
        _pickerController.showsCameraControls = YES;
        
        [self presentModalViewController:_pickerController animated:YES];
        
    }
    else
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"由于您的设备暂不支持摄像头，您无法使用该功能!" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确认", nil];
        [alertView show];
    }
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *image;
    //	NSString *currSysVer = [[UIDevice currentDevice] systemVersion];
    image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    
    UIImageOrientation orientation = [image imageOrientation];
    
    CGImageRef imRef = [image CGImage];
    int texWidth = CGImageGetWidth(imRef);
    int texHeight = CGImageGetHeight(imRef);
    
    float imageScale = 1;
    
    if(orientation == UIImageOrientationUp && texWidth < texHeight)
        image = [UIImage imageWithCGImage:imRef scale:imageScale orientation: UIImageOrientationLeft];
    else if((orientation == UIImageOrientationUp && texWidth > texHeight) || orientation == UIImageOrientationRight)
        image = [UIImage imageWithCGImage:imRef scale:imageScale orientation: UIImageOrientationUp];
    else if(orientation == UIImageOrientationDown)
        image = [UIImage imageWithCGImage:imRef scale:imageScale orientation: UIImageOrientationDown];
    else if(orientation == UIImageOrientationLeft)
        image = [UIImage imageWithCGImage:imRef scale:imageScale orientation: UIImageOrientationUp];
    
    NSLog(@"originalImage width = %f height = %f",image.size.width,image.size.height);
    
    [_positiveImageView setImage:image];
    [self startRec];
    //currentTag = 0;
    [picker dismissModalViewControllerAnimated:YES];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissModalViewControllerAnimated:YES];
}

- (void)startRec
{
    NSData *sendImageData = UIImageJPEGRepresentation(self.positiveImageView.image, 0.75);
    
    NSUInteger sizeOrigin = [sendImageData length];
    NSUInteger sizeOriginKB = sizeOrigin / 1024;
    if (sizeOriginKB > 5*1024)
    {
//        [self dismissPresentSheet];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"图片大小超过5M，请重试"
                                                       delegate:nil
                                              cancelButtonTitle:nil
                                              otherButtonTitles:@"确定", nil];
        
        [alert show];
        return;
    }
    
//    [self dismissPresentSheet];
    _hud = [Utils createHUD];
    _hud.label.text = @"识别中";
    dispatch_source_t timer=dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_main_queue());
    
    dispatch_source_set_timer(timer, dispatch_time(DISPATCH_TIME_NOW, 0ull*NSEC_PER_SEC), DISPATCH_TIME_FOREVER, 1ull*NSEC_PER_SEC);
    
    dispatch_source_set_event_handler(timer, ^{
        PackageAPI *package = [[PackageAPI alloc] init];
        
        self.resultStr = [package uploadPackage:sendImageData andindexPath:0];
        [self performSelectorOnMainThread:@selector(recongnitionResult:) withObject:self.resultStr waitUntilDone:YES];
        dispatch_source_cancel(timer);
    });
    
    dispatch_source_set_cancel_handler(timer, ^{
        
    });
    //启动
    dispatch_resume(timer);
}

-(void)recongnitionResult:(id)sender
{
    _dataStr= sender;
    //    [SVProgressHUD dismiss];
    [_hud hideAnimated:YES afterDelay:1];
    if ([_dataStr length])
    {
        if ([_dataStr isEqualToString:ERROR_SERVER]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                            message:ERROR_SERVER
                                                           delegate:nil
                                                  cancelButtonTitle:nil
                                                  otherButtonTitles:@"确定", nil];
            
            [alert show];
            return;
        }
        if ([_dataStr isEqualToString:ERROR_TIMEOUT]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                            message:ERROR_TIMEOUT
                                                           delegate:nil
                                                  cancelButtonTitle:nil
                                                  otherButtonTitles:@"确定", nil];
            
            [alert show];
            return;
        }
        if ([_dataStr isEqualToString:ERROR_NULL]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                            message:ERROR_NULL
                                                           delegate:nil
                                                  cancelButtonTitle:nil
                                                  otherButtonTitles:@"确定", nil];
            
            [alert show];
            return;
        }
        NSLog(@"result:%@",_dataStr);
        XMLUtil *xml = [[XMLUtil alloc] init];
        [xml parse:_dataStr];

        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Contact" bundle:nil];
        EnteringContactViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"EnteringContact"];
        vc.hidesBottomBarWhenPushed = YES;
        vc.view.backgroundColor = [UIColor whiteColor];
        vc.map = [xml getMap];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:ERROR_NULL
                                                       delegate:nil
                                              cancelButtonTitle:nil
                                              otherButtonTitles:@"确定", nil];
        
        [alert show];
        return;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([indexPath section] == 0) {
        if ([indexPath row] == 1) {
            [tableView deselectRowAtIndexPath:indexPath animated:NO];
            [self takePhoto];
        }
    }else if([indexPath section] == 1){
        if ([indexPath row] == 0) {
            [tableView deselectRowAtIndexPath:indexPath animated:NO];
            [self showMessageView];
        }
        if ([indexPath row] == 1){
            [tableView deselectRowAtIndexPath:indexPath animated:NO];
            [self showEmailView];
        }
    }
    
}

- (void)showMessageView{
    if ([MFMessageComposeViewController canSendText]) {
        MFMessageComposeViewController *controller = [[MFMessageComposeViewController alloc] init];
        controller.body = @"您好，欢迎使用移动互联，您可以在App Store中搜索 移动互联，下载安装";
        controller.messageComposeDelegate = self;
        [self presentViewController:controller animated:YES completion:nil];
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"该设备不支持短信功能" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result{
    [self dismissViewControllerAnimated:YES completion:nil];
    switch (result) {
        case MessageComposeResultSent:
            
            break;
            
        default:
            break;
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)showEmailView{
    if ([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *controller = [[MFMailComposeViewController alloc] init];
        controller.mailComposeDelegate = self;
        [controller setSubject:@"欢迎使用移动互联"];
        [controller setMessageBody:@"您好，欢迎使用移动互联，您可以在App Store中搜索 移动互联，下载安装" isHTML:NO];
        [self presentViewController:controller animated:YES completion:nil];
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"该设备不支持邮件功能" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error{
    [self dismissViewControllerAnimated:YES completion:nil];
    switch (result) {
        case MFMailComposeResultSent:
            
            break;
            
        default:
            break;
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
