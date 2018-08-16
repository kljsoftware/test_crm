//
//  Utils.h
//  sales
//
//  Created by user on 2016/11/7.
//  Copyright © 2016年 rayootech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MBProgressHUD.h>
@interface Utils : NSObject

+ (MBProgressHUD *)createHUD;
+ (NSAttributedString *)attributedTimeString:(NSDate *)date;

@end
