//
//  OConversationSettingTableViewHeaderItem.m
//  sales
//
//  Created by user on 2016/12/27.
//  Copyright © 2016年 rayootech. All rights reserved.
//

#import "OConversationSettingTableViewHeaderItem.h"

@implementation OConversationSettingTableViewHeaderItem
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _ivAva = [[UIImageView alloc] initWithFrame:CGRectZero];
        _ivAva.clipsToBounds = YES;
        _ivAva.layer.cornerRadius = 5.f;
        [_ivAva setBackgroundColor:[UIColor clearColor]];
        [self.contentView addSubview:_ivAva];
        
        _titleLabel = [UILabel new];
        [_titleLabel setTextColor:[UIColor colorWithHexString:@"0x999999" alpha:1.0]];
        [_titleLabel setFont:[UIFont systemFontOfSize:13]];
        [_titleLabel setTextAlignment:NSTextAlignmentCenter];
        [self.contentView addSubview:_titleLabel];
        
        _btnImg = [[UIButton alloc] initWithFrame:CGRectZero];
        [_btnImg setHidden:YES];
//        [_btnImg setImage:[RCDUtilities imageNamed:@"delete_member_tip"
//                                          ofBundle:@"RongCloud.bundle"]
//                 forState:UIControlStateNormal];
        
        [_btnImg setImage:[UIImage imageNamed:@"delete_member_tip"] forState:UIControlStateNormal];
        [_btnImg setImage:[UIImage imageNamed:@"delete_member_tip"] forState:UIControlStateSelected];
        
        [_btnImg addTarget:self
                    action:@selector(deleteItem:)
          forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_btnImg];
        
        [_ivAva setTranslatesAutoresizingMaskIntoConstraints:NO];
        [_titleLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
        [_btnImg setTranslatesAutoresizingMaskIntoConstraints:NO];
        
        [self.contentView
         addConstraints:
         [NSLayoutConstraint
          constraintsWithVisualFormat:@"H:|[_ivAva]|"
          options:kNilOptions
          metrics:nil
          views:NSDictionaryOfVariableBindings(
                                               _ivAva)]];
        
        [self.contentView
         addConstraints:
         [NSLayoutConstraint
          constraintsWithVisualFormat:@"H:|[_titleLabel]|"
          options:kNilOptions
          metrics:nil
          views:NSDictionaryOfVariableBindings(
                                               _titleLabel)]];
        [self.contentView
         addConstraints:
         [NSLayoutConstraint
          constraintsWithVisualFormat:
          @"V:|[_ivAva(55)]-9-[_titleLabel(==15)]"
          options:kNilOptions
          metrics:nil
          views:NSDictionaryOfVariableBindings(
                                               _titleLabel, _ivAva)]];
        
        [self.contentView
         addConstraints:
         [NSLayoutConstraint
          constraintsWithVisualFormat:@"H:|[_btnImg(25)]"
          options:kNilOptions
          metrics:nil
          views:NSDictionaryOfVariableBindings(
                                               _btnImg)]];
        [self.contentView
         addConstraints:
         [NSLayoutConstraint
          constraintsWithVisualFormat:@"V:|[_btnImg(25)]"
          options:kNilOptions
          metrics:nil
          views:NSDictionaryOfVariableBindings(
                                               _btnImg)]];
        
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_titleLabel
                                                                     attribute:NSLayoutAttributeCenterX
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:_ivAva
                                                                     attribute:NSLayoutAttributeCenterX
                                                                    multiplier:1.0f
                                                                      constant:0
                                         ]];
        
    }
    return self;
}

- (void)deleteItem:(id)sender {
    if (self.delegate &&
        [self.delegate respondsToSelector:@selector(deleteTipButtonClicked:)]) {
        [self.delegate deleteTipButtonClicked:self];
    }
}

- (void)setUserModel:(Contact *)userModel {
    NSString *id = [NSString stringWithFormat:@"%ld",userModel.fid];
//    self.ivAva.image = nil;
    self.userId = [@"out_" stringByAppendingString:id];
    self.titleLabel.text = userModel.name;
    [self.ivAva loadPortrait:userModel.avatar];
//    if ([userModel.avatar isEqualToString:@""]) {
//        DefaultPortraitView *defaultPortrait =
//        [[DefaultPortraitView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
//        [defaultPortrait setColorAndLabel:userModel.userId Nickname:userModel.name];
//        UIImage *portrait = [defaultPortrait imageFromView];
//        self.ivAva.image = portrait;
//    } else {
//        [self.ivAva sd_setImageWithURL:[NSURL URLWithString:userModel.portraitUri]
//                      placeholderImage:[UIImage imageNamed:@"icon_person"]];
//    }
}

@end
