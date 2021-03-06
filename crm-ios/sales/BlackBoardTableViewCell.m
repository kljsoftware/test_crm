//
//  BlackBoardTableViewCell.m
//  sales
//
//  Created by user on 2017/2/14.
//  Copyright © 2017年 rayootech. All rights reserved.
//

#import "BlackBoardTableViewCell.h"
#import "Circle.h"
#import "PhotoContainerView.h"
#import "CircleCellCommentView.h"

const CGFloat contentLabelFontSize1 = 15;
CGFloat maxContentLabelHeight1 = 0; // 根据具体font而定

@implementation BlackBoardTableViewCell

{
    UIImageView              *_iconView;
    UILabel                  *_nameLable;
    UILabel                  *_contentLabel;
    UILabel                  *_timeLabel;
    UIButton                 *_moreButton;
    UIButton                 *_operationButton;
    UIButton                 *_supportButton;     //点赞图片
    UIButton                 *_commentButton;         //评论图片
    UILabel                  *_supportNumLabel;
    UILabel                  *_commentNumLabel;
    UIButton                 *_deleteButton;
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
    _iconView.layer.cornerRadius = 20;
    _iconView.layer.masksToBounds = true;
    
    _nameLable = [UILabel new];
    _nameLable.font = [UIFont systemFontOfSize:14];
    _nameLable.textColor = [UIColor colorWithRed:(54 / 255.0) green:(71 / 255.0) blue:(121 / 255.0) alpha:0.9];
    
    _contentLabel = [UILabel new];
    _contentLabel.font = [UIFont systemFontOfSize:contentLabelFontSize1];
    _contentLabel.numberOfLines = 0;
    if (maxContentLabelHeight1 == 0) {
        maxContentLabelHeight1 = _contentLabel.font.lineHeight * 3;
    }
    
    _supportNumLabel = [UILabel new];
    _supportNumLabel.font = SYSTEM_FONT(9);
    _supportNumLabel.textColor = [UIColor colorWithHex:0x333333];
    
    _commentNumLabel = [UILabel new];
    _commentNumLabel.font = SYSTEM_FONT(9);
    _commentNumLabel.textColor = [UIColor colorWithHex:0x333333];
    
    _moreButton = [UIButton new];
    [_moreButton setTitle:@"全文" forState:UIControlStateNormal];
    [_moreButton setTitleColor:TimeLineCellHighlightedColor forState:UIControlStateNormal];
    [_moreButton addTarget:self action:@selector(moreButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    _moreButton.titleLabel.font = [UIFont systemFontOfSize:14];
    
    _picContainerView = [PhotoContainerView new];
    
    _commentView = [CircleCellCommentView new];
    
    _timeLabel = [UILabel new];
    _timeLabel.font = [UIFont systemFontOfSize:13];
    
    _supportButton = [UIButton new];
    [_supportButton setImage:[UIImage imageNamed:@"moments_support_nor"] forState:UIControlStateNormal];
    [_supportButton setImage:[UIImage imageNamed:@"moments_support_sel"] forState:UIControlStateSelected];
    [_supportButton addTarget:self action:@selector(supportClicked:) forControlEvents:UIControlEventTouchUpInside];

    _commentButton = [UIButton new];
    [_commentButton setImage:[UIImage imageNamed:@"moments_comment_nor"] forState:UIControlStateNormal];
    [_commentButton addTarget:self action:@selector(commentClick:) forControlEvents:UIControlEventTouchUpInside];
    
    _deleteButton = [UIButton new];
    [_deleteButton setImage:[UIImage imageNamed:@"moments_delete"] forState:UIControlStateNormal];
    [_deleteButton addTarget:self action:@selector(deleteClick:) forControlEvents:UIControlEventTouchUpInside];
    NSArray *views = @[_iconView, _nameLable, _contentLabel, _moreButton, _picContainerView, _timeLabel,_supportButton,_commentButton, _commentView,_deleteButton, _commentNumLabel, _supportNumLabel];
    
    [self.contentView sd_addSubviews:views];
    
    UIView *contentView = self.contentView;
    CGFloat margin = 12;
    
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
    
    _timeLabel.sd_layout
    .leftEqualToView(_contentLabel)
    .topSpaceToView(_picContainerView, margin)
    .heightIs(15);
    [_timeLabel setSingleLineAutoResizeWithMaxWidth:200];
    
    _commentNumLabel.sd_layout
    .rightSpaceToView(contentView,margin+10)
    .centerYEqualToView(_timeLabel).heightIs(15);
    [_commentNumLabel setSingleLineAutoResizeWithMaxWidth:100];
    
    _commentButton.sd_layout
    .rightSpaceToView(_commentNumLabel,5)
    .centerYEqualToView(_commentNumLabel).widthIs(20).heightIs(16);
    
    _supportNumLabel.sd_layout
    .rightSpaceToView(_commentButton,margin+8)
    .centerYEqualToView(_commentNumLabel);
    [_supportNumLabel setSingleLineAutoResizeWithMaxWidth:100];
    
    _supportButton.sd_layout
    .rightSpaceToView(_supportNumLabel,5)
    .centerYEqualToView(_commentNumLabel).widthIs(20).heightIs(16);
    
    _commentView.sd_layout
    .leftEqualToView(_contentLabel)
    .rightSpaceToView(self.contentView, margin)
    .topSpaceToView(_timeLabel, margin); // 已经在内部实现高度自适应所以不需要再设置高度
    
    _deleteButton.sd_layout
    .rightSpaceToView(_supportButton, margin).centerYEqualToView(_supportButton).heightIs(24).widthIs(18);
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(BlackBoard *)model{
    _model = model;
    
    [_commentView setupWithLikeItemsArray:nil commentItemsArray:model.bbCommentsList];
    
    _iconView.image = [UIImage imageNamed:model.avatar];
    [_iconView loadPortrait:model.avatar];
    _nameLable.text = model.uname;
    _contentLabel.text = model.content;
    if([model.img isEqualToString:@""]){
        _picContainerView.picPathStringsArray = [NSArray new];
    }else{
        _picContainerView.picPathStringsArray = [model.img componentsSeparatedByString:@","];
    }
    if (model.shouldShowMoreButton) { // 如果文字高度超过60
        _moreButton.sd_layout.heightIs(20);
        _moreButton.hidden = NO;
        if (model.isOpening) { // 如果需要展开
            _contentLabel.sd_layout.maxHeightIs(MAXFLOAT);
            [_moreButton setTitle:@"收起" forState:UIControlStateNormal];
        } else {
            _contentLabel.sd_layout.maxHeightIs(maxContentLabelHeight1);
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
    
    if (!model.bbCommentsList.count) {
        bottomView = _timeLabel;
    } else {
        bottomView = _commentView;
    }
    [self setupAutoHeightWithBottomView:bottomView bottomMargin:15];
    
    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSDate* date = [formatter dateFromString:model.posttime];
    [_timeLabel setAttributedText:[Utils attributedTimeString:date]];
    _supportNumLabel.text = [NSString stringWithFormat:@"%ld",model.favnum];
    _commentNumLabel.text = [NSString stringWithFormat:@"%ld",model.bbCommentsList.count];
    if (model.favstatus == 0) {
        _supportButton.selected = NO;
    }else{
        _supportButton.selected = YES;
    }
    
    if ([Config getOrgUserID] == model.uid) {
        _deleteButton.hidden = NO;
    }else{
        _deleteButton.hidden = YES;
    }
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

- (void)supportClicked:(UIButton *)sender{
//    sender.selected = !sender.selected;
//    if (sender.selected) {
//        _model.favnum++;
//    } else {
//        _model.favnum--;
//    }
//    [self setModel:_model];
}

- (void)deleteClick:(id)sender{
    [_delegate deleteClick:_indexPath];
}
- (void)commentClick:(id)sender{
    [_delegate commentClick:_indexPath];
}
@end
