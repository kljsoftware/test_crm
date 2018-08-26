//
//  BCommentView.m
//  sales
//
//  Created by user on 2016/11/18.
//  Copyright © 2016年 rayootech. All rights reserved.
//

#import "BCommentView.h"
@implementation BCommentView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setupViews];
    }
    return self;
}

- (void)setupViews{
    _bgImageView = [UIImageView new];
    _bgImageView.backgroundColor = [UIColor colorWithHex:0xf3f3f3];
    [self addSubview:_bgImageView];
    _label = [MLLinkLabel new];
    UIColor *highLightColor = TimeLineCellHighlightedColor;
    _label.linkTextAttributes = @{NSForegroundColorAttributeName : highLightColor};
    _label.font = [UIFont systemFontOfSize:14];
    //    label.delegate = self;
    
    _bgImageView.sd_layout.spaceToSuperView(UIEdgeInsetsMake(0, 0, 0, 0));
    [self addSubview:_label];
    _label.sd_layout
    .leftSpaceToView(self, 8)
    .rightSpaceToView(self, 5)
    .topSpaceToView(self, 10)
    .autoHeightRatio(0);
    
    _label.isAttributedContent = YES;
    
    [self setupAutoHeightWithBottomView:_label bottomMargin:6];
}

- (void)setBComment:(Comment *)model{
//    MLLinkLabel *label = [MLLinkLabel new];
//    UIColor *highLightColor = TimeLineCellHighlightedColor;
//    label.linkTextAttributes = @{NSForegroundColorAttributeName : highLightColor};
//    label.font = [UIFont systemFontOfSize:14];
//    //    label.delegate = self;
//    [self addSubview:label];
    if (!model.attributedContent) {
        model.attributedContent = [self generateAttributedStringWithCommentItemModel:model];
    }
    _label.attributedText = model.attributedContent;
    
//    if (model.bname.length != 0) {
//        [_label sd_clearAutoLayoutSettings];
//        label.hidden = YES;
//    }
    
    if (model.bname.length == 0){//&& !likeItemsArray.count) {
        self.fixedWidth = @(0); // 如果没有评论或者点赞，设置commentview的固定宽度为0（设置了fixedWith的控件将不再在自动布局过程中调整宽度）
        self.fixedHeight = @(0); // 如果没有评论或者点赞，设置commentview的固定高度为0（设置了fixedHeight的控件将不再在自动布局过程中调整高度）
        _label.hidden = YES;
        return;
    } else {
        self.fixedHeight = nil; // 取消固定宽度约束
        self.fixedWidth = nil; // 取消固定高度约束
        _label.hidden = NO;
    }
    
    
}

- (NSMutableAttributedString *)generateAttributedStringWithCommentItemModel:(Comment *)model
{
    NSString *text = @"";
    if (model.bname.length) {
        text = [text stringByAppendingString:[NSString stringWithFormat:@"回复 %@", model.bname]];
    }
    text = [text stringByAppendingString:[NSString stringWithFormat:@"：%@", model.bcomment]];
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:text];
    [attString setAttributes:@{NSLinkAttributeName : [NSString stringWithFormat:@"%ld",model.buid]} range:[text rangeOfString:model.bname]];
   
    return attString;
}
- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
}
@end
