//
//  SelectColleauesTableViewCell.m
//  sales
//
//  Created by user on 2017/3/2.
//  Copyright © 2017年 rayootech. All rights reserved.
//

#import "SelectColleauesTableViewCell.h"
@implementation SelectColleauesTableViewCell
{
    UIImageView     *_iconImageView;
    UILabel         *_nameLabel;
    UIImageView     *_selectedImage;
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
    [self.contentView addSubview:_iconImageView];
    _iconImageView.layer.cornerRadius = 20;
    _iconImageView.layer.masksToBounds = true;
    _nameLabel = [UILabel new];
    _nameLabel.textColor = [UIColor colorWithHex:0x333333];
    _nameLabel.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:_nameLabel];
    
    CGFloat margin = 20;
    
    
    _iconImageView.sd_layout
    .leftSpaceToView(self.contentView, margin)
    .widthIs(40)
    .heightEqualToWidth()
    .centerYEqualToView(self.contentView);
    
    _nameLabel.sd_layout
    .leftSpaceToView(_iconImageView, margin)
    .centerYEqualToView(_iconImageView)
    //    .rightSpaceToView(self.contentView, margin)
    .heightIs(30);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)setModel:(OrgUserInfo *)model{
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
