//
//  OConversationSettingBaseViewController.m
//  sales
//
//  Created by user on 2016/12/27.
//  Copyright © 2016年 rayootech. All rights reserved.
//

#import "OConversationSettingBaseViewController.h"
#import "OConversationSettingTableViewHeader.h"
#import "OConversationSettingTableViewCell.h"
#import "OConversationSettingClearMessageCell.h"
#import "GlobalDefines.h"
@interface OConversationSettingBaseViewController () <
OConversationSettingTableViewHeaderDelegate>

@property(nonatomic, strong) OConversationSettingTableViewHeader *header;
@property(nonatomic, strong) OConversationSettingTableViewCell *cell_isTop;
@property(nonatomic, strong) OConversationSettingTableViewCell *cell_newMessageNotify;
@property(nonatomic, strong) UIView *headerView;

@end

@implementation OConversationSettingBaseViewController


- (instancetype)init {
    self = [super init];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(orientChange:)
     name:UIDeviceOrientationDidChangeNotification
     object:nil];
    // add the header view
    _headerView = [[UIView alloc] initWithFrame:CGRectZero];
    
    _header = [[OConversationSettingTableViewHeader alloc] init];
    _header.settingTableViewHeaderDelegate = self;
    [_header setBackgroundColor:[UIColor whiteColor]];
    
    [_headerView addSubview:_header];
    [_header setTranslatesAutoresizingMaskIntoConstraints:NO];
    [_headerView
     addConstraints:
     [NSLayoutConstraint
      constraintsWithVisualFormat:@"V:|-10-[_header]|"
      options:kNilOptions
      metrics:nil
      views:NSDictionaryOfVariableBindings(
                                           _header)]];
    [_headerView
     addConstraints:
     [NSLayoutConstraint
      constraintsWithVisualFormat:@"H:|[_header]|"
      options:kNilOptions
      metrics:nil
      views:NSDictionaryOfVariableBindings(
                                           _header)]];
    
    // footer view
    self.tableView.tableFooterView = [UIView new];
}

- (void)addUsers:(NSMutableArray *)users {
    if (!users)
        return;
    
    _header.users = [NSMutableArray arrayWithArray:users];
    self.users = users;
    [_header reloadData];
    _headerView.frame =
    CGRectMake(0, 0, SALEscreenWidth,
               _header.collectionViewLayout.collectionViewContentSize.height + 20);
    self.tableView.tableHeaderView = _headerView;
}

- (void)disableDeleteMemberEvent:(BOOL)disable {
    if (_header) {
        _header.isAllowedDeleteMember = !disable;
    }
}

- (void)disableInviteMemberEvent:(BOOL)disable {
    if (_header) {
        _header.isAllowedInviteMember = !disable;
    }
}

- (NSArray *)defaultCells {
    
    _cell_isTop =
    [[OConversationSettingTableViewCell alloc] initWithFrame:CGRectZero];
    [_cell_isTop.swich addTarget:self
                          action:@selector(onClickIsTopSwitch:)
                forControlEvents:UIControlEventValueChanged];
    _cell_isTop.swich.on = _switch_isTop;
    _cell_isTop.label.text = NSLocalizedStringFromTable(
                                                        @"SetToTop", @"RongCloudKit", nil); //@"置顶聊天";
    
    _cell_newMessageNotify =
    [[OConversationSettingTableViewCell alloc] initWithFrame:CGRectZero];
    [_cell_newMessageNotify.swich
     addTarget:self
     action:@selector(onClickNewMessageNotificationSwitch:)
     forControlEvents:UIControlEventValueChanged];
    _cell_newMessageNotify.swich.on = _switch_newMessageNotify;
    _cell_newMessageNotify.label.text = NSLocalizedStringFromTable(
                                                                   @"NewMsgNotification", @"RongCloudKit", nil); //@"新消息通知";
    
    OConversationSettingClearMessageCell *cell_clearHistory =
    [[OConversationSettingClearMessageCell alloc] initWithFrame:CGRectZero];
    [cell_clearHistory.touchBtn addTarget:self
                                   action:@selector(onClickClearMessageHistory:)
                         forControlEvents:UIControlEventTouchUpInside];
    cell_clearHistory.nameLabel.text = NSLocalizedStringFromTable(
                                                                  @"ClearRecord", @"RongCloudKit", nil); //@"清除聊天记录";
    
    NSArray *_defaultCells =
    @[ _cell_isTop, _cell_newMessageNotify, cell_clearHistory ];
    
    return _defaultCells;
}

- (void)setSwitch_isTop:(BOOL)switch_isTop {
    _cell_isTop.swich.on = switch_isTop;
    _switch_isTop = switch_isTop;
}

- (void)setSwitch_newMessageNotify:(BOOL)switch_newMessageNotify {
    _cell_newMessageNotify.swich.on = switch_newMessageNotify;
    _switch_newMessageNotify = switch_newMessageNotify;
}

// landspace notification
- (void)orientChange:(NSNotification *)noti {
    _headerView.frame =
    CGRectMake(0, 0, SALEscreenWidth,
               _header.collectionViewLayout.collectionViewContentSize.height + 20);
    self.tableView.tableHeaderView = _headerView;
    
    if (self.headerHidden) {
        self.tableView.tableHeaderView = nil;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    _headerView.frame =
    CGRectMake(0, 0, SALEscreenWidth,
               _header.collectionViewLayout.collectionViewContentSize.height + 20);
    self.tableView.tableHeaderView = _headerView;
    if (self.headerHidden) {
        self.tableView.tableHeaderView = nil;
    }
    if (_headerView) {
        _header.showDeleteTip = NO;
        [_header reloadData];
    }
}

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44.f;
}
- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return self.defaultCells.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return self.defaultCells[indexPath.row];
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}

- (CGFloat)tableView:(UITableView *)tableView
heightForHeaderInSection:(NSInteger)section {
    return 20;
}

// override to impletion
//置顶聊天
- (void)onClickIsTopSwitch:(id)sender {
}

//新消息通知
- (void)onClickNewMessageNotificationSwitch:(id)sender {
}

//清除聊天记录
- (void)onClickClearMessageHistory:(id)sender {
}

//子类重写以下两个回调实现点击事件
#pragma mark - RCConversationSettingTableViewHeader Delegate
- (void)settingTableViewHeader:
(OConversationSettingTableViewHeader *)settingTableViewHeader
       indexPathOfSelectedItem:(NSIndexPath *)indexPathOfSelectedItem
            allTheSeletedUsers:(NSArray *)users {
}

- (void)deleteTipButtonClicked:(NSIndexPath *)indexPath {
}
- (void)didTipHeaderClicked:(NSString *)userId {
}
@end
