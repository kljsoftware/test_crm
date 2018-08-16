//
//  UIColor+RCColor.h
//  sales
//
//  Created by user on 2016/12/19.
//  Copyright © 2016年 rayootech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (RCColor)

+ (UIColor *)colorWithHexString:(NSString *)color alpha:(CGFloat)alpha;

// UIColor 转UIImage
+ (UIImage *)imageWithColor:(UIColor *)color;

@end
