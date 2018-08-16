//
//  OrganizationTableViewCell.m
//  sales
//
//  Created by user on 2016/12/30.
//  Copyright © 2016年 rayootech. All rights reserved.
//

#import "OrganizationTableViewCell.h"
#import "UIImageView+Util.h"
#import <SDAutoLayout.h>
@implementation OrganizationTableViewCell
{
    UIImageView     *_iconImageView;
    UILabel         *_nameLabel;
    UILabel         *_createrLabel;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        // 这行代是为了解决tableview开启了字母序列索引之后cell会向左缩进一段距离的问题
//        self.contentView.sd_layout.spaceToSuperView(UIEdgeInsetsMake(0, 0, 0, 0));
        
        [self setupView];
    }
    return self;
}

- (void)setupView{
    _iconImageView = [UIImageView new];
    [self.contentView addSubview:_iconImageView];
    
    _nameLabel = [UILabel new];
    _nameLabel.textColor = [UIColor blackColor];
    _nameLabel.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:_nameLabel];
    
    _createrLabel = [UILabel new];
    _createrLabel.textColor = [UIColor darkGrayColor];
    _createrLabel.font = [UIFont systemFontOfSize:13];
    
    [self.contentView addSubview:_createrLabel];
    
    CGFloat margin = 8;
    
    
    _iconImageView.sd_layout
    .leftSpaceToView(self.contentView, margin)
    .widthIs(35)
    .heightEqualToWidth()
    .centerYEqualToView(self.contentView);
    
    _nameLabel.sd_layout
    .leftSpaceToView(_iconImageView, margin)
    .centerYEqualToView(_iconImageView)
    //    .rightSpaceToView(self.contentView, margin)
    .heightIs(30).widthIs(120).maxWidthIs(120)
    ;
    
    _createrLabel.sd_layout
    .rightSpaceToView(self.contentView, margin)
//    .maxWidthIs(100)
    .heightIs(30).widthIs(100).maxWidthIs(100)
    .centerYEqualToView(_iconImageView);
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setModel:(Organizations *)model{
    _model = model;
    _nameLabel.text = [NSString stringWithFormat:@"%@",model.name];
    _createrLabel.text = [NSString stringWithFormat:@"%@",model.creater];
    NSString *logo = model.logo;
    if (logo == nil) {
        logo = @"";
    }
    [_iconImageView loadPortrait:logo];
    
}

+ (CGFloat)fixedHeight
{
    return 70;
}
@end
