//
//  SettingTableViewController.m
//  sales
//
//  Created by user on 2017/4/14.
//  Copyright © 2017年 rayootech. All rights reserved.
//

#import "SettingTableViewController.h"
#import "UpdatePasswordViewController.h"
@interface SettingTableViewController ()

@end

@implementation SettingTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"设置";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    NSIndexPath *index = [[NSIndexPath alloc] initWithIndex:section];
    if (index.section == 0) {
        return 0.1;
    }
    return 20;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([indexPath section] == 0) {
        if ([indexPath row] == 0) {
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"OMeViewController" bundle:nil];
            UpdatePasswordViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"UpdatePassword"];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}
@end
