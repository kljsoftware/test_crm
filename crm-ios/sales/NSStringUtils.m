//
//  NSStringUtils.m
//  sales
//
//  Created by user on 2016/12/13.
//  Copyright © 2016年 rayootech. All rights reserved.
//


@implementation NSStringUtils

+ (BOOL)isEmpty:(NSString *)string{
    if(string == nil || string == NULL){
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length] == 0) {
        return YES;
    }
    return NO;
}

+ (BOOL)isEmail:(NSString *)email{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",emailRegex];
    return [emailTest evaluateWithObject:email];
}
@end
