//
//  WorkTableViewCell.m
//  sales
//
//  Created by user on 2017/4/10.
//  Copyright © 2017年 rayootech. All rights reserved.
//

#import "WorkTableViewCell.h"
#import "PhotoContainerView.h"
#import "CircleCellCommentView.h"

const CGFloat contentLabelFontSize3 = 15;
CGFloat maxContentLabelHeight3 = 0; // 根据具体font而定

@implementation WorkTableViewCell
{
    UIImageView              *_iconView;
    UILabel                  *_nameLable;
    UILabel                  *_contentLabel;
    UILabel                  *_timeLabel;
    UILabel                  *_addressLabel;
    UILabel                  *_worktypeLabel;
    UILabel                  *_typeLabel;   //2下属 3参与 1我的
    UIButton                 *_colleagueButton;
    MLLinkLabel              *_customerLabel;
    UIButton                 *_moreButton;
    UIButton                 *_operationButton;
    UIButton                 *_supportButton;     //点赞图片
    UIButton                 *_commentButton;         //评论图片
    PhotoContainerView       *_picContainerView;
    CircleCellCommentView    *_commentView;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self setup];
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)setup{
    _iconView = [UIImageView new];
    
    _nameLable = [UILabel new];
    _nameLable.font = [UIFont systemFontOfSize:14];
    _nameLable.textColor = [UIColor colorWithRed:(54 / 255.0) green:(71 / 255.0) blue:(121 / 255.0) alpha:0.9];
    
    _contentLabel = [UILabel new];
    _contentLabel.font = [UIFont systemFontOfSize:contentLabelFontSize3];
    _contentLabel.numberOfLines = 0;
    if (maxContentLabelHeight3 == 0) {
        maxContentLabelHeight3 = _contentLabel.font.lineHeight * 3;
    }
    
    _addressLabel = [UILabel new];
    _addressLabel.font = [UIFont systemFontOfSize:12];
    
    _typeLabel = [UILabel new];
    _typeLabel.font = [UIFont systemFontOfSize:12];
    _typeLabel.textAlignment = NSTextAlignmentRight;
    _typeLabel.textColor = [UIColor colorWithRed:(54 / 255.0) green:(71 / 255.0) blue:(121 / 255.0) alpha:0.9];
    
    _worktypeLabel = [UILabel new];
    _worktypeLabel.font = [UIFont systemFontOfSize:12];
    _worktypeLabel.textAlignment = NSTextAlignmentRight;
    
    _moreButton = [UIButton new];
    [_moreButton setTitle:@"全文" forState:UIControlStateNormal];
    [_moreButton setTitleColor:TimeLineCellHighlightedColor forState:UIControlStateNormal];
    [_moreButton addTarget:self action:@selector(moreButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    _moreButton.titleLabel.font = [UIFont systemFontOfSize:14];
    
    _picContainerView = [PhotoContainerView new];
    
    _commentView = [CircleCellCommentView new];
    
    _timeLabel = [UILabel new];
    _timeLabel.font = [UIFont systemFontOfSize:12];
    
    _colleagueButton = [UIButton new];
    [_colleagueButton setImage:[UIImage imageNamed:@"eye"] forState:UIControlStateNormal];
    [_colleagueButton addTarget:self action:@selector(colleagueButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    
    _customerLabel = [MLLinkLabel new];
    _customerLabel.font = [UIFont systemFontOfSize:12];
    
    _supportButton = [UIButton new];
    [_supportButton setImage:[UIImage imageNamed:@"support_nor"] forState:UIControlStateNormal];
    [_supportButton addTarget:self action:@selector(supportClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_supportButton setImage:[UIImage imageNamed:@"support_cover"] forState:UIControlStateSelected];
    
    _commentButton = [UIButton new];
    [_commentButton setImage:[UIImage imageNamed:@"comment_nor"] forState:UIControlStateNormal];
    
    NSArray *views = @[_iconView, _nameLable, _contentLabel, _moreButton, _picContainerView, _timeLabel,_supportButton,_commentButton, _commentView,_addressLabel,_typeLabel,_worktypeLabel,_colleagueButton,_customerLabel];
    
    [self.contentView sd_addSubviews:views];
    
    UIView *contentView = self.contentView;
    CGFloat margin = 10;
    
    _iconView.sd_layout
    .leftSpaceToView(contentView, margin)
    .topSpaceToView(contentView, margin + 5)
    .widthIs(40)
    .heightIs(40);
    
    _nameLable.sd_layout
    .leftSpaceToView(_iconView, margin)
    .topEqualToView(_iconView)
    .heightIs(18);
    [_nameLable setSingleLineAutoResizeWithMaxWidth:200];
    
    _contentLabel.sd_layout
    .leftEqualToView(_nameLable)
    .topSpaceToView(_nameLable, margin)
    .rightSpaceToView(contentView, margin)
    .autoHeightRatio(0);
    
    // morebutton的高度在setmodel里面设置
    _moreButton.sd_layout
    .leftEqualToView(_contentLabel)
    .topSpaceToView(_contentLabel, 0)
    .widthIs(30);
    
    
    _picContainerView.sd_layout
    .leftEqualToView(_contentLabel); // 已经在内部实现宽度和高度自适应所以不需要再设置宽度高度，top值是具体有无图片在setModel方法中设置
    
    _addressLabel.sd_layout
    .leftEqualToView(_contentLabel)
    .topSpaceToView(_picContainerView,margin)
    .heightIs(15);
    [_addressLabel setSingleLineAutoResizeWithMaxWidth:200];
    
    _typeLabel.sd_layout
    .rightSpaceToView(contentView,margin+5)
    .centerYEqualToView(_addressLabel).heightIs(20).widthIs(80);
    
    _timeLabel.sd_layout
    .leftEqualToView(_contentLabel)
    .topSpaceToView(_addressLabel, margin)
    .heightIs(15);
    [_timeLabel setSingleLineAutoResizeWithMaxWidth:200];
    
    _colleagueButton.sd_layout
    .leftSpaceToView(_timeLabel,margin + 5)
    .centerYEqualToView(_timeLabel).widthIs(15).heightEqualToWidth();
    
    _worktypeLabel.sd_layout
    .rightSpaceToView(contentView,margin+5)
    .centerYEqualToView(_timeLabel).heightIs(20).widthIs(80);
    
    _customerLabel.sd_layout
    .leftSpaceToView(_colleagueButton,margin + 5)
    .centerYEqualToView(_timeLabel).heightIs(15).widthIs(15);
    [_customerLabel setSingleLineAutoResizeWithMaxWidth:100];
    
    _commentButton.sd_layout
    .rightSpaceToView(contentView,margin+5)
    .topSpaceToView(_worktypeLabel,margin).heightIs(15).widthIs(15);
    
    _supportButton.sd_layout
    .rightSpaceToView(_commentButton,margin)
    .topEqualToView(_commentButton).heightIs(15).widthIs(15);
    
    _commentView.sd_layout
    .leftEqualToView(_contentLabel)
    .rightSpaceToView(self.contentView, margin)
    .topSpaceToView(_commentButton, margin); // 已经在内部实现高度自适应所以不需要再设置高度
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(Work *)model{
    _model = model;
    
    [_commentView setupWithLikeItemsArray:nil commentItemsArray:model.workCommentsList];
    _iconView.image = [UIImage imageNamed:model.avatar];
    [_iconView loadPortrait:model.avatar];
    _nameLable.text = model.user;
    _contentLabel.text = model.content;
    if([model.picurl isEqualToString:@""]){
        _picContainerView.picPathStringsArray = [NSArray new];
    }else{
        _picContainerView.picPathStringsArray = [model.picurl componentsSeparatedByString:@","];
    }
    if (model.shouldShowMoreButton) { // 如果文字高度超过60
        _moreButton.sd_layout.heightIs(20);
        _moreButton.hidden = NO;
        if (model.isOpening) { // 如果需要展开
            _contentLabel.sd_layout.maxHeightIs(MAXFLOAT);
            [_moreButton setTitle:@"收起" forState:UIControlStateNormal];
        } else {
            _contentLabel.sd_layout.maxHeightIs(maxContentLabelHeight3);
            [_moreButton setTitle:@"全文" forState:UIControlStateNormal];
        }
    } else {
        _moreButton.sd_layout.heightIs(0);
        _moreButton.hidden = YES;
    }
    
    CGFloat picContainerTopMargin = 0;
    if (_picContainerView.picPathStringsArray.count) {
        picContainerTopMargin = 10;
    }
    _picContainerView.sd_layout.topSpaceToView(_moreButton, picContainerTopMargin);
    
    UIView *bottomView;
    if (!model.workCommentsList.count ) {
        bottomView = _commentButton;
    } else {
        bottomView = _commentView;
    }
    [self setupAutoHeightWithBottomView:bottomView bottomMargin:15];
    
    if ([NSStringUtils isEmpty:model.address]) {
        _addressLabel.text = @" ";
    }else{
        _addressLabel.text = model.address;
    }
    
    NSString *time = [model.worktime substringToIndex:10];
    _timeLabel.text = time;
    
    if (model.favstatus == 0) {
        _supportButton.selected = NO;
    }else{
        _supportButton.selected = YES;
    }
    if(model.type == 1){
        _typeLabel.text = @"我的";
    }else if(model.type == 2){
        _typeLabel.text = @"下属";
    }else if(model.type == 3){
        _typeLabel.text = @"参与";
    }else{
        _typeLabel.text = @"下属·参与";
    }
    
    switch (model.worktype) {
        case 1:
            _worktypeLabel.text = @"会议面谈";
            break;
        case 2:
            _worktypeLabel.text = @"餐饮娱乐";
            break;
        case 3:
            _worktypeLabel.text = @"通信";
            break;
        case 4:
            _worktypeLabel.text = @"撰写文本";
            break;
        case 5:
            _worktypeLabel.text = @"签订合同";
            break;
        case 6:
            _worktypeLabel.text = @"市场活动";
            break;
        default:
            _worktypeLabel.text = @"其他";
            break;
    }
    _customerLabel.text = model.customerName;
}

- (void)moreButtonClicked
{
    if (self.moreButtonClickedBlock) {
        self.moreButtonClickedBlock(self.indexPath);
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
}

- (void)supportClicked:(id)sender{
    UIButton *button = (UIButton *)sender;
    button.selected = !button.selected;
}

- (void)colleagueButtonClicked{
    [_delegate workColleagueDidClick:_model];
}
@end
