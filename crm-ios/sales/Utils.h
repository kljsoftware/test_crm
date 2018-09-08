//
//  Utils.h
//  sales
//
//  Created by user on 2016/11/7.
//  Copyright © 2016年 rayootech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Utils : NSObject

+ (BOOL)mobileIsUsable:(NSString *)mobile;
+ (BOOL)emailIsUsable:(NSString *)email;
+ (BOOL)urlIsUsable:(NSString *)url;
+ (MBProgressHUD *)createHUD;
+ (void)showHUD:(NSString *)text;
+ (NSAttributedString *)attributedTimeString:(NSDate *)date;

@end
