//
//  ODiscussSettingHeaderView.h
//  sales
//
//  Created by Sunny on 2018/8/30.
//  Copyright © 2018年 rayootech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ODiscussSettingHeaderView : UIView

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, copy) void (^updateFrameBlock)(void);
@property (nonatomic, copy) void (^addMemberBlock)(void);
@property (nonatomic, copy) void (^deleteMemberBlock)(void);

- (instancetype)initWithDataArray:(NSMutableArray *)dataArray isCreator:(BOOL)isCreator;
- (void)refreshData:(NSMutableArray *)newDataArray;

@end
