//
//  CustomerTableViewCell.m
//  sales
//
//  Created by user on 2017/2/15.
//  Copyright © 2017年 rayootech. All rights reserved.
//

#import "CustomerTableViewCell.h"
@implementation CustomerTableViewCell

{
    UIImageView     *_iconImageView;
    UILabel         *_nameLabel;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
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

- (void)setupView {
    
    _iconImageView = [UIImageView new];
    _iconImageView.layer.cornerRadius = 18;
    _iconImageView.layer.masksToBounds = true;
    [self.contentView addSubview:_iconImageView];
    
    CGFloat margin = 20;

    _iconImageView.sd_layout
    .leftSpaceToView(self.contentView, margin)
    .widthIs(36)
    .heightEqualToWidth()
    .centerYEqualToView(self.contentView);
    
    _nameLabel = [UILabel new];
    _nameLabel.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:_nameLabel];
    
    _nameLabel.sd_layout
    .leftSpaceToView(_iconImageView, margin)
    .centerYEqualToView(_iconImageView)
    .heightIs(30).widthIs(200);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)setModel:(Customer *)model{
    _model = model;
    _nameLabel.text = [NSString stringWithFormat:@"%@",model.name];
    NSString *avatar = model.avatar;
    if (avatar == nil) {
        avatar = @"";
    }
    [_iconImageView loadPortrait:avatar];
}

+ (CGFloat)fixedHeight
{
    return 70;
}

@end
