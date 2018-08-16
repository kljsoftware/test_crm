//
//  WorkStaffTableViewController.m
//  sales
//
//  Created by user on 2017/4/12.
//  Copyright © 2017年 rayootech. All rights reserved.
//

#import "WorkStaffTableViewController.h"
#import "WorkStaffDbUtil.h"
#import "ColleagueTableViewCell.h"
@interface WorkStaffTableViewController ()
@property (nonatomic,strong) NSMutableArray     *dataModels;
@property (nonatomic,strong) WorkStaffDbUtil    *staffDb;
@end

@implementation WorkStaffTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"参与同事";
    self.tableView.rowHeight = [ColleagueTableViewCell fixedHeight];
    self.tableView.sectionIndexColor = [UIColor lightGrayColor];
    self.tableView.sectionIndexBackgroundColor = [UIColor clearColor];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    _staffDb = [[WorkStaffDbUtil alloc] init];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setWork:(Work *)work{
    _work = work;
    [self getLocalData];
}

- (void)getLocalData{
    NSMutableArray *temp = [_staffDb selectAllByWorkId:_work.id];
    self.dataModels = temp.mutableCopy;
    [self.tableView reloadData];
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
    static NSString *ID = @"Colleague";
    ColleagueTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[ColleagueTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    OrgUserInfo *model = self.dataModels[indexPath.row];
    model.avatar = model.picurl;
    cell.model = model;
    return cell;
    
}

@end
