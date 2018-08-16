//
//  UIColor.h
//  sales
//
//  Created by user on 2016/11/4.
//  Copyright © 2016年 rayootech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Util)

+ (UIColor *)colorWithHex:(int)hexValue alpha:(CGFloat)alpha;
+ (UIColor *)colorWithHex:(int)hexValue;
+ (UIColor *)themeColor;
+ (UIColor *)cellsColor;
+ (UIColor *)lineColor;
+ (UIColor *)colorWithHexString:(NSString *)color alpha:(CGFloat)alpha;
@end
