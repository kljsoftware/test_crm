//
//  CircleTableCell.m
//  sales
//
//  Created by user on 2016/11/11.
//  Copyright © 2016年 rayootech. All rights reserved.
//

#import "CircleTableCell.h"
#import "Circle.h"
#import "PhotoContainerView.h"
#import "CircleCellCommentView.h"

const CGFloat contentLabelFontSize = 14;
CGFloat maxContentLabelHeight = 0; // 根据具体font而定

@implementation CircleTableCell
{
    UIImageView              *_iconView;
    UILabel                  *_nameLable;
    UILabel                  *_contentLabel;
    UILabel                  *_timeLabel;
    UIButton                 *_moreButton;
    UIButton                 *_operationButton;
    UIButton                 *_supportButton;     //点赞图片
    UIButton                 *_commentButton;         //评论图片
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
    
    _nameLable = [UILabel new];
    _nameLable.font = [UIFont systemFontOfSize:14];
    _nameLable.textColor = [UIColor colorWithRed:(54 / 255.0) green:(71 / 255.0) blue:(121 / 255.0) alpha:0.9];
    
    _contentLabel = [UILabel new];
    _contentLabel.font = [UIFont systemFontOfSize:contentLabelFontSize];
    _contentLabel.numberOfLines = 0;
    if (maxContentLabelHeight == 0) {
        maxContentLabelHeight = _contentLabel.font.lineHeight * 3;
    }
    
    _moreButton = [UIButton new];
    [_moreButton setTitle:@"全文" forState:UIControlStateNormal];
    [_moreButton setTitleColor:TimeLineCellHighlightedColor forState:UIControlStateNormal];
    [_moreButton addTarget:self action:@selector(moreButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    _moreButton.titleLabel.font = [UIFont systemFontOfSize:14];
    
//    _operationButton = [UIButton new];
//    [_operationButton setImage:[UIImage imageNamed:@"AlbumOperateMore"] forState:UIControlStateNormal];
//    [_operationButton addTarget:self action:@selector(operationButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    
    _picContainerView = [PhotoContainerView new];
    
    _commentView = [CircleCellCommentView new];
    
    _timeLabel = [UILabel new];
    _timeLabel.font = [UIFont systemFontOfSize:13];
    
    _supportButton = [UIButton new];
    [_supportButton setImage:[UIImage imageNamed:@"support_nor"] forState:UIControlStateNormal];
    [_supportButton addTarget:self action:@selector(supportClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_supportButton setImage:[UIImage imageNamed:@"support_cover"] forState:UIControlStateSelected];
    
    _commentButton = [UIButton new];
    [_commentButton setImage:[UIImage imageNamed:@"comment_nor"] forState:UIControlStateNormal];
    
    
    _deleteButton = [UIButton new];
    [_deleteButton setImage:[UIImage imageNamed:@"delete_button"] forState:UIControlStateNormal];
    [_deleteButton addTarget:self action:@selector(deleteClick:) forControlEvents:UIControlEventTouchUpInside];
    NSArray *views = @[_iconView, _nameLable, _contentLabel, _moreButton, _picContainerView, _timeLabel,_supportButton,_commentButton, _commentView,_deleteButton];
    
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
    
    _timeLabel.sd_layout
    .leftEqualToView(_contentLabel)
    .topSpaceToView(_picContainerView, margin)
    .heightIs(15);
    [_timeLabel setSingleLineAutoResizeWithMaxWidth:200];
    
//    _operationButton.sd_layout
//    .rightSpaceToView(contentView, margin)
//    .centerYEqualToView(_timeLabel)
//    .heightIs(25)
//    .widthIs(25);
    
    _commentButton.sd_layout
    .rightSpaceToView(contentView,margin+5)
    .centerYEqualToView(_timeLabel).heightIs(15).widthIs(15);
    
    _supportButton.sd_layout
    .rightSpaceToView(_commentButton,margin)
    .topEqualToView(_commentButton).heightIs(15).widthIs(15);
    
    _commentView.sd_layout
    .leftEqualToView(_contentLabel)
    .rightSpaceToView(self.contentView, margin)
    .topSpaceToView(_timeLabel, margin); // 已经在内部实现高度自适应所以不需要再设置高度
    
    _deleteButton.sd_layout
    .rightSpaceToView(_supportButton, margin).topEqualToView(_supportButton).heightIs(14).widthIs(14);

}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(Circle *)model{
    _model = model;
    
    [_commentView setupWithLikeItemsArray:nil commentItemsArray:model.commentsList];
    
    _iconView.image = [UIImage imageNamed:model.avatar];
    [_iconView loadPortrait:model.avatar];
    _nameLable.text = model.uname;
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
            _contentLabel.sd_layout.maxHeightIs(maxContentLabelHeight);
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
    if (!model.commentsList.count ) {
        bottomView = _timeLabel;
    } else {
        bottomView = _commentView;
    }
    [self setupAutoHeightWithBottomView:bottomView bottomMargin:15];
    
    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSDate* date = [formatter dateFromString:model.publishtime];
    [_timeLabel setAttributedText:[Utils attributedTimeString:date]];

    if (_model.favstatus == 0) {
        _supportButton.selected = NO;
    }else{
        _supportButton.selected = YES;
    }
    if ([Config getOwnID] == model.uid) {
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

    // Configure the view for the selected state
}

- (void)supportClicked:(id)sender{
//    if (tap.state == UIGestureRecognizerStateBegan) {
//        NSLog(@"data-->beginclick");
//    }else if(tap.state == UIGestureRecognizerStateEnded){
//        NSLog(@"data-->endedclick");
//    }
//    UIButton *button = (UIButton *)sender;
//    button.selected = !button.selected;
//    NSLog(@"data-->666");
}

- (void)deleteClick:(id)sender{
    [_delegate deleteClick:_indexPath];
}
@end
