//
//  NSStringUtils.h
//  sales
//
//  Created by user on 2016/12/13.
//  Copyright © 2016年 rayootech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSStringUtils : NSObject

+ (BOOL)isEmpty:(NSString *)string;

+ (BOOL)isEmail:(NSString *)email;
@end
