//
//  BottomBarViewController.h
//  sales
//
//  Created by user on 2016/11/21.
//  Copyright © 2016年 rayootech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EditingBar.h"


@interface BottomBarViewController : UIViewController

@property (nonatomic, strong) EditingBar *editingBar;
//@property (nonatomic, strong) OperationBar *operationBar;
@property (nonatomic, strong) NSLayoutConstraint *editingBarYConstraint;
@property (nonatomic, strong) NSLayoutConstraint *editingBarHeightConstraint;

@property (nonatomic, strong) UIImage *image;//

- (instancetype)initWithModeSwitchButton:(BOOL)hasAModeSwitchButton;
- (instancetype)initWithPhotoButton:(BOOL)hasPhotoButton;

- (void)sendContent;//发送信息
- (void)updateInputBarHeight;
- (void)hideEmojiPageView;

@end
