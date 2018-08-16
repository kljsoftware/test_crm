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
#import "Config.h"
#import "Customer.h"
#import "SalesApi.h"
#import "CustomerDbUtil.h"
#import "UIViewLinkTouch.h"
#import "PreferUtil.h"
#import <AFNetworking.h>
#import <MJExtension.h>
#import <SDAutoLayout.h>
#define kMainWidth [UIScreen mainScreen].bounds.size.width
@interface CustomerTableViewController ()<UISearchBarDelegate,UISearchResultsUpdating,UISearchControllerDelegate>

@property (nonatomic,strong) CustomerDbUtil *dbUtil;
@property (nonatomic,strong) NSMutableArray *dataModels;
@property (nonatomic,strong) NSMutableArray *sectionArray;
@property (nonatomic,strong) NSMutableArray *filterObjects;
@property (nonatomic,strong) NSMutableArray *sectionTitlesArray;
@property (nonatomic,strong) UIView *headerView;
@property (nonatomic,strong) PreferUtil *preferUtil;
@property (nonatomic,strong) NSString *type;
@property (nonatomic,strong) UISearchController *searchController;
@property (nonatomic,assign) NSInteger      sorttype;

@end

@implementation CustomerTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _sorttype = 0;
    _dbUtil = [[CustomerDbUtil alloc] init];
    _preferUtil = [PreferUtil new];
    [_preferUtil initIN];
    [self setupHeadView];
    self.tableView.rowHeight = [CustomerTableViewCell fixedHeight];
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
- (void)setupHeadView{
    _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainWidth, 50)];
    
    UIView *searchView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainWidth / 3, 50)];
    UILabel *searchLabel = [[UILabel alloc] init];
    searchLabel.text = @"搜索";
    [searchView addSubview:searchLabel];
    searchLabel.font = [UIFont systemFontOfSize:14];
    searchLabel.sd_layout
    .centerXEqualToView(searchView)
    .centerYEqualToView(searchView).widthIs(42).heightIs(21);
    
    UIView *sortView = [[UIView alloc] initWithFrame:CGRectMake(kMainWidth / 3, 0, kMainWidth / 3, 50)];
    UILabel *sortLabel = [[UILabel alloc] init];
    sortLabel.text = @"排序";
    sortLabel.font = [UIFont systemFontOfSize:14];
    [sortView addSubview:sortLabel];
    sortLabel.sd_layout
    .centerXEqualToView(sortView).centerYEqualToView(sortView).heightIs(21).widthIs(42);
    UILongPressGestureRecognizer *sortGesturRecognizer=[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(sortButtonClick:)];
    sortGesturRecognizer.minimumPressDuration = 0;
    [sortView addGestureRecognizer:sortGesturRecognizer];
    
    UIView *filterView = [[UIView alloc] initWithFrame:CGRectMake(kMainWidth / 3 * 2, 0, kMainWidth / 3, 50)];
    UILabel *filterLabel = [[UILabel alloc] init];
    filterLabel.text = @"筛选";
    filterLabel.font = [UIFont systemFontOfSize:14];
    [filterView addSubview:filterLabel];
    filterLabel.sd_layout
    .centerYEqualToView(filterView).centerXEqualToView(filterView).heightIs(21).widthIs(42);
    
    UILongPressGestureRecognizer *gesturRecognizer=[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(filterButtonClick:)];
    gesturRecognizer.minimumPressDuration = 0;
    [filterView addGestureRecognizer:gesturRecognizer];
    
    UILongPressGestureRecognizer *searchGesturRecognizer=[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(searchButtonClick:)];
    gesturRecognizer.minimumPressDuration = 0;
    [searchView addGestureRecognizer:searchGesturRecognizer];
    
    [_headerView addSubview:sortView];
    [_headerView addSubview:searchView];
    [_headerView addSubview:filterView];
    
    self.tableView.tableHeaderView = _headerView;
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

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
//    return [self.sectionTitlesArray objectAtIndex:section];
    if (_sorttype == 1) {
        return nil;
    }
    if (tableView.tag == 1) {
        return nil;
    }
    return [self.sectionTitlesArray objectAtIndex:section];
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
    vc.view.backgroundColor = [UIColor whiteColor];
    vc.customer = customer;
    self.searchController.active = NO;
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)setExtraCellLineHidden: (UITableView *)tableView
{
    
}
- (void)userPortraitDidClick{
    
}
- (void)sortButtonClick:(UITapGestureRecognizer *)rec{
    if (rec.state == UIGestureRecognizerStateBegan) {
    }else if(rec.state == UIGestureRecognizerStateEnded){
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        UIAlertAction *nameAction = [UIAlertAction actionWithTitle:@"按名称排序" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            _sorttype = 0;
            [self getLocalData:_type];
        }];
        UIAlertAction *timeAction = [UIAlertAction actionWithTitle:@"按时间排序" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            _sorttype = 1;
            [self getLocalData:_type];
        }];
        
        
        [alertController addAction:cancelAction];
        [alertController addAction:nameAction];
        [alertController addAction:timeAction];
        
        [self presentViewController:alertController animated:YES completion:nil];
    }
}
- (void)filterButtonClick:(UITapGestureRecognizer *)rec{
    if (rec.state == UIGestureRecognizerStateBegan) {
    }else if(rec.state == UIGestureRecognizerStateEnded){
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        UIAlertAction *allAction = [UIAlertAction actionWithTitle:@"全部" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            _type = @"0";
            [self getLocalData:_type];
        }];
        UIAlertAction *myAction = [UIAlertAction actionWithTitle:@"我的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            _type = @"1";
            [self getLocalData:_type];
        }];
        
        UIAlertAction *joinAction = [UIAlertAction actionWithTitle:@"参与" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            _type = @"2";
            [self getLocalData:_type];
        }];
        
        UIAlertAction *subAction = [UIAlertAction actionWithTitle:@"下级" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            _type = @"3";
            [self getLocalData:_type];
        }];
        
        [alertController addAction:cancelAction];
        [alertController addAction:allAction];
        [alertController addAction:myAction];
        [alertController addAction:joinAction];
        [alertController addAction:subAction];
        
        [self presentViewController:alertController animated:YES completion:nil];
    }
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
