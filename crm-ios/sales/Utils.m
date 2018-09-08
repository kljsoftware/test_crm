//
//  Utils.m
//  sales
//
//  Created by user on 2016/11/7.
//  Copyright © 2016年 rayootech. All rights reserved.
//

#import "UIFont+FontAwesome.h"
#import "NSString+FontAwesome.h"

@implementation Utils

// 判断是否是手机号码
+ (BOOL)mobileIsUsable:(NSString *)mobile {
    NSString *format = @"^((13[0-9])|(14[0-9])|(15[0-9])|(17[0-9])|(18[0-9]))\\d{8}$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", format];
    return [predicate evaluateWithObject:mobile];
}

// 判断是否是邮箱
+ (BOOL)emailIsUsable:(NSString *)email {
    NSString *format = @"^[a-zA-Z0-9_.-]+@[a-zA-Z0-9-]+(\.[a-zA-Z0-9-]+)*\.[a-zA-Z0-9]{2,6}$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", format];
    return [predicate evaluateWithObject:email];
}

// 判断是否是网址
+ (BOOL)urlIsUsable:(NSString *)url {
    NSString *format = @"\\bhttps?://[a-zA-Z0-9\\-.]+(?::(\\d+))?(?:(?:/[a-zA-Z0-9\\-._?,'+\\&%$=~*!():@\\\\]*)+)?";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", format];
    return [predicate evaluateWithObject:url];
}

+ (MBProgressHUD *)createHUD
{
    UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:window];
    HUD.detailsLabel.font = [UIFont boldSystemFontOfSize:16];
    [window addSubview:HUD];
    [HUD showAnimated:YES];
    HUD.removeFromSuperViewOnHide = YES;
    //[HUD addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:HUD action:@selector(hide:)]];
    
    return HUD;
}

+ (void)showHUD:(NSString *)text {
    
    UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:window];
    HUD.mode = MBProgressHUDModeText;
    HUD.detailsLabel.font = [UIFont boldSystemFontOfSize:16];
    [window addSubview:HUD];
    [HUD showAnimated:YES];
    HUD.removeFromSuperViewOnHide = YES;
    HUD.label.text = text;
    [HUD hideAnimated:YES afterDelay:1];
}

+ (NSAttributedString *)attributedTimeString:(NSDate *)date
{
    //    NSString *rawString = [NSString stringWithFormat:@"%@ %@", [NSString fontAwesomeIconStringForEnum:FAClockO], [date timeAgoSinceNow]];
    NSString *rawString = [date timeAgoSinceNow];
    
    NSAttributedString *attributedTime = [[NSAttributedString alloc] initWithString:rawString
                                                                         attributes:@{
                                                                                      NSFontAttributeName: [UIFont fontAwesomeFontOfSize:12],
                                                                                      }];
    
    return attributedTime;
}

@end
