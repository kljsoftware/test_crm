//
//  OrganizationTableViewController.m
//  sales
//
//  Created by user on 2016/12/30.
//  Copyright © 2016年 rayootech. All rights reserved.
//

#import "OrganizationTableViewController.h"
#import "OrganizationTableViewCell.h"
#import "OrganizationInviteDefaultCell.h"
#import "OrganizationViewController.h"
#import "OrgInviteViewController.h"

#import "OrganizationInviteDealTableViewController.h"
#import "OrganizationCreateViewController.h"

#import "OrgInvite.h"

@interface OrganizationTableViewController ()

@property (nonatomic,strong) NSMutableArray *dataArray;

@end

@implementation OrganizationTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的组织";
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"添加" style:UIBarButtonItemStylePlain target:self action:@selector(createButtonClicked)];
    
    self.tableView.rowHeight = 60;
    self.tableView.tableFooterView = [UIView new];
    [self.tableView registerNib:[UINib nibWithNibName:@"OrganizationInviteDefaultCell" bundle:nil] forCellReuseIdentifier:@"kOrganizationInviteDefaultCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"OrganizationTableViewCell" bundle:nil] forCellReuseIdentifier:@"kOrganizationTableViewCell"];

    [self requestData];
}

- (void)requestData {
    
    NSString* urlStr = [NSString stringWithFormat:@"%@%@",BASE_URL,API_ORGANIZATION_LIST];
    NSDictionary *requestHeader = @{@"userId":[NSString stringWithFormat:@"%lld",[Config getOwnID]], @"token":[Config getToken]};
    WeakSelf;
    [NetWorkManager request:POST_METHOD URL:urlStr requestHeader:requestHeader parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSArray* data = responseObject[@"data"];
        weakSelf.dataArray = [Organizations mj_objectArrayWithKeyValuesArray:data];
        [weakSelf.tableView reloadData];

    } failure:^(NSURLSessionDataTask *task, BIUPError *error) {
        weakSelf.hud = [Utils createHUD];
        weakSelf.hud.label.text = error.message;
        [weakSelf.hud hideAnimated:YES afterDelay:1];
    }];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    } else {
        return self.dataArray.count;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        OrganizationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"kOrganizationInviteDefaultCell" forIndexPath:indexPath];
        return cell;
        
    } else {
        OrganizationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"kOrganizationTableViewCell" forIndexPath:indexPath];
        Organizations *model = self.dataArray[indexPath.row];
        [cell.headerImgView loadPortrait:model.logo];
        cell.nameLabel.text = model.name;
        return cell;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 1 && self.dataArray.count > 0) {
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 40)];
        headerView.backgroundColor = [UIColor colorWithHex:0xf2f2f2];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, [UIScreen mainScreen].bounds.size.width-40, 40)];
        label.textColor = SDColor(128, 128, 128, 1);
        label.text = @"我加入的组织";
        label.font = [UIFont systemFontOfSize:14];
        [headerView addSubview:label];
        return headerView;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 1 && self.dataArray.count > 0) {
        return 40;
    }
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    if (indexPath.section == 0) {
        
        
    } else {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"OMeViewController" bundle:nil];
        OrganizationViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"OrganizationDetails"];
        vc.hidesBottomBarWhenPushed = YES;
        vc.organizations = self.dataArray[indexPath.row];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)createButtonClicked {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"OMeViewController" bundle:nil];
    OrganizationCreateViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"OrganizationCreate"];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
