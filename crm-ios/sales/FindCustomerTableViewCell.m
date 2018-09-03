//
//  FindCustomerTableViewCell.m
//  sales
//
//  Created by user on 2017/3/6.
//  Copyright © 2017年 rayootech. All rights reserved.
//

#import "FindCustomerTableViewCell.h"

@interface FindCustomerTableViewCell ()

@property (nonatomic, strong) UIImageView *iconImgView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *mobileLabel;
@property (nonatomic, strong) UILabel *ownerLabel;

@end

@implementation FindCustomerTableViewCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        // 这行代是为了解决tableview开启了字母序列索引之后cell会向左缩进一段距离的问题
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        [self setupView];
    }
    return self;
}

- (void)setupView{
    _iconImgView = [UIImageView new];
    _iconImgView.layer.cornerRadius = 20;
    _iconImgView.layer.masksToBounds = true;
    [self.contentView addSubview:_iconImgView];
    [_iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.width.height.mas_equalTo(40);
        make.centerY.equalTo(self.contentView);
    }];
    
    _nameLabel = [UILabel new];
    _nameLabel.textColor = [UIColor colorWithHex:0x333333];
    _nameLabel.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:_nameLabel];
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImgView.mas_right).offset(15);
        make.centerY.equalTo(self.contentView).offset(-10);
    }];
    
    _mobileLabel = [UILabel new];
    _mobileLabel.textColor = [UIColor grayColor];
    _mobileLabel.font = [UIFont systemFontOfSize:13];
    [self.contentView addSubview:_mobileLabel];
    [_mobileLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImgView.mas_right).offset(15);
        make.centerY.equalTo(self.contentView).offset(10);
    }];
    
    _ownerLabel = [UILabel new];
    _ownerLabel.textColor = [UIColor grayColor];
    _ownerLabel.font = [UIFont systemFontOfSize:13];
    [self.contentView addSubview:_ownerLabel];
    [_ownerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView);
        make.centerY.equalTo(self.contentView);
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)setModel:(Customer *)model {
    _model = model;
    [self.iconImgView loadPortrait:model.avatar];
    self.mobileLabel.text = [NSString stringWithFormat:@"手机号码：%@",model.mobile];
    self.nameLabel.text = [NSString stringWithFormat:@"%@",model.name];
    self.ownerLabel.text = model.uname;
}

@end
