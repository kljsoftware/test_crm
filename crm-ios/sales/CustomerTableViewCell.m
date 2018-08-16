//
//  CustomerTableViewCell.m
//  sales
//
//  Created by user on 2017/2/15.
//  Copyright © 2017年 rayootech. All rights reserved.
//

#import "CustomerTableViewCell.h"
#import "UIImageView+Util.h"
#import "SalesApi.h"
#import "GlobalDefines.h"
#import <SDAutoLayout.h>
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

- (void)setupView{
    
    _nameLabel = [UILabel new];
    _nameLabel.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:_nameLabel];
    
    CGFloat margin = 8;
    
    _nameLabel.sd_layout
    .leftSpaceToView(self.contentView, margin)
    .centerYEqualToView(self.contentView)
    .heightIs(30);
    [_nameLabel setSingleLineAutoResizeWithMaxWidth:200];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)setModel:(Customer *)model{
    _model = model;
    _nameLabel.text = [NSString stringWithFormat:@"%@",model.name];
    
}

+ (CGFloat)fixedHeight
{
    return 70;
}

@end
