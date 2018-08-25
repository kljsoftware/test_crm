//
//  EditingBar.m
//  sales
//
//  Created by user on 2016/11/22.
//  Copyright © 2016年 rayootech. All rights reserved.
//

#import "EditingBar.h"
#import "UIView+Util.h"
#import "GrowingTextView.h"

@implementation EditingBar

- (instancetype)initWithShowSwitch:(BOOL)showSwitch showPhoto:(BOOL)showPhoto {
    if (self = [super init]) {
        self.backgroundColor = [UIColor whiteColor];
        self.barTintColor = [UIColor whiteColor];
        [self layoutIfNeeded];

        _editView = [[GrowingTextView alloc] initWithPlaceholder:@"说点什么"];
        _editView.returnKeyType = UIReturnKeySend;
        [_editView setCornerRadius:17];
        
        [_editView setBorderWidth:0.5f andColor:[UIColor colorWithHex:0xc7c7cc]];
        _editView.backgroundColor = [UIColor colorWithHex:0xf2f2f2];
        _editView.textColor = [UIColor colorWithHex:0x333333];
        [self addSubview:_editView];
        
        UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        cancelBtn.layer.cornerRadius = 4;
        cancelBtn.titleLabel.font = SYSTEM_FONT(14);
        cancelBtn.layer.masksToBounds = true;
        cancelBtn.backgroundColor = [UIColor colorWithHex:0xf2f2f2];
        [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [cancelBtn setTitleColor:[UIColor colorWithHex:0x333333] forState:UIControlStateNormal];
        [cancelBtn addTarget:self action:@selector(cancelClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:cancelBtn];
        
        UIView *topLine = [[UIView alloc] init];
        topLine.backgroundColor = [UIColor lightGrayColor];
        [self addSubview:topLine];
        
        [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-12);
            make.height.mas_equalTo(36);
            make.width.mas_equalTo(60);
            make.centerY.equalTo(self);
        }];
        
        [_editView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(12);
            make.right.equalTo(cancelBtn.mas_left).offset(-12);
            make.top.mas_equalTo(8);
            make.bottom.mas_equalTo(-8);
        }];
        
        [topLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(self);
            make.height.mas_equalTo(KONE_PIXELS);
        }];
    }
    return self;
}

- (void)cancelClick {
    [_editView resignFirstResponder];
}

@end
