//
//  UIFont+FontAwesome.m
//  sales
//
//  Created by user on 2016/11/15.
//  Copyright © 2016年 rayootech. All rights reserved.
//

#import "UIFont+FontAwesome.h"
#import "NSString+FontAwesome.h"
@implementation UIFont (FontAwesome)

+ (UIFont*)fontAwesomeFontOfSize:(CGFloat)size {
    UIFont *font = [UIFont fontWithName:kFontAwesomeFamilyName size:size];
    NSAssert(font!=nil, @"%@ couldn't be loaded",kFontAwesomeFamilyName);
    return font;
}

@end
