//
//  AppDelegate.h
//  sales
//
//  Created by user on 2016/11/3.
//  Copyright © 2016年 rayootech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RongIMKit/RongIMKit.h>
@interface AppDelegate : UIResponder <UIApplicationDelegate,RCIMUserInfoDataSource>

@property (strong, nonatomic) UIWindow *window;

- (void)showWindowLogin:(NSString *)windowType;
- (void)showWindow:(NSString *)windowType;
@end

