//
//  SelectColleaguesTableViewController.m
//  sales
//
//  Created by user on 2017/3/2.
//  Copyright © 2017年 rayootech. All rights reserved.
//

#import "SelectColleaguesTableViewController.h"
#import "OrgUserInfoDbUtil.h"
#import "SelectColleauesTableViewCell.h"
@interface SelectColleaguesTableViewController ()<UISearchBarDelegate,UISearchResultsUpdating,UISearchControllerDelegate>

@property (nonatomic,strong) OrgUserInfoDbUtil *dbUtil;
@property (nonatomic,strong) NSMutableArray *dataModels;
@property (nonatomic,strong) NSMutableArray *sectionArray;
@property (nonatomic,strong) NSMutableArray *sectionTitlesArray;

@property (nonatomic,strong) NSMutableArray *selectedObjects;
@property (nonatomic,strong) NSMutableArray *filterObjects;
@property (nonatomic,strong) NSMutableArray *objectsWithIndex;
//@property (nonatomic,strong) UISearchDisplayController *searchDisplay;
@property (nonatomic,strong) UIView *headerView;
@property (nonatomic,strong) UISearchController *searchController;

@end

@implementation SelectColleaguesTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"选择好友";
    _dbUtil = [[OrgUserInfoDbUtil alloc] init];
    self.selectedObjects = @[].mutableCopy;
    self.filterObjects = @[].mutableCopy;
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消"
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:@selector(cancelButtonClicked)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"确定(0)" style:UIBarButtonItemStylePlain target:self action:@selector(makeDiscussion)];
    self.tableView.rowHeight = [SelectColleauesTableViewCell fixedHeight];
    self.tableView.sectionIndexColor = [UIColor lightGrayColor];
    //    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.sectionIndexBackgroundColor = [UIColor clearColor];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self initView];
    [self refresh_tableHeader];
    [self getLocalData];
}

