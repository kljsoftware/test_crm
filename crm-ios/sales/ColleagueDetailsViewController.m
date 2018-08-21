//
//  ColleagueDetailsViewController.m
//  sales
//
//  Created by user on 2017/2/24.
//  Copyright © 2017年 rayootech. All rights reserved.
//

#import "ColleagueDetailsViewController.h"
#import "OConversationViewController.h"

@interface ColleagueDetailsViewController ()

@property (nonatomic,weak) IBOutlet UILabel *nameLabel;
@property (nonatomic,weak) IBOutlet UILabel *mobileLabel;
@property (nonatomic,weak) IBOutlet UILabel *sexLabel;
@property (nonatomic,weak) IBOutlet UILabel *areaLabel;
@property (nonatomic,weak) IBOutlet UILabel *emailLabel;
@property (nonatomic,weak) IBOutlet UILabel *wechatLabel;
@property (nonatomic,weak) IBOutlet UILabel *titleLabel;

@end

@implementation ColleagueDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"同事详情";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setOrgUserInfo:(OrgUserInfo *)orgUserInfo{
    _orgUserInfo = orgUserInfo;
    [self setupData];
}

- (void)setupData{
    if ([NSStringUtils isEmpty:_orgUserInfo.name])
    _nameLabel.text = @"  ";
    else
        _nameLabel.text = _orgUserInfo.name;

    if ([NSStringUtils isEmpty:_orgUserInfo.mobile]) {
        _mobileLabel.text = @"  ";
    }else
        _mobileLabel.text = _orgUserInfo.mobile;
    
    if (_orgUserInfo.sex == 0) {
        _sexLabel.text = @"男";
    }else
        _sexLabel.text = @"女";
    
    if ([NSStringUtils isEmpty:_orgUserInfo.area]) {
        _areaLabel.text = @"  ";
    }else
        _areaLabel.text = _orgUserInfo.area;

    if ([NSStringUtils isEmpty:_orgUserInfo.email]) {
        _emailLabel.text = @"  ";
    }else
        _emailLabel.text = _orgUserInfo.email;
    
    if ([NSStringUtils isEmpty:_orgUserInfo.wechat]) {
        _wechatLabel.text = @"  ";
    }else
        _wechatLabel.text = _orgUserInfo.wechat;
    
    if ([NSStringUtils isEmpty:_orgUserInfo.title]) {
        _titleLabel.text = @"  ";
    }else
        _titleLabel.text = _orgUserInfo.title;
}

- (IBAction)chatTo{
    OConversationViewController *conversationVC = [[OConversationViewController alloc] init];
    conversationVC.conversationType = ConversationType_PRIVATE;
    NSString *id = [NSString stringWithFormat:@"%ld",_orgUserInfo.id];
    NSString *dbid = [NSString stringWithFormat:@"%ld",[Config getDbID]];
    NSString *targetID = [@"in_" stringByAppendingString:dbid];
    targetID = [targetID stringByAppendingString:@"_"];
    targetID = [targetID stringByAppendingString:id];
    conversationVC.targetId = targetID;
    conversationVC.displayUserNameInCell = NO;
    conversationVC.title = _orgUserInfo.name;
    conversationVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:conversationVC animated:YES];
}
@end
