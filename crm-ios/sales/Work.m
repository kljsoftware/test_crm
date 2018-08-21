//
//  Work.m
//  sales
//
//  Created by user on 2017/4/10.
//  Copyright © 2017年 rayootech. All rights reserved.
//

#import "Work.h"
#import "OrgUserInfo.h"
#import <UIKit/UIKit.h>
extern const CGFloat contentLabelFontSize3;
extern CGFloat maxContentLabelHeight3;
@implementation Work
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
        CGRect textRect = [_content boundingRectWithSize:CGSizeMake(contentW, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:contentLabelFontSize3]} context:nil];
        if (textRect.size.height > maxContentLabelHeight3) {
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
    return @{ @"workCommentsList":@"Comment",@"staffList":@"OrgUserInfo",@"workCommentsIds":@"NSInteger"
              };
}

-(void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeInteger:self.id forKey:@"id"];
    [aCoder encodeInteger:self.counts forKey:@"counts"];
    [aCoder encodeObject:self.user forKey:@"user"];
    [aCoder encodeObject:self.avatar forKey:@"avatar"];
    [aCoder encodeObject:self.content forKey:@"content"];
    [aCoder encodeObject:self.workCommentsIds forKey:@"workCommentsIds"];
}
-(id)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super init]) {
        self.id = [aDecoder decodeIntegerForKey:@"id"];
        self.user = [aDecoder decodeObjectForKey:@"user"];
        self.avatar = [aDecoder decodeObjectForKey:@"avatar"];
        self.counts = [aDecoder decodeIntegerForKey:@"counts"];
        self.content = [aDecoder decodeObjectForKey:@"content"];
        self.workCommentsIds = [aDecoder decodeObjectForKey:@"workCommentsIds"];
        
    }
    return self;
}
@end
