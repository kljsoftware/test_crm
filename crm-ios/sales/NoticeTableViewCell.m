//
//  NoticeTableViewCell.m
//  sales
//
//  Created by user on 2017/1/17.
//  Copyright © 2017年 rayootech. All rights reserved.
//

#import "NoticeTableViewCell.h"

@implementation NoticeTableViewCell
{
    UILabel                  *_nameLable;
    UILabel                  *_contentLabel;
    UILabel                  *_timeLabel;
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
    _nameLable = [UILabel new];
    _nameLable.font = [UIFont systemFontOfSize:15];
//    _nameLable.textColor = [UIColor colorWithRed:(54 / 255.0) green:(71 / 255.0) blue:(121 / 255.0) alpha:0.9];
    
    _timeLabel = [UILabel new];
    _timeLabel.font = [UIFont systemFontOfSize:13];
    
    _contentLabel = [UILabel new];
    _contentLabel.font = [UIFont systemFontOfSize:13];
    _contentLabel.textColor = [UIColor darkGrayColor];
    _contentLabel.numberOfLines = 1;
    _contentLabel.height = 21;
    
    NSArray *views = @[_nameLable, _contentLabel, _timeLabel];
    
    [self.contentView sd_addSubviews:views];
    
    UIView *contentView = self.contentView;
    CGFloat margin = 10;
    
    _nameLable.sd_layout
    .leftSpaceToView(contentView, margin)
    .topSpaceToView(contentView,margin)
    .heightIs(18);
    [_nameLable setSingleLineAutoResizeWithMaxWidth:200];
    
    _timeLabel.sd_layout
    .rightSpaceToView(contentView,margin)
    .topSpaceToView(contentView, margin)
    .heightIs(15);
    [_timeLabel setSingleLineAutoResizeWithMaxWidth:200];
    
    _contentLabel.sd_layout
    .leftEqualToView(_nameLable)
    .topSpaceToView(_nameLable, margin)
    .rightSpaceToView(contentView, margin)
    .heightIs(21);
    
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(Notice *)model{
    _model = model;
    _nameLable.text = model.title;
    _contentLabel.text = model.content;
    
    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSDate* date = [formatter dateFromString:model.createtime];
    [_timeLabel setAttributedText:[Utils attributedTimeString:date]];

}
@end
