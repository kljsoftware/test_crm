//
//  ServiceNoTableViewCell.m
//  sales
//
//  Created by user on 2017/2/9.
//  Copyright © 2017年 rayootech. All rights reserved.
//

#import "ServiceNoTableViewCell.h"
@interface ServiceNoTableViewCell ()

@property (nonatomic, strong) UIView *container;
@property (nonatomic, strong) UIImageView *containerBackgroundImageView;
@property (nonatomic, strong) UILabel *department;
@property (nonatomic, strong) UILabel *sentTime;
@property (nonatomic, strong) UILabel *content;
@property (nonatomic, strong) UIView *spliteline;
@property (nonatomic, strong) UIButton *agree;
@property (nonatomic, strong) UIButton *disagree;
@property (nonatomic, strong) UILabel *result;

@end

@implementation ServiceNoTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupView];
    }
    return self;
}

- (void)setupView{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
//    self.contentView.backgroundColor = [UIColor clearColor];
    _container = [UIView new];
    [self.contentView addSubview:_container];
    
    _department = [UILabel new];
    _department.font = [UIFont systemFontOfSize:12];
    _department.numberOfLines = 1;
    [_container addSubview:_department];
    
    _sentTime = [UILabel new];
    _sentTime.font = [UIFont systemFontOfSize:12];
    _sentTime.numberOfLines = 1;
    [_container addSubview:_sentTime];
    
    _content = [UILabel new];
    _content.font = [UIFont systemFontOfSize:14.0f];
    _content.numberOfLines = 0;
    [_container addSubview:_content];
    
    _spliteline = [UIView new];
    _spliteline.backgroundColor = [UIColor lightGrayColor];
    [_container addSubview:_spliteline];
    
    _agree = [UIButton new];
    [_agree setTitle:@"同意" forState:UIControlStateNormal];
    _agree.backgroundColor = [UIColor colorWithHex:0x469DE5];//TimeLineCellHighlightedColor
    [_agree setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_agree addTarget:self action:@selector(dealServiceNo:) forControlEvents:UIControlEventTouchUpInside];
    _agree.titleLabel.font = [UIFont systemFontOfSize:14];
    _agree.tag = 1;
    [_container addSubview:_agree];
    
    _disagree = [UIButton new];
    [_disagree setTitle:@"拒绝" forState:UIControlStateNormal];
    _disagree.backgroundColor = [UIColor redColor];
    [_disagree addTarget:self action:@selector(dealServiceNo:) forControlEvents:UIControlEventTouchUpInside];
    [_disagree setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _disagree.titleLabel.font = [UIFont systemFontOfSize:14];
    _disagree.tag = 0;
    [_container addSubview:_disagree];
    
    _result = [UILabel new];
    _result.font = [UIFont systemFontOfSize:14.0f];
    _result.numberOfLines = 1;
    [_container addSubview:_result];
    
    _containerBackgroundImageView = [UIImageView new];
    [_container insertSubview:_containerBackgroundImageView atIndex:0];
    
    [self setupAutoHeightWithBottomView:_container bottomMargin:0];
    
    // 设置containerBackgroundImageView填充父view
    _containerBackgroundImageView.sd_layout.spaceToSuperView(UIEdgeInsetsMake(0, 0, 0, 0));
    
}
- (void)setIndex:(NSIndexPath *)index{
    _index = index;
}
- (void)setModel:(ServiceNo *)model{
    _model = model;
    _department.text = model.department;
    _content.text = model.content;
    
    NSDate *date = [[NSDate alloc] initWithTimeIntervalSince1970:model.sentTime/1000];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *timeString = [formatter stringFromDate:date];
    _sentTime.text = timeString;
    
    _container.sd_layout
    .leftSpaceToView(self.contentView,10)
    .rightSpaceToView(self.contentView,10)
    .topSpaceToView(self.contentView,10);
    
    _containerBackgroundImageView.image = [[UIImage imageNamed:@"ServiceNoBkg"] stretchableImageWithLeftCapWidth:50 topCapHeight:30];
    
    _department.sd_resetLayout
    .leftSpaceToView(_container,20)
    .topSpaceToView(_container,10);
    [_department setSingleLineAutoResizeWithMaxWidth:120];
    
    _sentTime.sd_resetLayout
    .rightSpaceToView(_container,20)
    .topSpaceToView(_container,10);
    [_sentTime setSingleLineAutoResizeWithMaxWidth:140];
    
    _content.sd_resetLayout
    .leftSpaceToView(_container, 20)
    .rightSpaceToView(_container,20)
    .topSpaceToView(_department, 8)
    .autoHeightRatio(0); // 设置label纵向自适应
    
    // 设置label横向自适应
//    [_content setSingleLineAutoResizeWithMaxWidth:320];
    
    _spliteline.sd_resetLayout
    .leftSpaceToView(_container,17)
    .rightSpaceToView(_container,17)
    .topSpaceToView(_content,8)
    .heightIs(0.5).maxWidthIs(360);
    
    _agree.sd_resetLayout
    .topSpaceToView(_spliteline,8)
    .leftSpaceToView(_container,40)
    .heightIs(25).widthIs(42);
    
    _disagree.sd_resetLayout
    .topSpaceToView(_spliteline,8)
    .rightSpaceToView(_container,40)
    .heightIs(25).widthIs(42);
    
    _result.sd_resetLayout
    .topSpaceToView(_spliteline,8)
    .heightIs(21).centerXEqualToView(_container);
    [_result setSingleLineAutoResizeWithMaxWidth:64];
    if (model.status == 2) {
        _agree.hidden = NO;
        _disagree.hidden = NO;
        _result.hidden = YES;
    }else if(model.status == 1){
        _agree.hidden = YES;
        _disagree.hidden = YES;
        _result.hidden = NO;
        _result.text = @"已同意";
    }else if(model.status == 0){
        _agree.hidden = YES;
        _disagree.hidden = YES;
        _result.hidden = NO;
        _result.text = @"已拒绝";
    }else if(model.status == 3){
        _agree.hidden = YES;
        _disagree.hidden = YES;
        _result.hidden = YES;
    }else if(model.status == 4){
        //处理失败
        _agree.hidden = NO;
        _disagree.hidden = NO;
        _result.hidden = YES;
    }else if(model.status == 5){
        //已处理，请刷新
    }
    // container以label为rightView宽度自适应
//    [_container setupAutoWidthWithRightView:_label rightMargin:kLabelMargin];
    
    
    // container以label为bottomView高度自适应
    if(model.status == 3){
        [_container setupAutoHeightWithBottomView:_spliteline bottomMargin:20];
    }else{
        [_container setupAutoHeightWithBottomView:_agree	 bottomMargin:20];
    }
}
- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

- (void)dealServiceNo:(UIButton *)button{
    NSInteger status = button.tag;
    [_delegate dealService:_index status:status];
}
@end
