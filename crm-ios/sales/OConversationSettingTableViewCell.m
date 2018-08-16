//
//  OConversationSettingTableViewCell.m
//  sales
//
//  Created by user on 2016/12/28.
//  Copyright © 2016年 rayootech. All rights reserved.
//

#import "OConversationSettingTableViewCell.h"

@implementation OConversationSettingTableViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        _label = [[UILabel alloc] initWithFrame:CGRectZero];
        [_label setTextAlignment:NSTextAlignmentLeft];
        _swich = [[UISwitch alloc] initWithFrame:CGRectZero];
        [self addSubview:_label];
        [self addSubview:_swich];
        
        [_swich setTranslatesAutoresizingMaskIntoConstraints:NO];
        [_label setTranslatesAutoresizingMaskIntoConstraints:NO];
        
        [self addConstraints:
         [NSLayoutConstraint
          constraintsWithVisualFormat:@"V:[_swich(33)]"
          options:kNilOptions
          metrics:nil
          views:NSDictionaryOfVariableBindings(
                                               _swich)]];
        //        [self addConstraints:[NSLayoutConstraint
        //        constraintsWithVisualFormat:@"H:[_swich(35)]-30-|"
        //                                                                     options:kNilOptions
        //                                                                     metrics:nil
        //                                                                       views:NSDictionaryOfVariableBindings(_swich)]];
        [self addConstraint:[NSLayoutConstraint
                             constraintWithItem:_swich
                             attribute:NSLayoutAttributeCenterY
                             relatedBy:NSLayoutRelationEqual
                             toItem:self
                             attribute:NSLayoutAttributeCenterY
                             multiplier:1.0f
                             constant:0]];
        
        [self addConstraints:
         [NSLayoutConstraint
          constraintsWithVisualFormat:@"V:[_label(30)]"
          options:kNilOptions
          metrics:nil
          views:NSDictionaryOfVariableBindings(
                                               _label)]];
        [self addConstraints:
         [NSLayoutConstraint
          constraintsWithVisualFormat:@"H:|-16-[_label]"
          options:kNilOptions
          metrics:nil
          views:NSDictionaryOfVariableBindings(
                                               _label, _swich)]];
        [self addConstraint:[NSLayoutConstraint
                             constraintWithItem:_swich
                             attribute:NSLayoutAttributeRight
                             relatedBy:NSLayoutRelationEqual
                             toItem:self
                             attribute:NSLayoutAttributeRight
                             multiplier:1.0f
                             constant:-20]];
        [self addConstraint:[NSLayoutConstraint
                             constraintWithItem:_label
                             attribute:NSLayoutAttributeCenterY
                             relatedBy:NSLayoutRelationEqual
                             toItem:self
                             attribute:NSLayoutAttributeCenterY
                             multiplier:1.0f
                             constant:0]];
    }
    return self;
}


@end
