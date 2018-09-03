//
//  CircleUnreadTableViewController.m
//  sales
//
//  Created by user on 2017/3/13.
//  Copyright © 2017年 rayootech. All rights reserved.
//

#import "CircleUnreadTableViewController.h"
#import "CircleUnreadTableViewCell.h"
#import "CircleUnreadDetailsTableViewController.h"
#define kCircleUnreadTableCellId @"CircleUnreadTableViewCell"

@interface CircleUnreadTableViewController ()

@property (nonatomic,strong) NSMutableArray *dataModels;

@end

@implementation CircleUnreadTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"消息列表";
    self.tableView.rowHeight = 80;
    self.dataModels = [self readDataFromFile];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#define PATH_OF_DOCUMENT    [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]

#define CIRCLE          @"circle"
#define BLACKBOARD      @"blackboard"
#define WORK            @"work"

- (void)setType:(NSString *)type{
    _type = type;
}

- (NSMutableArray *)readDataFromFile{
    NSString *filename = [UnreadCircleList stringByAppendingString:[NSString stringWithFormat:@"%lld",[Config getOwnID]]];
    filename = [PATH_OF_DOCUMENT stringByAppendingPathComponent:filename];
    NSData *tempData = [NSData dataWithContentsOfFile:filename options:0 error:NULL];
    NSMutableArray *temp = [NSKeyedUnarchiver unarchiveObjectWithData:tempData];
    if (temp == nil) {
        temp = [NSMutableArray new];
    }
    return temp;
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
    CircleUnreadTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCircleUnreadTableCellId];
    if (!cell) {
        cell = [[CircleUnreadTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCircleUnreadTableCellId];
    }
    cell.model = self.dataModels[indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CircleUnreadDetailsTableViewController *vc = [[CircleUnreadDetailsTableViewController alloc] init];
    vc.comment = self.dataModels[indexPath.row];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    [cell setSeparatorInset:UIEdgeInsetsZero];
    [cell setLayoutMargins:UIEdgeInsetsZero];
}
- (NSMutableArray *)dataModels {
    if(_dataModels == nil) {
        _dataModels = [NSMutableArray array];
    }
    return _dataModels;
}

@end
