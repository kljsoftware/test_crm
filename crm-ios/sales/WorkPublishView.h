//
//  WorkPublishView.h
//  sales
//
//  Created by Sunny on 2018/8/25.
//  Copyright © 2018年 rayootech. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^WorkPublishBlock)(NSInteger selectIndex);

@interface WorkPublishView : UIView

- (instancetype)initWithItem:(NSArray *)items selectIndex:(WorkPublishBlock)block;
- (void)show;

@end

@interface PublishItem : NSObject

@property (nonatomic, copy) NSString *title; // 标题
@property (nonatomic, copy) NSString *normalIcon; // 图标
@property (nonatomic, copy) NSString *disableIcon; // 图标
@property (nonatomic, assign) BOOL enabled;

- (instancetype)initWithTitle:(NSString *)title normalIcon:(NSString *)normalIcon disableIcon:(NSString *)disableIcon enabled:(BOOL)enabled;

@end
