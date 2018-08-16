//
//  CustomerDupTableViewCell.m
//  sales
//
//  Created by user on 2017/3/22.
//  Copyright © 2017年 rayootech. All rights reserved.
//

#import "CustomerDupTableViewCell.h"
#import "UIColor+Util.h"
#import "GlobalDefines.h"
#import "NSStringUtils.h"
#import <SDAutoLayout.h>
@interface CustomerDupTableViewCell ()

@property (nonatomic, strong) UIView *container;
@property (nonatomic, strong) UIImageView *containerBackgroundImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *mobileLabel;
@property (nonatomic, strong) UILabel *emailLabel;
@property (nonatomic, strong) UILabel *addressLabel;

@end
@implementation CustomerDupTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupView];
    }
    return self;
}

- (void)setupView{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    _container = [UIView new];
    [self.contentView addSubview:_container];
    
    _nameLabel = [UILabel new];
    _nameLabel.font = [UIFont systemFontOfSize:14];
    _nameLabel.numberOfLines = 1;
    [_container addSubview:_nameLabel];
    
    _mobileLabel = [UILabel new];
    _mobileLabel.font = [UIFont systemFontOfSize:14];
    _mobileLabel.numberOfLines = 1;
    [_container addSubview:_mobileLabel];
    
    _emailLabel = [UILabel new];
    _emailLabel.font = [UIFont systemFontOfSize:14.0f];
    _emailLabel.numberOfLines = 0;
    [_container addSubview:_emailLabel];
    
    _addressLabel = [UILabel new];
    _addressLabel.font = [UIFont systemFontOfSize:14.0f];
    _addressLabel.numberOfLines = 0;
    [_container addSubview:_addressLabel];
    
    _containerBackgroundImageView = [UIImageView new];
    [_container insertSubview:_containerBackgroundImageView atIndex:0];
    
    [self setupAutoHeightWithBottomView:_container bottomMargin:0];
    
    // 设置containerBackgroundImageView填充父view
    _containerBackgroundImageView.sd_layout.spaceToSuperView(UIEdgeInsetsMake(0, 0, 0, 0));

    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(Customer *)model{
    
    _container.sd_layout
    .leftSpaceToView(self.contentView,10)
    .rightSpaceToView(self.contentView,10)
    .topSpaceToView(self.contentView,10);
    
    _containerBackgroundImageView.image = [[UIImage imageNamed:@"ServiceNoBkg"] stretchableImageWithLeftCapWidth:50 topCapHeight:30];
    
    _nameLabel.sd_resetLayout
    .leftSpaceToView(_container, 20)
    .rightSpaceToView(_container,20)
    .topSpaceToView(_container, 10)
    .autoHeightRatio(0); // 设置label纵向自适应
    
    _mobileLabel.sd_layout
    .leftSpaceToView(_container,20)
    .rightSpaceToView(_container,20)
    .topSpaceToView(_nameLabel,10)
    .autoHeightRatio(0);
    
    _emailLabel.sd_layout
    .leftSpaceToView(_container,20)
    .rightSpaceToView(_container,20)
    .topSpaceToView(_mobileLabel,10)
    .autoHeightRatio(0);
    
    _addressLabel.sd_layout
    .leftSpaceToView(_container,20)
    .rightSpaceToView(_container,20)
    .topSpaceToView(_emailLabel,10)
    .autoHeightRatio(0);

    [_container setupAutoHeightWithBottomView:_addressLabel	 bottomMargin:20];
    
    if ([NSStringUtils isEmpty:model.name]) {
        _nameLabel.text = @"姓名：";
    }else{
        _nameLabel.text = [@"姓名：" stringByAppendingString:model.name];
    }
    
    if ([NSStringUtils isEmpty:model.mobile]) {
        _mobileLabel.text = @"手机：";
    }else{
        _mobileLabel.text = [@"手机：" stringByAppendingString:model.mobile];
    }
    
    if ([NSStringUtils isEmpty:model.mail]) {
        _emailLabel.text = @"邮件：";
    }else{
        _emailLabel.text = [@"邮件：" stringByAppendingString:model.mail];
    }
    
    if ([NSStringUtils isEmpty:model.address]) {
        _addressLabel.text = @"地址：";
    }else{
        _addressLabel.text = [@"地址：" stringByAppendingString:model.address];
    }
    
}
@end
