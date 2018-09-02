//
//  ODiscussSettingHeaderView.m
//  sales
//
//  Created by Sunny on 2018/8/30.
//  Copyright © 2018年 rayootech. All rights reserved.
//

#import "ODiscussSettingHeaderView.h"
#import "ODiscussSettingMemberCell.h"

#define ItemWidth   ((KSCREEN_WIDTH-15*6)/5)
#define ItemHeight  ((KSCREEN_WIDTH-15*6)/5+16)

@interface ODiscussSettingHeaderView () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) NSMutableArray *partMemberArr;
@property (nonatomic, assign) BOOL isShowAll;
@property (nonatomic, assign) BOOL isCreator;
@property CGRect originFrame;

@property (nonatomic, strong) UIButton *cancelBtn;

@end

@implementation ODiscussSettingHeaderView

- (instancetype)initWithDataArray:(NSMutableArray *)dataArray isCreator:(BOOL)isCreator {
    if (self = [super init]) {
        
        self.backgroundColor = [UIColor colorWithHex:0xF2F2F2];
        _isCreator = isCreator;
        [self refreshData:dataArray];
        [self initUI];
    }
    return self;
}

- (void)initUI {
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    flowLayout.sectionInset = UIEdgeInsetsMake(15, 15, 15, 15);
    flowLayout.minimumInteritemSpacing = 15;
    flowLayout.minimumLineSpacing = 10;
    flowLayout.itemSize = CGSizeMake(ItemWidth, ItemHeight);
    UICollectionView *collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.scrollEnabled = false;
    collectionView.showsVerticalScrollIndicator = false;
    collectionView.backgroundColor = [UIColor whiteColor];
    [collectionView registerNib:[UINib nibWithNibName:@"ODiscussSettingMemberCell" bundle:nil] forCellWithReuseIdentifier:@"kODiscussSettingMemberCell"];
    [self addSubview:collectionView];
    self.collectionView = collectionView;
    [collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self);
        make.bottom.mas_equalTo(self.dataArray.count > self.partMemberArr.count ? -55 : -10);
    }];
    [self initCancelBtn];
}

- (void)initCancelBtn {
    
    [self.cancelBtn removeFromSuperview];
    self.cancelBtn = nil;
    if (self.dataArray.count > self.partMemberArr.count) {
        UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        cancelBtn.backgroundColor = UIColor.whiteColor;
        cancelBtn.titleLabel.font = SYSTEM_FONT(15);
        [cancelBtn setTitle:@"全部成员" forState:UIControlStateNormal];
        [cancelBtn setTitleColor:SDColor(109, 109, 109, 1) forState:UIControlStateNormal];
        [cancelBtn addTarget:self action:@selector(showAllClicked) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:cancelBtn];
        [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self);
            make.bottom.mas_equalTo(-10);
            make.height.mas_equalTo(45);
        }];
        self.cancelBtn = cancelBtn;
    }
}

- (void)showAllClicked {
    self.isShowAll = !self.isShowAll;
    [UIView animateWithDuration:0.3 animations:^{
        [self refreshUI];
    }];
}

- (void)refreshUI {
    NSInteger memberCount = self.dataArray.count + (self.isCreator ? 2 : 1);
    NSInteger lineNum = memberCount%5 == 0 ? memberCount/5 : (memberCount/5 + 1);
    lineNum = lineNum > 2 ? (self.isShowAll ? lineNum : 2) : lineNum;
    if (lineNum <= 2 || CGRectEqualToRect(self.originFrame, CGRectZero)) {
        self.originFrame = CGRectMake(0, 0, KSCREEN_WIDTH, lineNum*(ItemHeight+10)+30+(self.dataArray.count > self.partMemberArr.count ? 45 : 0));
    }
    if (self.isShowAll) {
        self.frame = CGRectMake(0, 0, KSCREEN_WIDTH, lineNum*(ItemHeight+10)+30+(self.dataArray.count > self.partMemberArr.count ? 45 : 0));
    } else {
        self.frame = self.originFrame;
    }
    [self.collectionView reloadData];
    if (self.updateFrameBlock) {
        self.updateFrameBlock();
    }
}

- (void)refreshData:(NSMutableArray *)newDataArray {
    self.dataArray = newDataArray;
    self.partMemberArr = [[NSMutableArray alloc] init];
    NSInteger showCnt = self.isCreator ? 8 : 9;
    for (int i = 0; i < self.dataArray.count; i++) {
        if (i < showCnt) {
            [self.partMemberArr addObject:self.dataArray[i]];
        } else {
            break;
        }
    }
    [self refreshUI];
    [self initCancelBtn];
}

// MARK: - UICollectionViewCell 代理
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return (self.isShowAll ? self.dataArray.count : self.partMemberArr.count) + (self.isCreator ? 2 : 1);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ODiscussSettingMemberCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"kODiscussSettingMemberCell" forIndexPath:indexPath];
    NSMutableArray *dataSource = self.isShowAll ? self.dataArray : self.partMemberArr;
    if (indexPath.row < dataSource.count) {
        [cell refreshData:dataSource[indexPath.row]];
    } else {
        cell.nameLabel.text = indexPath.row == dataSource.count ? @"添加" : @"删除";
        cell.portraitImgView.image = [UIImage imageNamed:indexPath.row == dataSource.count ? @"message_member_add" : @"message_member_delete"];
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSMutableArray *dataSource = self.isShowAll ? self.dataArray : self.partMemberArr;
    if (indexPath.row == dataSource.count) { // 添加
        if (self.addMemberBlock) {
            self.addMemberBlock();
        }
    } else if (indexPath.row == dataSource.count+1) { // 删除
        if (self.deleteMemberBlock) {
            self.deleteMemberBlock();
        }
    }
}

@end
