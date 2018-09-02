//
//  CustomerTableViewController.m
//  sales
//
//  Created by user on 2017/1/3.
//  Copyright © 2017年 rayootech. All rights reserved.
//

#import "CustomerTableViewController.h"
#import "CustomerTableViewCell.h"
#import "CustomerDetailsViewController.h"
#import "Customer.h"
#import "UIViewLinkTouch.h"
#import "MenuView.h"

@interface CustomerTableViewController ()<UISearchBarDelegate,UISearchResultsUpdating,UISearchControllerDelegate>

@property (nonatomic,strong) CustomerDbUtil *dbUtil;
@property (nonatomic,strong) NSMutableArray *dataModels;
@property (nonatomic,strong) NSMutableArray *sectionArray;
@property (nonatomic,strong) NSMutableArray *filterObjects;
@property (nonatomic,strong) NSMutableArray *sectionTitlesArray;
@property (nonatomic,strong) PreferUtil *preferUtil;
@property (nonatomic,strong) NSString *type;
@property (nonatomic,strong) UISearchController *searchController;
@property (nonatomic,assign) NSInteger      sorttype;

@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) MenuView *menuView;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UIButton *selectBtn;
@property (nonatomic, assign) NSInteger sortIndex;
@property (nonatomic, assign) NSInteger siftIndex;

@end

@implementation CustomerTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithHex:0xf2f2f2];
    _sorttype = 0;
    _dbUtil = [[CustomerDbUtil alloc] init];
    _preferUtil = [PreferUtil new];
    [_preferUtil initIN];
    [self setHeaderView];
    self.tableView.rowHeight = 60;
    self.tableView.sectionIndexColor = [UIColor lightGrayColor];
    self.tableView.sectionIndexBackgroundColor = [UIColor clearColor];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    _type = @"0";
    [self getLocalData:@"0"];
    [self getCustomerList];
    
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(updateCustomer) name:@"updateCustomer" object:nil];
    self.filterObjects = @[].mutableCopy;
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    self.searchController.searchResultsUpdater = self;
    self.searchController.delegate = self;
    self.searchController.dimsBackgroundDuringPresentation = NO;
}

- (void)updateCustomer{
    [self getLocalData:_type];
}

- (void)getLocalData:(NSString *) type{
    if (_sorttype == 0) {
        NSMutableArray *temp = [_dbUtil selectAll:type];
        self.dataModels = temp.mutableCopy;
        [self setUpTableSection:1];
    }else{
        NSMutableArray *temp = [_dbUtil selectSortAll:type];
        self.dataModels = temp.mutableCopy;
        [self.tableView reloadData];
    }
}

