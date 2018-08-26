//
//  CCSegmentControl.m
//  自定义segment
//
//  Created by Sunny on 17/11/12.
//  Copyright (c) 2017年 合作喵. All rights reserved.
//

#import "CCSegmentView.h"

@interface CCSegmentView ()

@property (nonatomic, strong) NSMutableArray *btnArray;
@property (nonatomic, strong) UIView *lineView; // 下滑线

@end

@implementation CCSegmentView

- (instancetype)initWithTitles:(NSArray *)titles normalColor:(UIColor *)normalColor selectColor:(UIColor *)selectColor {
    
    if (self = [super init]) {
        self.backgroundColor = [UIColor whiteColor];

        WeakSelf;
        _btnArray = [[NSMutableArray alloc] init];
        // 按钮
        for (int i = 0; i < titles.count; i++) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.tag = i+1;
            btn.titleLabel.font = SYSTEM_FONT(14);
            [btn setTitle:titles[i] forState:UIControlStateNormal];
            [btn setTitleColor:normalColor forState:UIControlStateNormal];
            [btn setTitleColor:selectColor forState:UIControlStateSelected];
            [btn addTarget:self action:@selector(segmentClicked:) forControlEvents:UIControlEventTouchUpInside];
            if (i == 0) {
                btn.titleLabel.font = BOLD_FONT(14);
                btn.selected = YES;
                btn.userInteractionEnabled = false;
            }
            [self addSubview:btn];
            [_btnArray addObject:btn];
        }
        [_btnArray mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:10 leadSpacing:10 tailSpacing:10];
        [_btnArray mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(weakSelf);
        }];
        
        
        // 分割线
        UIView *bottomLine = [[UIView alloc] init];
        bottomLine.backgroundColor = [UIColor colorWithHex:0xf2f2f2];
        [self addSubview:bottomLine];
        [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(weakSelf);
            make.height.mas_equalTo(KONE_PIXELS);
        }];
        
        // 下划线
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = SDColor(31, 90, 248, 1);
        _lineView.layer.cornerRadius = 1;
        _lineView.layer.masksToBounds = true;
        [self addSubview:_lineView];
        [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(30);
            make.height.mas_equalTo(2);
            make.bottom.equalTo(weakSelf);
            make.centerX.equalTo(weakSelf.btnArray[0]);
        }];
    }
    return self;
}

// 点击segment
- (void)segmentClicked:(UIButton *)sender {
    [self setIndex:sender.tag-1];
}

// 设置下滑线位置
- (void)setIndex:(NSInteger)index {
    
    for (UIButton *btn in _btnArray) {
        btn.selected = btn.tag == index+1;
        btn.titleLabel.font = btn.tag == index+1 ? BOLD_FONT(14) : SYSTEM_FONT(14);
        btn.userInteractionEnabled = !btn.selected;
    }
    
    WeakSelf;
    [_lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(30);
        make.height.mas_equalTo(2);
        make.bottom.equalTo(weakSelf);
        make.centerX.equalTo(_btnArray[index]);
    }];
    
    [UIView animateWithDuration:0.3 animations:^{
        [self layoutIfNeeded];
    }];
    
    if (self.segmentBlock) {
        self.segmentBlock(index);
    }
}

@end
