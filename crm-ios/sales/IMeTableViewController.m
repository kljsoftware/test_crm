//
//  IMeTableViewController.m
//  sales
//
//  Created by user on 2017/1/3.
//  Copyright © 2017年 rayootech. All rights reserved.
//

#import "IMeTableViewController.h"
#import "FirstDeptTableViewController.h"
#import "OrgUserInfo.h"
#import "ColleagueTableViewController.h"
#import "SetLeaderTableViewController.h"
#import "IMeInfoTableViewController.h"

@interface IMeTableViewController () <SetLeaderDelegate>

@property (nonatomic,weak) IBOutlet UIImageView          *avatarImage;
@property (nonatomic,weak) IBOutlet UILabel              *nameLabel;
@property (nonatomic,weak) IBOutlet UILabel              *mobileLabel;
@property (weak, nonatomic) IBOutlet UIButton *quitTeamBtn;
@property (nonatomic,strong) OrgUserInfo                 *myinfo;
@end

@implementation IMeTableViewController
- (instancetype)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        self = [[UIStoryboard storyboardWithName:@"IMain" bundle:nil] instantiateInitialViewController];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpView];
    [self getLeader];
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(updateInfo) name:@"updateOrgUserInfo" object:nil];
}

- (void)updateInfo{
    [self setUpView];
}
- (void)setUpView{
    _quitTeamBtn.layer.cornerRadius = 5;
    _quitTeamBtn.layer.masksToBounds = YES;
    _myinfo = [Config getOrgUser];
    [_avatarImage loadPortrait:_myinfo.avatar];
    _avatarImage.layer.cornerRadius = 24;
    _avatarImage.layer.masksToBounds = true;
    _nameLabel.text = _myinfo.name;
    _mobileLabel.text = [NSString stringWithFormat:@"手机号码：%@",_myinfo.mobile];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"IMe" bundle:nil];
            IMeInfoTableViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"IMeInfo"];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        
    } else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            ColleagueTableViewController *vc = [[ColleagueTableViewController alloc] init];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
            
        } else if ([indexPath row] == 1) {
            FirstDeptTableViewController *vc = [[FirstDeptTableViewController alloc] init];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
            
        } else if ([indexPath row] == 2) {
            SetLeaderTableViewController *vc = [[SetLeaderTableViewController alloc] init];
            vc.hidesBottomBarWhenPushed = YES;
            vc.delegate = self;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0.1;
    }
    return 5;
}

- (void)getLeader{
    NSString *userId = [NSString stringWithFormat:@"%ld",[Config getOrgUserID]];;
    NSString *token = [Config getToken];
    NSString *dbid = [NSString stringWithFormat:@"%ld",[Config getDbID]];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    
    NSString* urlStr = [NSString stringWithFormat:@"%@%@",BASE_URL,API_COLLEAGUE_GETLEADER];
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"POST" URLString:urlStr parameters:@{}                                                                                    error:nil];
    [request addValue:userId forHTTPHeaderField:@"userId"];
    [request addValue:token forHTTPHeaderField:@"token"];
    [request addValue:dbid forHTTPHeaderField:@"dbid"];
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id _Nonnull responseObject, NSError *error) {
        if (error) {
            NSLog(@"Error:-->%@", error);
            
        } else {
            NSString *responseString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            NSLog(@"DATA-->%@", responseString);
            if (responseObject) {
                NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
                if ([dictionary[@"result"] intValue] == 1) {
                    OrgUserInfo *orguser = [OrgUserInfo mj_objectWithKeyValues:dictionary[@"data"]];
//                    _leaderLabel.text = orguser.name;
                }else{
                    
                }
            }else{
                
            }
        }
    }];
    [dataTask resume];
}

- (void)setLeader:(NSString *)name{
//    _leaderLabel.text = name;
}

- (IBAction)quitTeamClicked:(UIButton *)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"确定要退出该组织吗？" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *sure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[RCIMClient sharedRCIMClient] logout];
        [NSThread sleepForTimeInterval:0.5];
        [(AppDelegate *)[UIApplication sharedApplication].delegate showWindow:@"omain" showOrgList:true];
    }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:sure];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:^{}];
}

@end
