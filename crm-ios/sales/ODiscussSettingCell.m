//
//  ODiscussSettingCell.m
//  sales
//
//  Created by user on 2016/12/27.
//  Copyright © 2016年 rayootech. All rights reserved.
//

#import "ODiscussSettingCell.h"

@implementation ODiscussSettingCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        _lblDiscussName = [[UILabel alloc] initWithFrame:CGRectZero];
        [_lblDiscussName setTextAlignment:NSTextAlignmentRight];
        _lblTitle = [[UILabel alloc] initWithFrame:CGRectZero];
        
        [self.contentView addSubview:_lblTitle];
        [self.contentView addSubview:_lblDiscussName];
        
        [_lblDiscussName setTranslatesAutoresizingMaskIntoConstraints:NO];
        [_lblTitle setTranslatesAutoresizingMaskIntoConstraints:NO];
        
        [self.contentView
         addConstraints:
         [NSLayoutConstraint
          constraintsWithVisualFormat:
          @"H:|-16-[_lblTitle]-80-[_lblDiscussName]|"
          options:kNilOptions
          metrics:nil
          views:NSDictionaryOfVariableBindings(
                                               _lblDiscussName, _lblTitle)]];
        [self.contentView
         addConstraints:
         [NSLayoutConstraint
          constraintsWithVisualFormat:@"V:[_lblTitle(30)]"
          options:kNilOptions
          metrics:nil
          views:NSDictionaryOfVariableBindings(
                                               _lblTitle)]];
        [self.contentView
         addConstraints:
         [NSLayoutConstraint
          constraintsWithVisualFormat:@"V:[_lblDiscussName(30)]"
          options:kNilOptions
          metrics:nil
          views:NSDictionaryOfVariableBindings(
                                               _lblDiscussName)]];
        
        [self.contentView
         addConstraint:[NSLayoutConstraint
                        constraintWithItem:_lblTitle
                        attribute:NSLayoutAttributeCenterY
                        relatedBy:NSLayoutRelationEqual
                        toItem:self.contentView
                        attribute:NSLayoutAttributeCenterY
                        multiplier:1.0f
                        constant:0]];
        [self.contentView
         addConstraint:[NSLayoutConstraint
                        constraintWithItem:_lblDiscussName
                        attribute:NSLayoutAttributeCenterY
                        relatedBy:NSLayoutRelationEqual
                        toItem:self.contentView
                        attribute:NSLayoutAttributeCenterY
                        multiplier:1.0f
                        constant:0]];
    }
    return self;
}


@end
