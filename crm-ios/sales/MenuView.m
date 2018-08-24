//
//  MenuView.m
//  sales
//
//  Created by Sunny on 2018/8/23.
//  Copyright © 2018年 rayootech. All rights reserved.
//

#import "MenuView.h"

#define KONE_PIXELS     1.0f/([UIScreen mainScreen].scale)

@interface MenuView ()

@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) NSArray *menuItems;
@property (nonatomic, assign) NSInteger curSelIndex;
@property (nonatomic, copy) MenuBlock block;

@end

@implementation MenuView

// MARK: - 实例化方法
- (instancetype)initWithMenuItems:(NSArray *)menuItems currentSelectIndex:(NSInteger)curSelIndex selectIndexs:(MenuBlock)block {
    
    if (self = [super init]) {
        
        self.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hide)];
        [self addGestureRecognizer:tap];
        
        self.menuItems = menuItems;
        self.curSelIndex = curSelIndex;
        self.block = block;
        
        _bgView = [[UIView alloc] init];
        _bgView.clipsToBounds = true;
        _bgView.backgroundColor = UIColor.whiteColor;
        [self addSubview:_bgView];
        [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(self);
            make.height.mas_equalTo(0);
        }];
        
        for (int i = 0; i < self.menuItems.count; i++) {
            
            // 按钮
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.tag = i+1000;
            [btn addTarget:self action:@selector(cellClicked:) forControlEvents:UIControlEventTouchUpInside];
            [_bgView addSubview:btn];
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(i*50);
                make.left.right.equalTo(_bgView);
                make.height.mas_equalTo(50);
            }];
            
            // 标题
            UILabel *titleLabel = [[UILabel alloc] init];
            titleLabel.text = menuItems[i];
            titleLabel.tag = btn.tag + 1000;
            titleLabel.textColor = i == curSelIndex ? SDColor(64, 85, 237, 1) : [UIColor lightGrayColor];
            titleLabel.font = [UIFont systemFontOfSize:13];
            [btn addSubview:titleLabel];
            [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(btn);
                make.left.mas_equalTo(20);
            }];
            
            // 线条
            UIView *lineView = [[UIView alloc] init];
            lineView.backgroundColor = [UIColor colorWithHex:0xEDEDED];
            [btn addSubview:lineView];
            [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.top.equalTo(btn);
                make.height.mas_equalTo(KONE_PIXELS);
            }];
        }
    }
    return self;
}

- (void)cellClicked:(UIButton *)sender {
    UILabel *label = (UILabel *)[sender viewWithTag:sender.tag+1000];
    label.textColor = SDColor(64, 85, 237, 1);
    self.curSelIndex = sender.tag-1000;
    [self hide];
}

// 显示
- (void)show {
    
    // 弹出动画
    [self layoutIfNeeded];
    
    [self.bgView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(self.menuItems.count*50);
    }];
    
    [UIView animateWithDuration:0.3 animations:^{
        [self layoutIfNeeded];
        self.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.6];
    }];
}

// 隐藏
- (void)hide {
    
    [self.bgView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(0);
    }];
    [UIView animateWithDuration:0.3 animations:^{
        self.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0];
        [self layoutIfNeeded];
        
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
    
    if (self.block) {
        self.block(self.curSelIndex);
    }
}

@end
