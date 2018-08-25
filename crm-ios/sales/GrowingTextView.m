//
//  GrowingTextView.m
//  sales
//
//  Created by user on 2016/11/22.
//  Copyright © 2016年 rayootech. All rights reserved.
//

#import "GrowingTextView.h"

@implementation GrowingTextView

- (instancetype)initWithPlaceholder:(NSString *)placeholder
{
    self = [super init];
    if (self) {
        self.placeholder = placeholder;
        self.font = [UIFont systemFontOfSize:15];
        self.scrollEnabled = NO;
        self.scrollsToTop = NO;
        self.showsHorizontalScrollIndicator = NO;
        self.enablesReturnKeyAutomatically = YES;
        //        self.textContainerInset = UIEdgeInsetsMake(7.5, 3.5, 7.5, 0);
        self.textContainerInset = UIEdgeInsetsMake(8, 4, 8, 0);
        self.layer.contentsScale = [UIScreen mainScreen].scale;
        //NSLog(@"%@, %f", self.font, self.font.lineHeight);
        _maxNumberOfLines = 4;
        _maxHeight = ceilf(self.font.lineHeight * _maxNumberOfLines + 15 + 4 * (_maxNumberOfLines - 1));
    }
    
    return self;
}

// Code from apple developer forum - @Steve Krulewitz, @Mark Marszal, @Eric Silverberg
- (CGFloat)measureHeight
{
    return ceilf([self sizeThatFits:self.frame.size].height + 16);
}



@end
