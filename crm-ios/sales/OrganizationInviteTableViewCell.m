//
//  OrganizationInviteTableViewCell.m
//  sales
//
//  Created by user on 2017/3/17.
//  Copyright © 2017年 rayootech. All rights reserved.
//

#import "OrganizationInviteTableViewCell.h"
#import "GlobalDefines.h"
#import <SDAutoLayout.h>
@implementation OrganizationInviteTableViewCell
{
    UILabel         *_orgnameLabel;
    UILabel         *_inviterLabel;
    UIButton        *_agreeButton;
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
    _orgnameLabel = [UILabel new];
    [self.contentView addSubview:_orgnameLabel];
    
    _inviterLabel = [UILabel new];
    _inviterLabel.textColor = [UIColor blackColor];
    _inviterLabel.font = [UIFont systemFontOfSize:15];
    [self.contentView addSubview:_inviterLabel];
    
    _agreeButton = [UIButton new];
    [_agreeButton setTitle:@"同意" forState:UIControlStateNormal];
    _agreeButton.backgroundColor = [UIColor clearColor];
    [_agreeButton setTitleColor:TimeLineCellHighlightedColor forState:UIControlStateNormal];
    [_agreeButton addTarget:self action:@selector(agreeButton) forControlEvents:UIControlEventTouchUpInside];
    _agreeButton.titleLabel.font = [UIFont systemFontOfSize:14];
    
    [self.contentView addSubview:_agreeButton];
    
    CGFloat margin = 8;
    
    _orgnameLabel.sd_layout
    .leftSpaceToView(self.contentView, margin)
    .widthIs(160)
    .heightIs(35)
    .centerYEqualToView(self.contentView);
    
    _inviterLabel.sd_layout
    .leftSpaceToView(_orgnameLabel, margin)
    .centerYEqualToView(_orgnameLabel)
    //    .rightSpaceToView(self.contentView, margin)
    .heightIs(30).widthIs(100).maxWidthIs(100)
    ;
    
    _agreeButton.sd_layout
    .rightSpaceToView(self.contentView, margin)
    //    .maxWidthIs(100)
    .heightIs(30).widthIs(42).maxWidthIs(42)
    .centerYEqualToView(_orgnameLabel);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(OrgInvite *)model{
    _model = model;
    _orgnameLabel.text = model.orgname;
    _inviterLabel.text = model.inviter;

    if ([model.recevied isEqualToString:@"0"]) {
        [_agreeButton setTitle:@"同意" forState:UIControlStateNormal];
        [_agreeButton setEnabled:YES];
    }else{
        [_agreeButton setTitle:@"已接受" forState:UIControlStateNormal];
        [_agreeButton setEnabled:NO];
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
