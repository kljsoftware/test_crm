//
//  ReadTopChannelContianerView.h
//  sales
//
//  Created by user on 2017/1/17.
//  Copyright © 2017年 rayootech. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ReadTopChannelContianerViewDelegate <NSObject>

@optional

- (void)showOrHiddenAddChannelsCollectionView:(UIButton *)button;
- (void)chooseChannelWithIndex:(NSInteger)index;

@end
@interface ReadTopChannelContianerView : UIView

- (instancetype)initWithFrame:(CGRect)frame;
- (void)addAChannelButtonWithChannelName:(NSString *)channelName;
- (void)selectChannelButtonWithIndex:(NSInteger)index;
- (void)deleteChannelButtonWithIndex:(NSInteger)index;

//- (void)didShowEditChannelView:(BOOL)value;

@property (nonatomic, strong) NSArray *channelNameArray;
@property (nonatomic, weak) UIScrollView *scrollView;
//@property (nonatomic, weak) UIButton *addButton;
@property (nonatomic, weak) id<ReadTopChannelContianerViewDelegate> delegate;

@end
