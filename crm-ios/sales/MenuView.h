//
//  MenuView.h
//  sales
//
//  Created by Sunny on 2018/8/23.
//  Copyright © 2018年 rayootech. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^MenuBlock)(NSInteger selectIndex);

@interface MenuView : UIView

- (instancetype)initWithMenuItems:(NSArray *)menuItems currentSelectIndex:(NSInteger)curSelIndex selectIndexs:(MenuBlock)block;
- (void)show;
- (void)hide;

@end