- (void)initView{
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    self.searchController.searchResultsUpdater = self;
    self.searchController.delegate = self;
    self.searchController.dimsBackgroundDuringPresentation = NO;
}
- (void)getLocalData{
    NSMutableArray *temp = [_dbUtil selectAll];
    self.dataModels = temp.mutableCopy;
    [self setUpTableSection];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)cancelButtonClicked
{
    if (self.navigationController.viewControllers.count <= 1) {
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)makeDiscussion{}

- (void) setUpTableSection {
    UILocalizedIndexedCollation *collation = [UILocalizedIndexedCollation currentCollation];
    
    //create a temp sectionArray
    NSUInteger numberOfSections = [[collation sectionTitles] count];
    NSMutableArray *newSectionArray =  [[NSMutableArray alloc]init];
    for (NSUInteger index = 0; index<numberOfSections; index++) {
        [newSectionArray addObject:[[NSMutableArray alloc]init]];
    }
    
    // insert Persons info into newSectionArray
    for (OrgUserInfo *model in self.dataModels) {
        NSUInteger sectionIndex = [collation sectionForObject:model collationStringSelector:@selector(name)];
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
    NSInteger result = 0;
    switch (tableView.tag) {
        case 0: {
            result = [self.sectionTitlesArray count];
        }
            break;
        case 1: {
            if ([self.dataModels count] <= 0) {
                result = 0;
            }else
                result = 1;
        }
            break;
        default:
            break;
    }
    return result;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
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
    //    return [self.sectionArray[section] count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    static NSString *ID = @"Contacts";
    SelectColleauesTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[SelectColleauesTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
//    NSUInteger section = indexPath.section;
//    NSUInteger row = indexPath.row;
//    OrgUserInfo *model = self.sectionArray[section][row];
    OrgUserInfo *model;
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
    cell.model = model;
    Boolean type = false;
    for (OrgUserInfo *c in self.selectedObjects) {
        if (c.id == cell.model.id) {
            type = true;
        }
    }
    if (self.addDiscussionGroupMembers != nil) {
        for (OrgUserInfo *c in self.addDiscussionGroupMembers) {
            if (c.id == cell.model.id) {
                type = true;
            }
        }
    }
    cell.accessoryType = type?UITableViewCellAccessoryCheckmark:UITableViewCellAccessoryNone;
    return cell;
    
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (tableView.tag == 1) {
        return nil;
    }
    return [self.sectionTitlesArray objectAtIndex:section];
}


- (NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    if (tableView.tag == 1) {
        return nil;
    }
    return self.sectionTitlesArray;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    OrgUserInfo *contact = nil;
    switch (tableView.tag) {
        case 0: {
            contact = self.sectionArray[indexPath.section][indexPath.row];
        }
            break;
        case 1: {
            contact = self.filterObjects[indexPath.row];
        }
            break;
        default:
            break;
    }
    if (self.addDiscussionGroupMembers != nil) {
        for (OrgUserInfo *c in self.addDiscussionGroupMembers) {
            if (c.id == contact.id) {
                return;
            }
        }
    }
    if ([self.selectedObjects containsObject:contact]) {
        [self.selectedObjects removeObject:contact];
        [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryNone;
    }
    else {
        [self.selectedObjects addObject:contact];
        [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryCheckmark;
    }
    
    if (tableView.tag == 0) {
        [self refresh_done];
        [self refresh_tableHeader];
    }
}

#pragma mark custom event
- (void)refresh_tableHeader {
    CGFloat blank = 10;
    UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.tableView.frame), 58)];
    footer.backgroundColor = [UIColor cellsColor];
    self.tableView.tableHeaderView = footer;
    
    UIScrollView * scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(blank, blank, CGRectGetWidth(footer.frame) - blank*2, CGRectGetHeight(footer.frame) - blank*2)];
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.backgroundColor = [UIColor clearColor];
    [footer addSubview:scrollView];
    
    __block CGFloat offsetX = 0;
    
    [self.selectedObjects enumerateObjectsUsingBlock:^(OrgUserInfo *orgUserInfo, NSUInteger idx, BOOL *stop) {
        UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(offsetX, 0, CGRectGetHeight(scrollView.frame), CGRectGetHeight(scrollView.frame))];
        image.contentMode = UIViewContentModeScaleAspectFill;
        image.tag = idx;
        //        [image setCornerRadius:5.0];
        [image loadPortrait:orgUserInfo.avatar];
        [scrollView addSubview:image];
        
        UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(click_del:)];
        image.userInteractionEnabled = YES;
        [image addGestureRecognizer:tap];
        
        offsetX += CGRectGetWidth(image.frame) + 5;
    }];
    
    
    UIButton * searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    searchBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    searchBtn.frame = CGRectMake(offsetX, 0, 100, CGRectGetHeight(scrollView.frame));
    searchBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    searchBtn.backgroundColor = [UIColor clearColor];
    [searchBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [searchBtn setTitle:@"搜索" forState:UIControlStateNormal];
    [searchBtn addTarget:self action:@selector(click_search) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:searchBtn];
    offsetX += 100;
    
    scrollView.contentSize = CGSizeMake(offsetX, CGRectGetHeight(scrollView.frame));
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(blank - 2, CGRectGetMaxY(scrollView.frame) + 3, CGRectGetWidth(scrollView.frame) - 2*2, 0.5)];
    line.backgroundColor = [UIColor lightGrayColor];
    [footer addSubview:line];
    
    
}
- (void)refresh_done {
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:[NSString stringWithFormat:@"确定(%ld)",self.selectedObjects.count]
                                                                              style:UIBarButtonItemStylePlain
                                                                             target:self
                                                                             action:@selector(click_done)];
}
- (void)click_del:(UITapGestureRecognizer*)tap {
    [self.selectedObjects removeObjectAtIndex:tap.view.tag];
    [self refresh_done];
    [self refresh_tableHeader];
    [self.tableView reloadData];
}
- (void)click_search {
    [self.tableView.tableHeaderView addSubview:self.searchController.searchBar];
    [self.searchController.searchBar becomeFirstResponder];
}
- (void)click_done{
    Boolean type = false;
    if(self.addDiscussionGroupMembers != nil && self.addDiscussionGroupMembers.count > 0){
        type = true;
    }
    if (self.selectedObjects.count <= 0) {
        return;
    }
    NSMutableArray *userIdList = [NSMutableArray new];
    NSString *dbid = [NSString stringWithFormat:@"%ld",[Config getDbID]];
    NSString *pre = [@"in_" stringByAppendingString:dbid];
    pre = [pre stringByAppendingString:@"_"];
    for (OrgUserInfo *orgUserInfo in self.selectedObjects) {
        NSString *id = [NSString stringWithFormat:@"%ld",orgUserInfo.id];
        
        [userIdList addObject:[pre stringByAppendingString:id]];
    }
    NSString *title = [[Config getOrgUser].name stringByAppendingString:@"的群组"];
    if (type) {
        [[RCIMClient sharedRCIMClient] addMemberToDiscussion:self.discussionId userIdList:userIdList success:^(RCDiscussion *discussion) {
            NSLog(@"tian jian cheng gong");
            [[NSNotificationCenter defaultCenter]
             postNotificationName:@"addDiscussiongroupMember"
             object:self.selectedObjects];
            dispatch_async(dispatch_get_main_queue(), ^{
                if (self.navigationController.viewControllers.count <= 1) {
                    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
                } else {
                    [self.navigationController popViewControllerAnimated:YES];
                }
            });
        } error:^(RCErrorCode status) {
            
        }];
    }else{
        [[RCIMClient sharedRCIMClient] createDiscussion:title userIdList:userIdList success:^(RCDiscussion *discussion) {
            NSLog(@"--- chuang jian cheng gong");
            dispatch_async(dispatch_get_main_queue(), ^{
                if (self.navigationController.viewControllers.count <= 1) {
                    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
                } else {
                    [self.navigationController popViewControllerAnimated:YES];
                }
            });
        } error:^(RCErrorCode status) {
            
        }];
    }
    
}
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController{
    NSString *searchString = [searchController.searchBar text];
    [self.filterObjects removeAllObjects];
    [self.dataModels enumerateObjectsUsingBlock:^(OrgUserInfo *obj, NSUInteger idx, BOOL *stop) {
        if ([obj.name rangeOfString:searchString].length) {
            [self.filterObjects addObject:obj];
        }else if([obj.mobile rangeOfString:searchString].length){
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
    [self refresh_done];
    [self.tableView reloadData];
}
- (void)willDismissSearchController:(UISearchController *)searchController{
    [searchController.searchBar removeFromSuperview];
    [self refresh_tableHeader];
}


@end