- (void)getCustomerList{
    NSString *userId = [NSString stringWithFormat:@"%ld",[Config getOrgUserID]];;
    NSString *token = [Config getToken];
    NSString *dbid = [NSString stringWithFormat:@"%ld",[Config getDbID]];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    
    NSString* urlStr = [NSString stringWithFormat:@"%@%@",BASE_URL,API_CUSTOMER_LIST];
    NSString *updatetime = [NSString stringWithFormat:@"%ld",[_preferUtil getInt:LastCustomerListUpdate]];
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"POST" URLString:urlStr parameters:@{@"time":updatetime,@"type":@"0"}                                                                                    error:nil];
    [request addValue:userId forHTTPHeaderField:@"userId"];
    [request addValue:token forHTTPHeaderField:@"token"];
    [request addValue:dbid forHTTPHeaderField:@"dbid"];
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id _Nonnull responseObject, NSError *error) {
        if (error) {
            [self getLocalData:_type];
        } else {
            NSString *responseString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            NSLog(@"DATA-->%@", responseString);
            if (responseObject) {
                NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
                if ([dictionary[@"result"] intValue] == 1) {
                    NSArray* data = dictionary[@"data"];
                    NSArray* modelArray = [Customer mj_objectArrayWithKeyValuesArray:data];
                    NSMutableArray *temp;
                    temp = modelArray.mutableCopy;
                    for (Customer *model in temp) {
                        if (model.status == 1) {
                            NSInteger uid = [_dbUtil selectCustomerById:model.id].id;
                            if (uid == 0) {
                                [_dbUtil insertCustomer:model];
                            }else{
                                [_dbUtil updateCustomer:model];
                            }
                        }
                    }
                    [_preferUtil setInt:LastCustomerListUpdate data:[dictionary[@"updatetime"] longValue]];
                }else{
                    
                }
            }else{
                
            }
            [self getLocalData:_type];
        }
    }];
    [dataTask resume];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setHeaderView {
    
    UIView *topBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KSCREEN_WIDTH, 50)];
    topBgView.backgroundColor = [UIColor whiteColor];
    self.headerView = topBgView;
    self.tableView.tableHeaderView = self.headerView;
    
    NSArray *titles = @[@"排序",@"筛选"];
    NSArray *leftIcons = @[@"customer_sort",@"customer_sift"];
    for (int i = 0; i < 2; i++) {
        
        // 按钮
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.tag = i+100;
        [btn addTarget:self action:@selector(itemClicked:) forControlEvents:UIControlEventTouchUpInside];
        [topBgView addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(topBgView);
            make.width.mas_equalTo(KSCREEN_WIDTH/2);
            make.height.mas_equalTo(50);
            make.left.mas_equalTo(KSCREEN_WIDTH/2*i);
        }];
        
        // 标题
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.text = titles[i];
        titleLabel.tag = i + 200;
        titleLabel.textColor = [UIColor lightGrayColor];
        titleLabel.font = [UIFont systemFontOfSize:14];
        [btn addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(btn);
        }];
        
        // 左侧图标
        UIImageView *leftIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:leftIcons[i]]];
        [btn addSubview:leftIcon];
        [leftIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(titleLabel.mas_left).offset(-5);
            make.centerY.equalTo(btn);
        }];
        
        // 右侧上下箭头
        UIImageView *rightIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"customer_arrow_down"]];
        rightIcon.tag = i + 300;
        [btn addSubview:rightIcon];
        [rightIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(titleLabel.mas_right).offset(20);
            make.centerY.equalTo(btn);
        }];
    }
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = SDColor(31, 90, 248, 1);
    lineView.hidden = true;
    [topBgView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(topBgView);
        make.width.mas_equalTo(30);
        make.height.mas_equalTo(2);
        make.centerX.mas_equalTo(-KSCREEN_WIDTH/4);
    }];
    self.lineView = lineView;
}

- (void)itemClicked:(UIButton *)sender {
    
    sender.selected = !sender.selected;
    self.selectBtn = sender;
    
    UIButton *sortBtn = (UIButton *)[self.headerView viewWithTag:100];
    UIButton *siftBtn = (UIButton *)[self.headerView viewWithTag:101];
    UILabel *sortLabel = (UILabel *)[sortBtn viewWithTag:200];
    UILabel *siftLabel = (UILabel *)[siftBtn viewWithTag:201];
    UIImageView *sortArrow = (UIImageView *)[sortBtn viewWithTag:300];
    UIImageView *siftArrow = (UIImageView *)[siftBtn viewWithTag:301];

    if (sender.selected) {
        if (sender == sortBtn) {
            sortLabel.textColor = [UIColor colorWithHex:0x333333];
            siftLabel.textColor = [UIColor lightGrayColor];
            sortArrow.image = [UIImage imageNamed:@"customer_arrow_up"];
            siftArrow.image = [UIImage imageNamed:@"customer_arrow_down"];
            siftBtn.selected = false;
        } else {
            siftLabel.textColor = [UIColor colorWithHex:0x333333];
            sortLabel.textColor = [UIColor lightGrayColor];
            siftArrow.image = [UIImage imageNamed:@"customer_arrow_up"];
            sortArrow.image = [UIImage imageNamed:@"customer_arrow_down"];
            sortBtn.selected = false;
        }
        self.lineView.hidden = false;
        [self showMenuView];
        
        [self.headerView layoutIfNeeded];
        [self.lineView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.selectBtn.tag == 100 ? -KSCREEN_WIDTH/4 : KSCREEN_WIDTH/4);
        }];
        [UIView animateWithDuration:0.3 animations:^{
            [self.headerView layoutIfNeeded];
        }];
    
    } else {
        if (sender == sortBtn) {
            sortLabel.textColor = [UIColor lightGrayColor];
        } else {
            siftLabel.textColor = [UIColor lightGrayColor];
        }
        [self.menuView hide];
    }
}

