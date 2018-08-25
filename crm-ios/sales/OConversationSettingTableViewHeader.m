//
//  OConversationSettingTableViewHeader.m
//  sales
//
//  Created by user on 2016/12/27.
//  Copyright © 2016年 rayootech. All rights reserved.
//

#import "OConversationSettingTableViewHeader.h"
#import "OConversationSettingTableViewHeaderItem.h"
#import "Contact.h"
#import "OSelectFriendsViewController.h"
@interface OConversationSettingTableViewHeader () <
OConversationSettingTableViewHeaderItemDelegate>

@end
@implementation OConversationSettingTableViewHeader

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
        [self registerClass:[OConversationSettingTableViewHeaderItem class]
 forCellWithReuseIdentifier:
         @"OConversationSettingTableViewHeaderItem"];
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
    OConversationSettingTableViewHeaderItem *cell =
    [collectionView dequeueReusableCellWithReuseIdentifier:
     @"OConversationSettingTableViewHeaderItem"
                                              forIndexPath:indexPath];
    
    if (self.users.count && (self.users.count - 1 >= indexPath.row)) {
        Contact *user = self.users[indexPath.row];
        NSString *userId = [NSString stringWithFormat:@"%ld",user.fid];
        userId = [@"out_" stringByAppendingString:userId];
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
//        [cell.ivAva setImage:[RCDUtilities imageNamed:@"add_members"
//                                             ofBundle:@"RongCloud.bundle"]];
        [cell.ivAva setImage:[UIImage imageNamed:@"moments_add"]];
        
    } else {
        cell.btnImg.hidden = YES;
        cell.gestureRecognizers = nil;
        cell.titleLabel.text = @"";
//        [cell.ivAva setImage:[RCDUtilities imageNamed:@"delete_members"
//                                             ofBundle:@"RongCloud.bundle"]];
        [cell.ivAva setImage:[UIImage imageNamed:@"delete_member"]];
    }
    
    cell.ivAva.contentMode = UIViewContentModeScaleAspectFill;
    return cell;
}

#pragma mark - RCConversationSettingTableViewHeaderItemDelegate
- (void)deleteTipButtonClicked:
(OConversationSettingTableViewHeaderItem *)item {
    
    NSIndexPath *indexPath = [self indexPathForCell:item];
    Contact *user = self.users[indexPath.row];
    NSString *userId = [@"out_" stringByAppendingString:[NSString stringWithFormat:@"%ld",user.fid]];
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
- (void)showDeleteTip:(OConversationSettingTableViewHeaderItem *)cell {
    if (self.isAllowedDeleteMember) {
        self.showDeleteTip = YES;
        [self reloadData];
    }
}

//点击去除减号
//- (void)notShowDeleteTip:(RCDConversationSettingTableViewHeaderItem *)cell {
//
//    if (self.showDeleteTip == YES) {
//
//        self.showDeleteTip = NO;
//
//        [self reloadData];
//
//    }
//
//}

//点击隐藏减号
- (void)hidesDeleteTip:(UITapGestureRecognizer *)recognizer {
    if (self.showDeleteTip) {
        self.showDeleteTip = NO;
        [self reloadData];
    } else {
        if (self.settingTableViewHeaderDelegate &&
            [self.settingTableViewHeaderDelegate
             respondsToSelector:@selector(didTipHeaderClicked:)]) {
                OConversationSettingTableViewHeaderItem *cell =
                (OConversationSettingTableViewHeaderItem *)recognizer.view;
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
