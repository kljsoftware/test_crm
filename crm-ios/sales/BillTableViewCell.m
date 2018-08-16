//
//  BillTableViewCell.m
//  sales
//
//  Created by user on 2017/3/16.
//  Copyright © 2017年 rayootech. All rights reserved.
//

#import "BillTableViewCell.h"
#import <SDAutoLayout.h>

@interface BillTableViewCell ()

@property (nonatomic, strong) UIView *container;
@property (nonatomic, strong) UIImageView *containerBackgroundImageView;
@property (nonatomic, strong) UILabel *bill;

@end
@implementation BillTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupView];
    }
    return self;
}

- (void)setupView{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    //    self.contentView.backgroundColor = [UIColor clearColor];
    _container = [UIView new];
    [self.contentView addSubview:_container];
    
    _bill = [UILabel new];
    _bill.font = [UIFont systemFontOfSize:14.0f];
    _bill.numberOfLines = 0;
    [_container addSubview:_bill];
    
    _containerBackgroundImageView = [UIImageView new];
    [_container insertSubview:_containerBackgroundImageView atIndex:0];
    
    [self setupAutoHeightWithBottomView:_container bottomMargin:0];
    
    // 设置containerBackgroundImageView填充父view
    _containerBackgroundImageView.sd_layout.spaceToSuperView(UIEdgeInsetsMake(0, 0, 0, 0));
    
}

- (void)setDetail:(NSString *)detail{
    _detail = detail;
    _bill.text = detail;
    
    _container.sd_layout
    .leftSpaceToView(self.contentView,10)
    .rightSpaceToView(self.contentView,10)
    .topSpaceToView(self.contentView,10);
    
    _containerBackgroundImageView.image = [[UIImage imageNamed:@"ServiceNoBkg"] stretchableImageWithLeftCapWidth:50 topCapHeight:30];
    
    _bill.sd_resetLayout
    .leftSpaceToView(_container, 20)
    .rightSpaceToView(_container,20)
    .topSpaceToView(_container, 20)
    .autoHeightRatio(0); // 设置label纵向自适应
    
    // 设置label横向自适应
//    [_bill setSingleLineAutoResizeWithMaxWidth:360];
    NSMutableAttributedString *mat = _bill.attributedText.mutableCopy;
    [mat setAttributes:@{NSForegroundColorAttributeName:[UIColor blueColor]} range:[_bill.text rangeOfString:@"支出明细"]];
    [mat setAttributes:@{NSForegroundColorAttributeName:[UIColor blueColor]} range:[_bill.text rangeOfString:@"成本费用类别"]];
    [mat setAttributes:@{NSForegroundColorAttributeName:[UIColor blueColor]} range:[_bill.text rangeOfString:@"支付对象"]];
    [mat setAttributes:@{NSForegroundColorAttributeName:[UIColor blueColor]} range:[_bill.text rangeOfString:@"消费税"]];
    [mat setAttributes:@{NSForegroundColorAttributeName:[UIColor blueColor]} range:[_bill.text rangeOfString:@"支出原币小计"]];
    [mat setAttributes:@{NSForegroundColorAttributeName:[UIColor blueColor]} range:[_bill.text rangeOfString:@"支出本币小计"]];
    [mat setAttributes:@{NSForegroundColorAttributeName:[UIColor blueColor]} range:[_bill.text rangeOfString:@"发生日期"]];
    [mat setAttributes:@{NSForegroundColorAttributeName:[UIColor blueColor]} range:[_bill.text rangeOfString:@"发生摘要"]];
    [mat setAttributes:@{NSForegroundColorAttributeName:[UIColor blueColor]} range:[_bill.text rangeOfString:@"业务内容详述"]];
    _bill.attributedText = mat;
    
    [_container setupAutoHeightWithBottomView:_bill	 bottomMargin:20];
}
@end
