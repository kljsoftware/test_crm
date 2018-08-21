//
//  ContactTableViewController.m
//  sales
//
//  Created by user on 2016/11/3.
//  Copyright © 2016年 rayootech. All rights reserved.
//

#import "ContactTableViewController.h"
#import "ContactTableViewCell.h"
#import "ReqFriendTableViewCell.h"
#import "ReqFriendTableViewController.h"
#import "EnteringContactViewController.h"
#import "SalesDbUtil.h"
#import "UIViewLinkTouch.h"
#import "ContactDetailsViewController.h"
#import "OConversationViewController.h"
#import "ReqFriendDbUtil.h"

@interface ContactTableViewController () <ContactCellDelegate>

@property (nonatomic,strong) SalesDbUtil *dbUtil;
@property (nonatomic,strong) NSMutableArray* dataModels;
@property (nonatomic,strong) NSMutableArray *sectionArray;
@property (nonatomic,strong) NSMutableArray *sectionTitlesArray;
@property (nonatomic,strong) UIView *headerView;
@property (nonatomic,strong) PreferUtil *preferUtil;
@property (nonatomic,strong) ReqFriendDbUtil *reqDb;
@property (nonatomic,strong) UILabel *label;
@property (nonatomic,strong) UILabel *countLabel;
@end

@implementation ContactTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _dbUtil = [[SalesDbUtil alloc] init];
    _preferUtil = [PreferUtil new];
    [_preferUtil initOUT];
    _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 640, 50)];

    _label = [[UILabel alloc] init];
    _label.text = @"新朋友";
    _label.font = [UIFont systemFontOfSize:14];
    
    
    _countLabel = [[UILabel alloc] initWithFrame:CGRectMake(75, 0, 20, 20)];
    _countLabel.backgroundColor = [UIColor redColor];
    _countLabel.layer.cornerRadius = _countLabel.bounds.size.width/2;
    _countLabel.layer.masksToBounds = YES;
    _countLabel.textColor = [UIColor whiteColor];
    _countLabel.font = [UIFont systemFontOfSize:12];
    _countLabel.textAlignment = NSTextAlignmentCenter;
    _countLabel.text = @"1";
    
    [_headerView addSubview:_label];
    [_headerView addSubview:_countLabel];
    
    _label.sd_layout
    .leftSpaceToView(self.headerView, 8)
    .widthIs(70)
    .heightEqualToWidth()
    .centerYEqualToView(self.headerView);
    
    _countLabel.sd_layout.leftSpaceToView(_label, 5).centerYEqualToView(self.headerView).widthIs(20).heightIs(20);
    NSInteger num = [_preferUtil getInt:NewFriendReq];
    if (num > 0) {
        _countLabel.hidden = NO;
    }else{
        _countLabel.hidden = YES;
    }
    UILongPressGestureRecognizer *gesturRecognizer=[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(newFriend:)];
    gesturRecognizer.minimumPressDuration = 0;
    [_headerView addGestureRecognizer:gesturRecognizer];
    
    self.tableView.tableHeaderView = _headerView;
    self.tableView.rowHeight = [ContactTableViewCell fixedHeight];
    self.tableView.sectionIndexColor = [UIColor lightGrayColor];
    self.tableView.sectionIndexBackgroundColor = [UIColor clearColor];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self getLocalData];
    
    [self getContactsList];
    
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(updateNotice) name:@"updateContact" object:nil];
    [center addObserver:self selector:@selector(deleteNotice) name:@"deleteContact" object:nil];
    [center addObserver:self selector:@selector(updateFriendReq) name:@"newFriendReq" object:nil];
}

- (void)updateFriendReq{
    _countLabel.hidden = NO;
}

