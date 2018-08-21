//
//  OMeViewController.m
//  sales
//
//  Created by user on 2016/11/3.
//  Copyright © 2016年 rayootech. All rights reserved.
//

#import "OMeViewController.h"
#import "User.h"
#import "OMeInfoTableViewController.h"
#import "SettingTableViewController.h"
#import "OrganizationTableViewController.h"
@interface OMeViewController ()
@property (nonatomic,weak) IBOutlet UIImageView          *avatarImage;
@property (nonatomic,weak) IBOutlet UILabel              *nameLabel;
@property (nonatomic,weak) IBOutlet UILabel              *mobileLabel;
@property (nonatomic,strong) UIButton                    *button;
@end

@implementation OMeViewController

- (instancetype)initWithStyle:(UITableViewStyle)style
{
    
    return [[UIStoryboard storyboardWithName:@"OMeViewController" bundle:nil] instantiateInitialViewController];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpView];
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(updateUserInfo) name:@"updateUserInfo" object:nil];
}

- (void)updateUserInfo{
    [self setUpView];
}
- (void)supportClicked:(id)sender{
    UIButton *button = (UIButton *)sender;
    button.selected = !button.selected;
    OMeViewController *vc = [OMeViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)setUpView{
    User *user = [Config getUser];
    _avatarImage.layer.cornerRadius = 24;
    _avatarImage.layer.masksToBounds = true;
    [_avatarImage loadPortrait:user.avatar];
    _nameLabel.text = user.name;
    _mobileLabel.text = [NSString stringWithFormat:@"手机号码：%@",user.mobile];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    if ([indexPath section] == 0) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"OMeViewController" bundle:nil];
        OMeInfoTableViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"OMeInfo"];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    
    } else if ([indexPath section] == 1) {
        if ([indexPath row] == 0) {
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"OMeViewController" bundle:nil];
            SettingTableViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"Setting"];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
            
        } else if ([indexPath row] == 1) {
            OrganizationTableViewController *vc = [[OrganizationTableViewController alloc] init];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
    
    } else if ([indexPath section] == 2) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"退出" message:@"确定要退出移动互联吗？" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *sure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [tableView deselectRowAtIndexPath:indexPath animated:NO];
            [Config setOwnID:0];
            [(AppDelegate *)[UIApplication sharedApplication].delegate showWindowLogin:@"logout"];
        }];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [tableView deselectRowAtIndexPath:indexPath animated:NO];
        }];
        [alert addAction:sure];
        [alert addAction:cancel];
        [self presentViewController:alert animated:YES completion:^{}];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    NSIndexPath *index = [[NSIndexPath alloc] initWithIndex:section];
    if (index.section == 0) {
        return 0.1;
    }
    return 5;
}
@end
