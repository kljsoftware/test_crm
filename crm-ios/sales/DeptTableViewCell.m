//
//  DeptTableViewCell.m
//  sales
//
//  Created by user on 2017/4/17.
//  Copyright © 2017年 rayootech. All rights reserved.
//

#import "DeptTableViewCell.h"
#import "Config.h"
#import "OrgUserInfo.h"
#import <SDAutoLayout.h>
@implementation DeptTableViewCell
{
    UILabel         *_nameLabel;
    UILabel         *_flagLabel;
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
    
    _nameLabel = [UILabel new];
    _nameLabel.font = [UIFont systemFontOfSize:15];
    [self.contentView addSubview:_nameLabel];
    
    _nameLabel.sd_layout
    .leftSpaceToView(self.contentView, 20)
    .centerYEqualToView(self.contentView)
    .heightIs(30).widthIs(240);
    
    _flagLabel = [UILabel new];
    _flagLabel.font = [UIFont systemFontOfSize:13];
    [self.contentView addSubview:_flagLabel];
    _flagLabel.text = @"所在";
    
    _flagLabel.sd_layout
    .rightSpaceToView(self.contentView,20)
    .centerYEqualToView(self.contentView)
    .heightIs(30).widthIs(30);
}

- (void)setModel:(Dept *)model{
    _model = model;
    _nameLabel.text = model.departname;
}

- (void)setType:(NSInteger)type{
    _type = type;
    OrgUserInfo *info = [Config getOrgUser];
    NSLog(@"%ld --- %ld --- %ld",info.deptparentid,info.deptid,_model.id);
    if(type == 1){
        if (info.deptparentid == _model.id) {
            _flagLabel.hidden = NO;
        }else{
            _flagLabel.hidden = YES;
        }
    }else if(type == 2){
        if (info.deptid == _model.id) {
            _flagLabel.hidden = NO;
        }else{
            _flagLabel.hidden = YES;
        }
    }
}
+ (CGFloat)fixedHeight
{
    return 70;
}
@end
