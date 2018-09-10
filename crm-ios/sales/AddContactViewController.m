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

@interface AddContactViewController () <MFMessageComposeViewControllerDelegate, MFMailComposeViewControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
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
    self.tableView.tableFooterView = [UIView new];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 40)];
    headerView.backgroundColor = SDColor(242, 242, 242, 1);
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, [UIScreen mainScreen].bounds.size.width-40, 48)];
    label.textColor = SDColor(128, 128, 128, 1);
    label.text = section == 0 ? @"手动添加联系人" : @"邀请朋友使用销售链";
    label.font = [UIFont systemFontOfSize:15];
    [headerView addSubview:label];
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 48;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:true];

    if ([indexPath section] == 0) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Contact" bundle:nil];
        EnteringContactViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"EnteringContact"];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
        
    } else if ([indexPath section] == 1) {
        if ([indexPath row] == 0) {
            [self showMessageView];
            
        } else if ([indexPath row] == 1){
            [self showEmailView];
        }
    }
}

- (void)showMessageView{
    if ([MFMessageComposeViewController canSendText]) {
        MFMessageComposeViewController *controller = [[MFMessageComposeViewController alloc] init];
        controller.body = @"您好，欢迎使用Panda Link，您可以在App Store中搜索 Panda Link，下载安装";
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
        [controller setSubject:@"欢迎使用Panda Link"];
        [controller setMessageBody:@"您好，欢迎使用Panda Link，您可以在App Store中搜索 Panda Link，下载安装" isHTML:NO];
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
