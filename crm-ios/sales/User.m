//
//  User.m
//  sales
//
//  Created by user on 2016/11/7.
//  Copyright © 2016年 rayootech. All rights reserved.
//

#import "User.h"

@implementation User

@dynamic description;

+(NSDictionary *)replacedKeyFromPropertyName{
    return @{@"Description":@"description"};
}

@end
