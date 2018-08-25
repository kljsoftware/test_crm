//
//  WorkUnreadTableViewController.m
//  sales
//
//  Created by user on 2017/4/14.
//  Copyright © 2017年 rayootech. All rights reserved.
//

#import "WorkUnreadTableViewController.h"
#import "WorkUnreadTableViewCell.h"
#import "WorkUnreadDetailsTableViewController.h"
#define kWorkUnreadTableCellId @"WorkUnreadTableViewCell"
@interface WorkUnreadTableViewController ()

@property (nonatomic,strong) NSMutableArray *dataModels;

@end

@implementation WorkUnreadTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"消息列表";
    self.tableView.rowHeight = 80;
    self.dataModels = [FileUtils inReadDataFromFile:UnreadWorkList];
    self.tableView.tableFooterView = [[UIView alloc] init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(self.dataModels.count == 0){
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }else{
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    }
    
    return self.dataModels.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WorkUnreadTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kWorkUnreadTableCellId];
    if (!cell) {
        cell = [[WorkUnreadTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kWorkUnreadTableCellId];
    }
    cell.model = self.dataModels[indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    [cell setSeparatorInset:UIEdgeInsetsZero];
    [cell setLayoutMargins:UIEdgeInsetsZero];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    WorkUnreadDetailsTableViewController *vc = [[WorkUnreadDetailsTableViewController alloc] init];
    vc.work = self.dataModels[indexPath.row];
    vc.hidesBottomBarWhenPushed = YES;
    vc.view.backgroundColor = [UIColor whiteColor];
    [self.navigationController pushViewController:vc animated:YES];
}
- (NSMutableArray *)dataModels {
    if(_dataModels == nil) {
        _dataModels = [NSMutableArray array];
    }
    return _dataModels;
}


@end
