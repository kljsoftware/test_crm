//
//  BillTableViewController.m
//  sales
//
//  Created by user on 2017/3/16.
//  Copyright © 2017年 rayootech. All rights reserved.
//

#import "BillTableViewController.h"
#import "BillTableViewCell.h"
#define kBillTableCellId   @"BillTableViewCell"
@interface BillTableViewController ()

@property (nonatomic,strong) NSMutableArray *dataModels;

@end

@implementation BillTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"账单明细";
    self.tableView.dk_backgroundColorPicker = DKColorPickerWithRGB(0xf0f0f0, 0x000000, 0xfafafa);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)setDetails:(NSMutableArray *)details{
    _details = details;
    _dataModels = details;
    NSLog(@"count = %ld" ,_dataModels.count);
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.dataModels.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    BillTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kBillTableCellId];
    if (!cell) {
        cell = [[BillTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kBillTableCellId];
    }
    cell.detail = self.dataModels[indexPath.row];
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}
- (NSMutableArray *)dataModels {
    if(_dataModels == nil) {
        _dataModels = [NSMutableArray array];
    }
    return _dataModels;
}

@end
