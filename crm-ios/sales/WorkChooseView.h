//
//  WorkChooseView.h
//  sales
//
//  Created by Sunny on 2018/8/25.
//  Copyright © 2018年 rayootech. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^WorkChooseBlock)(NSInteger selectIndex);

@interface WorkChooseView : UIView

- (instancetype)initWithItem:(NSArray *)items selectIndex:(WorkChooseBlock)block;
- (void)show;

@end

@interface ChooseItem : NSObject

@property (nonatomic, copy) NSString *icon; // 图标
@property (nonatomic, copy) NSString *title; // 标题

- (instancetype)initWithTitle:(NSString *)title icon:(NSString *)icon;

@end
