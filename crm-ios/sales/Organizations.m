//
//  Organization.m
//  sales
//
//  Created by user on 2016/12/30.
//  Copyright © 2016年 rayootech. All rights reserved.
//

#import "Organizations.h"

@implementation Organizations
@dynamic description;

+(NSDictionary *)replacedKeyFromPropertyName{
    return @{@"Description":@"description"};
}
@end
