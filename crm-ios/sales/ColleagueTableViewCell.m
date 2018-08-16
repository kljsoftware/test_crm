//
//  ColleagueTableViewCell.m
//  sales
//
//  Created by user on 2017/1/10.
//  Copyright © 2017年 rayootech. All rights reserved.
//

#import "ColleagueTableViewCell.h"
#import "GlobalDefines.h"
#import "UIImageView+Util.h"
#import <SDAutoLayout.h>
@implementation ColleagueTableViewCell
{
    UIImageView     *_iconImageView;
    UILabel         *_nameLabel;
}
- (void)awakeFromNib {
    [super awakeFromNib];
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
    
    _nameLabel = [UILabel new];
    _nameLabel.textColor = [UIColor darkGrayColor];
    _nameLabel.font = [UIFont systemFontOfSize:15];
    [self.contentView addSubview:_nameLabel];
    
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
    .heightIs(30);
    
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
