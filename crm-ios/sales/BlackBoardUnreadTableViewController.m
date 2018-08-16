//
//  BlackBoardUnreadTableViewController.m
//  sales
//
//  Created by user on 2017/3/20.
//  Copyright © 2017年 rayootech. All rights reserved.
//

#import "BlackBoardUnreadTableViewController.h"
#import "FileUtils.h"
#import "PreferUtil.h"
#import "BlackBoardUnreadTableViewCell.h"
#import "BlackBoardUnreadDetailsTableViewController.h"
#define kBlackBoardUnreadTableCellId @"BlackBoardUnreadTableViewCell"
@interface BlackBoardUnreadTableViewController ()

@property (nonatomic,strong) NSMutableArray *dataModels;

@end

@implementation BlackBoardUnreadTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"消息列表";
    self.tableView.rowHeight = 80;
    self.dataModels = [FileUtils inReadDataFromFile:UnreadBlackBoardList];
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
    BlackBoardUnreadTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kBlackBoardUnreadTableCellId];
    if (!cell) {
        cell = [[BlackBoardUnreadTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kBlackBoardUnreadTableCellId];
    }
    cell.model = self.dataModels[indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BlackBoardUnreadDetailsTableViewController *vc = [[BlackBoardUnreadDetailsTableViewController alloc] init];
    vc.comment = self.dataModels[indexPath.row];
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
