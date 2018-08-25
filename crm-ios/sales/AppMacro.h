//
//  AppMacro.h
//
//
//  Created by Sunny on 2018/7/3.
//  Copyright © 2018年 Sunny. All rights reserved.
//

#ifndef AppMacro_h
#define AppMacro_h

/**
 *  工程通用相关宏定义
 */

// weak宏
#define WeakSelf    __weak __typeof(self) weakSelf = self

// window
#define KeyWindow   [UIApplication sharedApplication].keyWindow

#pragma mark - 输出Log
#ifndef __OPTIMIZE__

#define NSLog(...) NSLog(__VA_ARGS__)
#define LOG_ENABLED true

#else

#define NSLog(...) {}
#define LOG_ENABLED false

#endif

#pragma mark - 屏幕尺寸
// 屏幕可用尺寸
#define KSCREEN_SIZE            ([UIScreen mainScreen].bounds.size)
// 屏幕可用宽度
#define KSCREEN_WIDTH           ([UIScreen mainScreen].bounds.size.width)
// 屏幕可用高度
#define KSCREEN_HEIGHT          ([UIScreen mainScreen].bounds.size.height)
// 状态栏高度
#define KSTATUSBAR_HEIGHT       (iPhoneX ? 44 : 20)
// 竖屏底部指示部分高度
#define KINDICATOR_HEIGHT       (iPhoneX ? 34 : 0)
// 导航栏高度
#define KNAV_HEIGHT             (KSTATUSBAR_HEIGHT + 44)
// 底部TAB高度
#define KMAINTAB_HEIGHT         (KINDICATOR_HEIGHT + 49)
// 1像素
#define KONE_PIXELS             1.0f/([UIScreen mainScreen].scale)
// 以6s屏宽为基准，宽度缩放的比例
#define KWIDTH_SCALE            (iPhone5 ? (KSCREEN_WIDTH / 375.0) : 1.0)
// 以6s屏宽为基准，高度缩放的比例
#define KHEIGHT_SCALE           (iPhone5 ? (KSCREEN_HEIGHT / 667.0) : 1.0)

#pragma mark - 手机类型判断/iOS版本
// iPhone5
#define iPhone5         ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
// iPhone6 750x1334; 放大模式640, 1136
#define iPhone6         ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? (CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) || CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size)) : NO)
// iPhone6+ 1242, 2208; 放大模式1125, 2001
#define iPhone6Plus     ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? (CGSizeEqualToSize(CGSizeMake(1125, 2001), [[UIScreen mainScreen] currentMode].size) || CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size)) : NO)
// iPhoneX 375, 812
#define iPhoneX         ((CGSizeEqualToSize(CGSizeMake(375, 812), [UIScreen mainScreen].bounds.size)) || (CGSizeEqualToSize(CGSizeMake(812, 375), [UIScreen mainScreen].bounds.size)))
// iPad
#define iPad            (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? YES : NO)
// iOS系统版本号
#define IOS_VERSION_LATER(v) ([[[UIDevice currentDevice] systemVersion] compare:v] != NSOrderedAscending)
// iOS11设备
#define iOS11_DEVICE    @available(iOS 11.0, *)
// 横屏
#define IS_LANDSCAPE    UIInterfaceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation])


#pragma mark - 导航栏右侧按钮frame，分icon样式和文字样式两种
// icon样式
#define RECT_RIGHTBAR_ICON          CGRectMake(0, 0, 30, 30)
// 文字样式边框
#define RECT_RIGHTBAR_TEXT(LENGTH)  CGRectMake(0, 0, LENGTH * 15 + 13, 32)


#pragma mark - 字体
#define FONTSIZE(size)      (size)
// 系统普通字体
#define SYSTEM_FONT(size)   [UIFont systemFontOfSize:FONTSIZE(size)]
// 系统加粗字体
#define BOLD_FONT(size)     [UIFont boldSystemFontOfSize:FONTSIZE(size)]

#endif /* AppMacro_h */
