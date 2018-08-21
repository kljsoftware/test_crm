//
//  BlackBoard.m
//  sales
//
//  Created by user on 2017/2/14.
//  Copyright © 2017年 rayootech. All rights reserved.
//

#import "BlackBoard.h"
#import <UIKit/UIKit.h>

extern const CGFloat contentLabelFontSize1;
extern CGFloat maxContentLabelHeight1;
@implementation BlackBoard
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
        CGRect textRect = [_content boundingRectWithSize:CGSizeMake(contentW, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:contentLabelFontSize1]} context:nil];
        if (textRect.size.height > maxContentLabelHeight1) {
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
    return @{ @"bbCommentsList":@"Comment"
              };
}
@end
