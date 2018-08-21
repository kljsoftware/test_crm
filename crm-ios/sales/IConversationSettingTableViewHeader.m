//
//  IConversationSettingTableViewHeader.m
//  sales
//
//  Created by user on 2017/3/2.
//  Copyright © 2017年 rayootech. All rights reserved.
//

#import "IConversationSettingTableViewHeader.h"
#import "IConversationSettingTableViewHeaderItem.h"
#import "OrgUserInfo.h"
#import "SelectColleaguesTableViewController.h"
@interface IConversationSettingTableViewHeader () <
IConversationSettingTableViewHeaderItemDelegate>

@end
@implementation IConversationSettingTableViewHeader

- (NSArray *)users {
    if (!_users) {
        _users = [@[] mutableCopy];
    }
    return _users;
}

- (instancetype)init {
    CGRect tempRect =
    CGRectMake(0, 0, SALEscreenWidth, 120);
    UICollectionViewFlowLayout *flowLayout =
    [[UICollectionViewFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    self = [super initWithFrame:tempRect collectionViewLayout:flowLayout];
    if (self) {
        self.delegate = self;
        self.dataSource = self;
        self.scrollEnabled = NO;
        [self registerClass:[IConversationSettingTableViewHeaderItem class]
 forCellWithReuseIdentifier:
         @"IConversationSettingTableViewHeaderItem"];
        self.isAllowedInviteMember = YES;
    }
    return self;
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section {
    if (self.isAllowedDeleteMember) {
        return self.users.count + 2;
    } else {
        if (self.isAllowedInviteMember) {
            return self.users.count + 1;
        } else {
            return self.users.count;
        }
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    IConversationSettingTableViewHeaderItem *cell =
    [collectionView dequeueReusableCellWithReuseIdentifier:
     @"IConversationSettingTableViewHeaderItem"
                                              forIndexPath:indexPath];
    
    if (self.users.count && (self.users.count - 1 >= indexPath.row)) {
        OrgUserInfo *user = self.users[indexPath.row];
        NSString *pre = [@"in_" stringByAppendingString:[NSString stringWithFormat:@"%ld",[Config getDbID]]];
        pre = [pre stringByAppendingString:@"_"];
        NSString *userId = [pre stringByAppendingString:[NSString stringWithFormat:@"%ld",user.id]];
        if ([userId isEqualToString:[RCIMClient sharedRCIMClient]
             .currentUserInfo.userId]) {
            [cell.btnImg setHidden:YES];
        } else {
            [cell.btnImg setHidden:!self.showDeleteTip];
        }
        if(user.avatar == nil)
            [cell.ivAva loadPortrait:@"1"];
        else
            [cell.ivAva loadPortrait:user.avatar];
        cell.titleLabel.text = user.name;
        cell.userId = userId;
        
        cell.delegate = self;
        
    } else if (self.users.count >= indexPath.row) {
        
        cell.btnImg.hidden = YES;
        cell.gestureRecognizers = nil;
        cell.titleLabel.text = @"";
        [cell.ivAva setImage:[UIImage imageNamed:@"add_member"]];
        
    } else {
        cell.btnImg.hidden = YES;
        cell.gestureRecognizers = nil;
        cell.titleLabel.text = @"";
        [cell.ivAva setImage:[UIImage imageNamed:@"delete_member"]];
    }
    
    cell.ivAva.contentMode = UIViewContentModeScaleAspectFill;
    return cell;
}

#pragma mark - RCConversationSettingTableViewHeaderItemDelegate
- (void)deleteTipButtonClicked:
(IConversationSettingTableViewHeaderItem *)item {
    NSIndexPath *indexPath = [self indexPathForCell:item];
    OrgUserInfo *user = self.users[indexPath.row];
    NSString *userId = [NSString stringWithFormat:@"in_%ld_%ld",[Config getDbID],user.id];
    if ([userId isEqualToString:[RCIMClient sharedRCIMClient]
         .currentUserInfo.userId]) {
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:nil
                                  message:NSLocalizedStringFromTable(@"CanNotRemoveSelf",
                                                                     @"RongCloudKit", nil)
                                  delegate:nil
                                  cancelButtonTitle:NSLocalizedStringFromTable(@"OK", @"RongCloudKit",
                                                                               nil)
                                  otherButtonTitles:nil, nil];
        ;
        [alertView show];
        return;
    }
    [self.users removeObjectAtIndex:indexPath.row];
    [self deleteItemsAtIndexPaths:@[ indexPath ]];
    
    if (self.settingTableViewHeaderDelegate &&
        [self.settingTableViewHeaderDelegate
         respondsToSelector:@selector(deleteTipButtonClicked:)]) {
            [self.settingTableViewHeaderDelegate deleteTipButtonClicked:indexPath];
            [self reloadData];
        }
}

//长按显示减号
- (void)showDeleteTip:(IConversationSettingTableViewHeaderItem *)cell {
    if (self.isAllowedDeleteMember) {
        self.showDeleteTip = YES;
        [self reloadData];
    }
}

//点击隐藏减号
- (void)hidesDeleteTip:(UITapGestureRecognizer *)recognizer {
    if (self.showDeleteTip) {
        self.showDeleteTip = NO;
        [self reloadData];
    } else {
        if (self.settingTableViewHeaderDelegate &&
            [self.settingTableViewHeaderDelegate
             respondsToSelector:@selector(didTipHeaderClicked:)]) {
                IConversationSettingTableViewHeaderItem *cell =
                (IConversationSettingTableViewHeaderItem *)recognizer.view;
                [self.settingTableViewHeaderDelegate didTipHeaderClicked:cell.userId];
            }
    }
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    float width = 56;
    float height = width + 15 + 5;
    
    return CGSizeMake(width, height);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView
                        layout:(UICollectionViewLayout *)collectionViewLayout
        insetForSectionAtIndex:(NSInteger)section {
    UICollectionViewFlowLayout *flowLayout =
    (UICollectionViewFlowLayout *)collectionViewLayout;
    flowLayout.minimumInteritemSpacing = 5;
    flowLayout.minimumLineSpacing = 5;
    return UIEdgeInsetsMake(10, 10, 10, 10);
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView
didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == self.users.count + 1) {
        if (self.isAllowedDeleteMember) {
            self.showDeleteTip = !self.showDeleteTip;
            [self reloadData];
        }
    }
    
    if (indexPath && self.settingTableViewHeaderDelegate &&
        [self.settingTableViewHeaderDelegate
         respondsToSelector:@selector(settingTableViewHeader:
                                      indexPathOfSelectedItem:
                                      allTheSeletedUsers:)]) {
             [self.settingTableViewHeaderDelegate settingTableViewHeader:self
                                                 indexPathOfSelectedItem:indexPath
                                                      allTheSeletedUsers:self.users];
         }
}


@end