- (void)showMenuView {
    
    [_menuView removeFromSuperview];
    _menuView = nil;
    
    NSArray *menuItems = self.selectBtn.tag == 100 ? @[@"按名称排序",@"按时间排序"] : @[@"全部客户",@"我的客户",@"我参与的客户",@"我的下级客户"];
    WeakSelf;
    _menuView = [[MenuView alloc] initWithMenuItems:menuItems currentSelectIndex:self.selectBtn.tag == 100 ? self.sortIndex : self.siftIndex selectIndexs:^(NSInteger selectIndex) {
        
        weakSelf.selectBtn.selected = false;
        UIButton *sortBtn = (UIButton *)[weakSelf.headerView viewWithTag:100];
        UIButton *siftBtn = (UIButton *)[weakSelf.headerView viewWithTag:101];
        UILabel *sortLabel = (UILabel *)[sortBtn viewWithTag:200];
        UILabel *siftLabel = (UILabel *)[siftBtn viewWithTag:201];
        UIImageView *sortArrow = (UIImageView *)[sortBtn viewWithTag:300];
        UIImageView *siftArrow = (UIImageView *)[siftBtn viewWithTag:301];
        if (weakSelf.selectBtn == sortBtn) {
            sortLabel.textColor = [UIColor lightGrayColor];
            sortArrow.image = [UIImage imageNamed:@"customer_arrow_down"];
        } else {
            siftLabel.textColor = [UIColor lightGrayColor];
            siftArrow.image = [UIImage imageNamed:@"customer_arrow_down"];
        }
        weakSelf.lineView.hidden = true;
        if (weakSelf.selectBtn.tag == 100) {
            weakSelf.sortIndex = selectIndex;
            weakSelf.sorttype = selectIndex;
        } else {
            weakSelf.siftIndex = selectIndex;
            weakSelf.type = [NSString stringWithFormat:@"%ld",selectIndex];
        }
        [weakSelf getLocalData:weakSelf.type];
    }];
    [KeyWindow addSubview:_menuView];
    [_menuView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(50+KNAV_HEIGHT);
        make.left.right.bottom.equalTo(KeyWindow);
    }];
    [_menuView show];
}

