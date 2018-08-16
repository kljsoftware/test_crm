//
//  FindCustomerTableViewCell.m
//  sales
//
//  Created by user on 2017/3/6.
//  Copyright © 2017年 rayootech. All rights reserved.
//

#import "FindCustomerTableViewCell.h"
#import <SDAutoLayout.h>
@implementation FindCustomerTableViewCell
{
    UIImageView     *_iconImageView;
    UILabel         *_nameLabel;
    UILabel         *_ownerLabel;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        // 这行代是为了解决tableview开启了字母序列索引之后cell会向左缩进一段距离的问题
        self.contentView.sd_layout.spaceToSuperView(UIEdgeInsetsMake(0, 0, 0, 0));
        
        [self setupView];
    }
    return self;
}

- (void)setupView{
    _iconImageView = [UIImageView new];
    
    _nameLabel = [UILabel new];
    _nameLabel.textColor = [UIColor blackColor];
    _nameLabel.font = [UIFont systemFontOfSize:15];
    [self.contentView addSubview:_nameLabel];
    
    _ownerLabel = [UILabel new];
    _ownerLabel.textColor = [UIColor blackColor];
    _ownerLabel.font = [UIFont systemFontOfSize:13];
    [self.contentView addSubview:_ownerLabel];
    
    CGFloat margin = 8;
    
    _nameLabel.sd_layout
    .leftSpaceToView(self.contentView, margin)
    .centerYEqualToView(self.contentView)
    //    .rightSpaceToView(self.contentView, margin)
    .heightIs(30);
    [_nameLabel setSingleLineAutoResizeWithMaxWidth:200];
    
    _ownerLabel.sd_layout
    .rightSpaceToView(self.contentView,margin)
    .centerYEqualToView(self.contentView).heightIs(30);
    
    [_ownerLabel setSingleLineAutoResizeWithMaxWidth:100];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)setModel:(Customer *)model{
    _model = model;
    _nameLabel.text = [NSString stringWithFormat:@"%@",model.name];
    _ownerLabel.text = model.uname;
}
+ (CGFloat)fixedHeight{
    return 70;
}
@end