- (void)updateNotice{
    [self getContactsList];
}
- (void)deleteNotice{
    [self getLocalData];
}
- (void)newFriend:(UITapGestureRecognizer *)rec{
    if (rec.state == UIGestureRecognizerStateBegan) {
        _headerView.backgroundColor = [UIColor lightGrayColor];
    }else if(rec.state == UIGestureRecognizerStateEnded){
        [_preferUtil setInt:NewFriendReq data:0];
        _countLabel.hidden = YES;
        _headerView.backgroundColor = [UIColor whiteColor];
        ReqFriendTableViewController *vc = [[ReqFriendTableViewController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        vc.view.backgroundColor = [UIColor whiteColor];
        [self.navigationController pushViewController:vc animated:YES];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)getLocalData{
    NSMutableArray *temp = [_dbUtil selectAll];
    self.dataModels = temp.mutableCopy;
    [self setUpTableSection:1];
}
- (void)getContactsList{
    NSString *userId = [NSString stringWithFormat:@"%lld",[Config getOwnID]];;
    NSString *token = [Config getToken];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    
    NSString* urlStr = [NSString stringWithFormat:@"%@%@",BASE_URL,API_CONTACT_LIST];
    //    NSURL *URL = [NSURL URLWithString:urlStr];
    NSString *updatetime = [NSString stringWithFormat:@"%ld",[_preferUtil getInt:LastContactListUpdate]];
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"POST" URLString:urlStr parameters:@{@"updatetime":updatetime}                                                                                    error:nil];
    [request addValue:userId forHTTPHeaderField:@"userId"];
    [request addValue:token forHTTPHeaderField:@"token"];

    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id _Nonnull responseObject, NSError *error) {
        if (error) {
            [self getLocalData];
        } else {
            NSString *responseString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            NSLog(@"DATA-->%@", responseString);
            if (responseObject) {
                NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
                if ([dictionary[@"result"] intValue] == 1) {
                    NSArray* data = dictionary[@"data"];
                    NSArray* modelArray = [Contact mj_objectArrayWithKeyValuesArray:data];
                    NSMutableArray *temp;
                    temp = modelArray.mutableCopy;
                    for (Contact *model in temp) {
                        if (model.status == 1) {
                            NSInteger uid = [_dbUtil selectContactById:model.id].id;
                            if (uid == 0) {
                                [_dbUtil insertContact:model];
                            }else{
                                [_dbUtil updateContact:model];
                            }
                        }
                    }
                    [_preferUtil setInt:LastContactListUpdate data:[dictionary[@"updatetime"] longValue]];
                }else{
                    
                }
            }else{
                
            }
            [self getLocalData];
        }
    }];
    [dataTask resume];
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
    for (Contact *model in self.dataModels) {
        NSUInteger sectionIndex = [collation sectionForObject:model collationStringSelector:@selector(name)];
        if(type == 0){
            [_dbUtil insertContact:model];
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
    return self.sectionTitlesArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if([self.sectionArray[section] count] == 0){
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }else{
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    }
    return [self.sectionArray[section] count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *ID = @"Contacts";
    ContactTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[ContactTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    NSUInteger section = indexPath.section;
    NSUInteger row = indexPath.row;
    Contact *model = self.sectionArray[section][row];
    cell.model = model;
    cell.delegate = self;
    return cell;
    
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return [self.sectionTitlesArray objectAtIndex:section];
}


- (NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    return self.sectionTitlesArray;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    UIViewController *vc = [CircleDetailsTableViewController new];
//    ContactDetailsViewController *vc = [[ContactDetailsViewController alloc]init];
//    vc.hidesBottomBarWhenPushed = YES;
//    vc.view.backgroundColor = [UIColor whiteColor];
//    vc.contact = self.dataModels[indexPath.row];
//    [self.navigationController pushViewController:vc animated:YES];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Contact" bundle:nil];
    ContactDetailsViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"ContactDetails"];
    vc.hidesBottomBarWhenPushed = YES;
    vc.view.backgroundColor = [UIColor whiteColor];
    vc.contact = self.sectionArray[indexPath.section][indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)setExtraCellLineHidden: (UITableView *)tableView
{
//    UIView *view =[ [UIView alloc]init];
//    view.backgroundColor = [UIColor clearColor];
//    [tableView setTableFooterView:view];
//    [view release];
}
- (void)userPortraitDidClick{
    
}

- (void)userChatDidClick:(Contact *)model{
    OConversationViewController *conversationVC = [[OConversationViewController alloc] init];
    conversationVC.conversationType = ConversationType_PRIVATE;
    NSString *fid = [NSString stringWithFormat:@"%ld",model.fid];
    conversationVC.targetId = [@"out_" stringByAppendingString:fid];
    conversationVC.displayUserNameInCell = NO;
    conversationVC.title = model.name;
    conversationVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:conversationVC animated:YES];
}
@end
