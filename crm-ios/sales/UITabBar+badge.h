//
//  UITabBar+badge.h
//  sales
//
//  Created by user on 2016/12/19.
//  Copyright © 2016年 rayootech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITabBar (badge)

//重写是为了修改badge小红点儿的颜色
- (void)showBadgeOnItemIndex:(int)index; //显示小红点

- (void)showBadgeOnItemIndex:(int)index badgeValue:(int)badgeValue; //显示带badge的红点

- (void)hideBadgeOnItemIndex:(int)index; //隐藏小红点

@end
