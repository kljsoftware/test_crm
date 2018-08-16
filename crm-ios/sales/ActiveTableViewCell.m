//
//  ActiveTableViewCell.m
//  sales
//
//  Created by user on 2017/2/14.
//  Copyright © 2017年 rayootech. All rights reserved.
//

#import "ActiveTableViewCell.h"
#import "Utils.h"
#import <SDAutoLayout.h>
@implementation ActiveTableViewCell
{
    UILabel                  *_titleLabel;
    UILabel                  *_cromLabel;
    UILabel                  *_timeLabel;
    UILabel                  *_priceLabel;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self setup];
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)setup{
    _titleLabel = [UILabel new];
    _titleLabel.font = [UIFont systemFontOfSize:13];
    //    _nameLable.textColor = [UIColor colorWithRed:(54 / 255.0) green:(71 / 255.0) blue:(121 / 255.0) alpha:0.9];
    
    _cromLabel = [UILabel new];
    _cromLabel.font = [UIFont systemFontOfSize:13];
//    _cromLabel.textColor = [UIColor darkGrayColor];
    _cromLabel.numberOfLines = 1;
    _cromLabel.height = 21;
    
    _timeLabel = [UILabel new];
    _timeLabel.font = [UIFont systemFontOfSize:13];
    
    _priceLabel = [UILabel new];
    _priceLabel.font = [UIFont systemFontOfSize:13];
    
    NSArray *views = @[_titleLabel, _cromLabel, _timeLabel,_priceLabel];
    
    [self.contentView sd_addSubviews:views];
    
    UIView *contentView = self.contentView;
    CGFloat margin = 10;
    
    _titleLabel.sd_layout
    .leftSpaceToView(contentView, margin)
    .topSpaceToView(contentView,margin)
    .heightIs(18);
    [_titleLabel setSingleLineAutoResizeWithMaxWidth:300];
    
    _cromLabel.sd_layout
    .leftEqualToView(_titleLabel)
    .topSpaceToView(_titleLabel, margin)
    .rightSpaceToView(contentView, margin)
    .autoHeightRatio(0);
    
    _timeLabel.sd_layout
    .leftEqualToView(_titleLabel)
    .topSpaceToView(_cromLabel, margin)
    .heightIs(15);
    [_timeLabel setSingleLineAutoResizeWithMaxWidth:200];
    
    _priceLabel.sd_layout
    .rightSpaceToView(contentView,margin)
    .topSpaceToView(_cromLabel,margin)
    .topEqualToView(_timeLabel)
    .heightIs(15);
    [_priceLabel setSingleLineAutoResizeWithMaxWidth:100];
    
    
    
}

- (void)setModel:(Active *)model{
    _model = model;
    _titleLabel.text = [@"活动主题:" stringByAppendingString:model.title];
    
    _cromLabel.text = [@"主办单位:" stringByAppendingString:model.crom];
    
    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSDate* date = [formatter dateFromString:model.activetime];
    _timeLabel.text = [@"活动时间:" stringByAppendingString:[formatter stringFromDate:date]];
    _priceLabel.text = [@"票价:" stringByAppendingString:[NSString stringWithFormat:@"%ld",model.price]];
}
- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