- (void) setUpTableSection:(NSInteger)type {
    UILocalizedIndexedCollation *collation = [UILocalizedIndexedCollation currentCollation];
    
    //create a temp sectionArray
    NSUInteger numberOfSections = [[collation sectionTitles] count];
    NSMutableArray *newSectionArray =  [[NSMutableArray alloc]init];
    for (NSUInteger index = 0; index<numberOfSections; index++) {
        [newSectionArray addObject:[[NSMutableArray alloc]init]];
    }
    
    // insert Persons info into newSectionArray
    for (Customer *model in self.dataModels) {
        NSUInteger sectionIndex = [collation sectionForObject:model collationStringSelector:@selector(name)];
        if(type == 0){
            [_dbUtil insertCustomer:model];
        }
        [newSectionArray[sectionIndex] addObject:model];
    }
    
    //sort the person of each section
    for (NSUInteger index=0; index<numberOfSections; index++) {
        NSMutableArray *personsForSection = newSectionArray[index];
        NSArray *sortedPersonsForSection = [collation sortedArrayFromArray:personsForSection collationStringSelector:@selector(name)];
        newSectionArray[index] = sortedPersonsForSection;
    }
    
    NSMutableArray *temp = [NSMutableArray new];
    self.sectionTitlesArray = [NSMutableArray new];
    
    [newSectionArray enumerateObjectsUsingBlock:^(NSArray *arr, NSUInteger idx, BOOL *stop) {
        if (arr.count == 0) {
            [temp addObject:arr];
        } else {
            [self.sectionTitlesArray addObject:[collation sectionTitles][idx]];
        }
    }];
    
    [newSectionArray removeObjectsInArray:temp];
    
    self.sectionArray = newSectionArray;
    [self.tableView reloadData];
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    if (_sorttype == 1) {
        return 1;
    }
    NSInteger result = 0;
    switch (tableView.tag) {
        case 0: {
            result = [self.sectionTitlesArray count];
        }
            break;
        case 1: {
            result = 1;
        }
            break;
        default:
            break;
    }
    return result;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_sorttype == 1) {
        NSInteger result = 0;
        switch (tableView.tag) {
            case 0: {
                result = self.dataModels.count;
            }
                break;
            case 1: {
                result = [self.filterObjects count];
            }
                break;
            default:
                break;
        }
        return result;
    }
    
    if([self.sectionArray[section] count] == 0){
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }else{
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    }
    
    NSInteger result = 0;
    switch (tableView.tag) {
        case 0: {
            result = [self.sectionArray[section] count];
        }
            break;
        case 1: {
            result = [self.filterObjects count];
        }
            break;
        default:
            break;
    }
    return result;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *ID = @"Customers";
    CustomerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[CustomerTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    if (_sorttype == 1) {
        Customer *model = self.dataModels[indexPath.row];
        cell.model = model;
        switch (tableView.tag) {
            case 0: {
                model = self.dataModels[indexPath.row];
            }
                break;
            case 1: {
                model = self.filterObjects[indexPath.row];
            }
                break;
            default:
                break;
        }
        return cell;
    }
    NSUInteger section = indexPath.section;
    NSUInteger row = indexPath.row;
    Customer *model = self.sectionArray[section][row];
    cell.model = model;
//    cell.delegate = self;
    
    switch (tableView.tag) {
        case 0: {
            model = self.sectionArray[indexPath.section][indexPath.row];
        }
            break;
        case 1: {
            model = self.filterObjects[indexPath.row];
        }
            break;
        default:
            break;
    }
    return cell;
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (_sorttype == 1) {
        return nil;
    }
    if (tableView.tag == 1) {
        return nil;
    }
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 40)];
    headerView.backgroundColor = SDColor(239, 239, 239, 1);
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, [UIScreen mainScreen].bounds.size.width-40, 25)];
    label.textColor = SDColor(128, 128, 128, 1);
    label.text = [self.sectionTitlesArray objectAtIndex:section];
    label.font = [UIFont systemFontOfSize:14];
    [headerView addSubview:label];
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (_sorttype == 1) {
        return 0.1;
    }
    if (tableView.tag == 1) {
        return 0.1;
    }
    return 25;
}


- (NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    if (_sorttype == 1) {
        return nil;
    }
    
    if (tableView.tag == 1) {
        return nil;
    }
    return self.sectionTitlesArray;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    Customer *customer = nil;
    if (_sorttype == 1) {
        switch (tableView.tag) {
            case 0: {
                customer = self.dataModels[indexPath.row];
            }
                break;
            case 1: {
                customer = self.filterObjects[indexPath.row];
            }
                break;
            default:
                break;
        }
    }else{
        switch (tableView.tag) {
            case 0: {
                customer = self.sectionArray[indexPath.section][indexPath.row];
            }
                break;
            case 1: {
                customer = self.filterObjects[indexPath.row];
            }
                break;
            default:
                break;
        }
    }
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Customer" bundle:nil];
    CustomerDetailsViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"CustomerDetails"];
    vc.hidesBottomBarWhenPushed = YES;
    vc.customer = customer;
    self.searchController.active = NO;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)searchButtonClick:(UITapGestureRecognizer *)rec{
    if (rec.state == UIGestureRecognizerStateBegan) {
    }else if(rec.state == UIGestureRecognizerStateEnded){
//        [self.tableView.tableHeaderView addSubview:self.searchController.searchBar];
        self.tableView.tableHeaderView = self.searchController.searchBar;
        [self.searchController.searchBar becomeFirstResponder];
    }
}

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController{
    NSString *searchString = [searchController.searchBar text];
    [self.filterObjects removeAllObjects];
    [self.dataModels enumerateObjectsUsingBlock:^(Customer *obj, NSUInteger idx, BOOL *stop) {
        if ([obj.name rangeOfString:searchString].length) {
            [self.filterObjects addObject:obj];
        }
    }];
    self.tableView.tag = 1;
    [self.tableView reloadData];
}
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
    
}
- (void)didDismissSearchController:(UISearchController *)searchController{
    self.tableView.tag = 0;
    [self.tableView reloadData];
}
- (void)willDismissSearchController:(UISearchController *)searchController{
    [searchController.searchBar removeFromSuperview];
    self.tableView.tableHeaderView = _headerView;
}

@end
