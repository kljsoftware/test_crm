//
//  GrowingTextView.h
//  sales
//
//  Created by user on 2016/11/22.
//  Copyright © 2016年 rayootech. All rights reserved.
//

#import "PlaceholderTextView.h"

@interface GrowingTextView : PlaceholderTextView
@property (nonatomic, assign) NSUInteger maxNumberOfLines;
@property (nonatomic, readonly) CGFloat maxHeight;

- (instancetype)initWithPlaceholder:(NSString *)placeholder;
- (CGFloat)measureHeight;
@end
