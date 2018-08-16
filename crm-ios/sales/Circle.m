//
//  Circle.m
//  sales
//
//  Created by user on 2016/11/11.
//  Copyright © 2016年 rayootech. All rights reserved.
//

#import "Circle.h"
#import "Comment.h"
#import <UIKit/UIKit.h>

extern const CGFloat contentLabelFontSize;
extern CGFloat maxContentLabelHeight;

@implementation Circle
{
    CGFloat _lastContentWidth;
}
@synthesize content = _content;

- (void)setContent:(NSString *)content
{
    _content = content;
}

- (NSString *)content
{
    CGFloat contentW = [UIScreen mainScreen].bounds.size.width - 70;
    if (contentW != _lastContentWidth) {
        _lastContentWidth = contentW;
        CGRect textRect = [_content boundingRectWithSize:CGSizeMake(contentW, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:contentLabelFontSize]} context:nil];
        if (textRect.size.height > maxContentLabelHeight) {
            _shouldShowMoreButton = YES;
        } else {
            _shouldShowMoreButton = NO;
        }
    }
    return _content;
}

- (void)setIsOpening:(BOOL)isOpening
{
    if (!_shouldShowMoreButton) {
        _isOpening = NO;
    } else {
        _isOpening = isOpening;
    }
}

+ (NSDictionary *)mj_objectClassInArray{
    return @{ @"commentsList":@"Comment"
             };
}

@end
