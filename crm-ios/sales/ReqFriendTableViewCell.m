//
//  ReqFriendTableViewCell.m
//  sales
//
//  Created by user on 2017/3/9.
//  Copyright © 2017年 rayootech. All rights reserved.
//

#import "ReqFriendTableViewCell.h"
#import "UIImageView+Util.h"
#import "SalesApi.h"
#import "GlobalDefines.h"
#import "Contact.h"
#import <SDAutoLayout.h>
@implementation ReqFriendTableViewCell
{
    UIImageView     *_iconImageView;
    UILabel         *_nameLabel;
    UIButton        *_chatButton;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
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
    
    _chatButton = [UIButton new];
    [_chatButton setTitle:@"同意" forState:UIControlStateNormal];
    _chatButton.backgroundColor = [UIColor clearColor];
    [_chatButton setTitleColor:TimeLineCellHighlightedColor forState:UIControlStateNormal];
    [_chatButton addTarget:self action:@selector(agreeButton) forControlEvents:UIControlEventTouchUpInside];
    _chatButton.titleLabel.font = [UIFont systemFontOfSize:14];
    
    [self.contentView addSubview:_chatButton];
    
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
    .heightIs(30).widthIs(200);
    
    _chatButton.sd_layout
    .rightSpaceToView(self.contentView, margin)
    .widthIs(80)
    .heightIs(30)
    .centerYEqualToView(self.contentView);
}


- (void)setModel:(Contact *)model{
    _model = model;
    _nameLabel.text = [NSString stringWithFormat:@"%@",model.name];
    NSString *avatar = model.avatar;
    if (avatar == nil) {
        avatar = @"";
    }
    [_iconImageView loadPortrait:avatar];
    if (model.recevied == 0) {
        [_chatButton setTitle:@"同意" forState:UIControlStateNormal];
        [_chatButton setEnabled:YES];
    }else{
        [_chatButton setTitle:@"已接受" forState:UIControlStateNormal];
        [_chatButton setEnabled:NO];
    }
}
- (void)setIndex:(NSIndexPath *)index{
    _index = index;
}
- (void)agreeButton{
    [_delegate agreeDidClick:_model index:_index];
}
+ (CGFloat)fixedHeight
{
    return 50;
}

@end
