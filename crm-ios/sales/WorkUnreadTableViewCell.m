//
//  WorkUnreadTableViewCell.m
//  sales
//
//  Created by user on 2017/4/14.
//  Copyright © 2017年 rayootech. All rights reserved.
//

#import "WorkUnreadTableViewCell.h"
@implementation WorkUnreadTableViewCell

{
    UIImageView              *_iconView;
    UILabel                  *_nameLable;
    UILabel                  *_countLabel;
    UILabel                  *_contentLabel;
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
    
    _iconView = [UIImageView new];
    _iconView.layer.cornerRadius = 20;
    _iconView.layer.masksToBounds = true;
    
    _nameLable = [UILabel new];
    _nameLable.font = [UIFont systemFontOfSize:14];
    _nameLable.textColor = [UIColor colorWithRed:(54 / 255.0) green:(71 / 255.0) blue:(121 / 255.0) alpha:0.9];
    
    _contentLabel = [UILabel new];
    _contentLabel.font = [UIFont systemFontOfSize:13];
    _contentLabel.numberOfLines = 3;
    _contentLabel.lineBreakMode = NSLineBreakByWordWrapping | NSLineBreakByTruncatingTail;
    
    _countLabel = [UILabel new];
    _countLabel.font = [UIFont systemFontOfSize:12];
    NSArray *views = @[_iconView, _nameLable, _contentLabel,_countLabel];
    
    [self.contentView sd_addSubviews:views];
    
    UIView *contentView = self.contentView;
    CGFloat margin = 12;
    
    _iconView.sd_layout
    .leftSpaceToView(contentView, margin)
    .topSpaceToView(contentView, margin + 5)
    .widthIs(40)
    .heightIs(40);
    
    _nameLable.sd_layout
    .leftSpaceToView(_iconView, margin)
    .topEqualToView(_iconView)
    .heightIs(18);
    [_nameLable setSingleLineAutoResizeWithMaxWidth:200];
    
    _countLabel.sd_layout
    .topSpaceToView(_nameLable,8)
    .leftEqualToView(_nameLable).heightIs(20).widthIs(100);
    
    _contentLabel.sd_layout
    .rightSpaceToView(contentView, margin)
    .topSpaceToView(contentView,margin).centerYEqualToView(contentView)
    .widthIs(98).heightIs(60);
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)setModel:(Work *)model{
    NSString *url = @"url";
    if (model.avatar != nil) {
        url = model.avatar;
    }
    _iconView.image = [UIImage imageNamed:url];
    [_iconView loadPortrait:url];
    _nameLable.text = model.user;
    _countLabel.text = [[NSString stringWithFormat:@"%ld",model.counts] stringByAppendingString:@"条未读消息"];
    _contentLabel.text = model.content;
}

@end
