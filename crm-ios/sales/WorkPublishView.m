//
//  WorkPublishView.m
//  sales
//
//  Created by Sunny on 2018/8/25.
//  Copyright © 2018年 rayootech. All rights reserved.
//

#import "WorkPublishView.h"

#define LAND_EDGE       40.0
#define LAND_SPACE      (KSCREEN_WIDTH - 3*ITEM_WIDTH - 2*LAND_EDGE)/2
#define PORT_SPACE      20.0
#define ITEM_WIDTH      50.0
#define ITEM_HEIGHT     (ITEM_WIDTH + 18.0 + 4.0)
#define CANCEL_HEIGHT   49.0

@interface WorkPublishView () <UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) NSArray *items;
@property (nonatomic, assign) CGFloat bgHeight;

@property (nonatomic, copy) WorkPublishBlock block;

@end

@implementation WorkPublishView

// MARK: - 实例化方法
- (instancetype)initWithItem:(NSArray *)items selectIndex:(WorkPublishBlock)block {

    if (self = [super init]) {
        self.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hide)];
        tap.delegate = self;
        [self addGestureRecognizer:tap];
        
        self.items = items;
        self.block = block;
        
        NSInteger lineNum = items.count%3 == 0 ? items.count/3 : items.count/3 + 1;
        self.bgHeight = lineNum*ITEM_HEIGHT + (lineNum+1)*PORT_SPACE + CANCEL_HEIGHT + KINDICATOR_HEIGHT;
        
        // 背景视图
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_bgView];
        [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self);
            make.bottom.height.mas_equalTo(self.bgHeight);
        }];
        
        CGFloat x = LAND_EDGE;
        CGFloat y = PORT_SPACE;
        for (int i = 0; i < items.count; i++) {
            
            PublishItem *item = items[i];
            
            // 按钮
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.enabled = item.enabled;
            btn.tag = i+1000;
            [btn addTarget:self action:@selector(itemClicked:) forControlEvents:UIControlEventTouchUpInside];
            [_bgView addSubview:btn];
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(y);
                make.left.mas_equalTo(x);
                make.width.mas_equalTo(ITEM_WIDTH);
                make.height.mas_equalTo(ITEM_HEIGHT);
            }];
            
            // 图标
            UIImageView *icon = [[UIImageView alloc] init];
            icon.image = [UIImage imageNamed:item.enabled ? item.normalIcon : item.disableIcon];
            icon.contentMode = UIViewContentModeScaleAspectFit;
            icon.userInteractionEnabled = false;
            [btn addSubview:icon];
            [icon mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(0);
                make.centerX.equalTo(btn);
                make.width.height.mas_equalTo(ITEM_WIDTH);
            }];
            
            // 标题
            UILabel *titleLabel = [[UILabel alloc] init];
            titleLabel.text = item.title;
            titleLabel.font = SYSTEM_FONT(12);
            titleLabel.adjustsFontSizeToFitWidth = true;
            titleLabel.textAlignment = NSTextAlignmentCenter;
            [btn addSubview:titleLabel];
            [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(icon.mas_bottom).offset(4);
                make.centerX.mas_equalTo(icon);
                make.width.mas_equalTo(ITEM_WIDTH+30);
                make.height.mas_equalTo(18);
            }];
            
            if ((i+1)%3 != 0) {
                x += ITEM_WIDTH + LAND_SPACE;
            } else {
                x = LAND_EDGE;
                y += ITEM_HEIGHT + PORT_SPACE;
            }
        }
        
        // 取消
        UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        cancelBtn.titleLabel.font = SYSTEM_FONT(17);
        [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [cancelBtn setTitleColor:[UIColor colorWithHex:0x333333] forState:UIControlStateNormal];
        [cancelBtn addTarget:self action:@selector(hide) forControlEvents:UIControlEventTouchUpInside];
        [_bgView addSubview:cancelBtn];
        [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.bgView);
            make.bottom.equalTo(self.bgView).offset(-KINDICATOR_HEIGHT);
            make.height.mas_equalTo(CANCEL_HEIGHT);
        }];
        
        // 线条
        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = [UIColor lightGrayColor];
        [_bgView addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.bgView);
            make.bottom.equalTo(cancelBtn.mas_top);
            make.height.mas_equalTo(KONE_PIXELS);
        }];
    }
    return self;
}

// 显示
- (void)show {
    
    // 弹出动画
    [self layoutIfNeeded];
    WeakSelf;
    [self.bgView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weakSelf);
    }];
    [UIView animateWithDuration:0.3 animations:^{
        [self layoutIfNeeded];
        self.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.6];
    }];
}

// 隐藏
- (void)hide {
    
    WeakSelf;
    [self.bgView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(weakSelf.bgHeight);
    }];
    [UIView animateWithDuration:0.3 animations:^{
        self.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0];
        [self layoutIfNeeded];
        
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)itemClicked:(UIButton *)sender {
    
    [self hide];
    if (self.block) {
        self.block(sender.tag-1000);
    }
}

// MARK: - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    
    if ([touch.view isDescendantOfView:self.bgView]) {
        return false;
    }
    return true;
}

@end

@implementation PublishItem

- (instancetype)initWithTitle:(NSString *)title normalIcon:(NSString *)normalIcon disableIcon:(NSString *)disableIcon enabled:(BOOL)enabled {
    if (self = [super init]) {
        self.title = title;
        self.normalIcon = normalIcon;
        self.disableIcon = disableIcon;
        self.enabled = enabled;
    }
    return self;
}

@end
