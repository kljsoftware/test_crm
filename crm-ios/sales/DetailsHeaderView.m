//
//  DetailsHeaderView.m
//  sales
//
//  Created by user on 2016/11/23.
//  Copyright © 2016年 rayootech. All rights reserved.
//

#import "DetailsHeaderView.h"
#import "PhotoContainerView.h"

const CGFloat contentLabelFontSizes = 14;
CGFloat maxContentLabelHeights = 0; // 根据具体font而定
@implementation DetailsHeaderView

{
    UIImageView              *_iconView;
    UILabel                  *_nameLable;
    UILabel                  *_contentLabel;
    UILabel                  *_timeLabel;
    UILabel                  *_favnumLabel;
    UIButton                 *_moreButton;
    UIButton                 *_operationButton;
    UIButton                 *_supportButton;     //点赞图片
    UIButton                 *_commentButton;         //评论图片
    PhotoContainerView       *_picContainerView;
}

//- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
//{
//    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
//        
//        [self setup];
//        
//        self.selectionStyle = UITableViewCellSelectionStyleNone;
//    }
//    return self;
//}
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithHex:0xEEEEEE];
        [self setup];
    }
    return self;
}
- (void)setup{
    
    _iconView = [UIImageView new];
    
    _nameLable = [UILabel new];
    _nameLable.font = [UIFont systemFontOfSize:14];
    _nameLable.textColor = [UIColor colorWithRed:(54 / 255.0) green:(71 / 255.0) blue:(121 / 255.0) alpha:0.9];
    
    _contentLabel = [UILabel new];
    _contentLabel.font = [UIFont systemFontOfSize:contentLabelFontSizes];
//    _contentLabel.numberOfLines = 0;
//    if (maxContentLabelHeights == 0) {
//        maxContentLabelHeights = _contentLabel.font.lineHeight * 3;
//    }
    
    _moreButton = [UIButton new];
    [_moreButton setTitle:@"全文" forState:UIControlStateNormal];
    [_moreButton setTitleColor:TimeLineCellHighlightedColor forState:UIControlStateNormal];
    [_moreButton addTarget:self action:@selector(moreButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    _moreButton.titleLabel.font = [UIFont systemFontOfSize:14];
    
    //    _operationButton = [UIButton new];
    //    [_operationButton setImage:[UIImage imageNamed:@"AlbumOperateMore"] forState:UIControlStateNormal];
    //    [_operationButton addTarget:self action:@selector(operationButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    
    _picContainerView = [PhotoContainerView new];
    
    _timeLabel = [UILabel new];
    _timeLabel.font = [UIFont systemFontOfSize:13];
    
    _favnumLabel = [UILabel new];
    _favnumLabel.font = [UIFont systemFontOfSize:13];
    
    _supportButton = [UIButton new];
    [_supportButton setImage:[UIImage imageNamed:@"support_nor"] forState:UIControlStateNormal];
    [_supportButton addTarget:self action:@selector(supportClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_supportButton setImage:[UIImage imageNamed:@"support_cover"] forState:UIControlStateSelected];
    
    _commentButton = [UIButton new];
    [_commentButton setImage:[UIImage imageNamed:@"comment_nor"] forState:UIControlStateNormal];
    
    NSArray *views = @[_iconView, _nameLable, _contentLabel, _picContainerView, _timeLabel,_supportButton,_favnumLabel];
    
    [self sd_addSubviews:views];
    
    CGFloat margin = 10;
    
    _iconView.sd_layout
    .leftSpaceToView(self, margin)
    .topSpaceToView(self, margin + 5)
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
    .rightSpaceToView(self, margin)
    .autoHeightRatio(0);
    
    // morebutton的高度在setmodel里面设置
//    _moreButton.sd_layout
//    .leftEqualToView(_contentLabel)
//    .topSpaceToView(_contentLabel, 0)
//    .widthIs(30);
    
    
    _picContainerView.sd_layout
    .leftEqualToView(_contentLabel); // 已经在内部实现宽度和高度自适应所以不需要再设置宽度高度，top值是具体有无图片在setModel方法中设置
    
    _timeLabel.sd_layout
    .leftEqualToView(_contentLabel)
    .topSpaceToView(_picContainerView, margin)
    .heightIs(15);
    [_timeLabel setSingleLineAutoResizeWithMaxWidth:200];
    
    
//    _commentButton.sd_layout
//    .rightSpaceToView(self,margin+5)
//    .centerYEqualToView(_timeLabel).heightIs(15).widthIs(15);
    
    _favnumLabel.sd_layout
    .rightSpaceToView(self,margin).topEqualToView(_timeLabel).heightIs(15);
    [_favnumLabel setSingleLineAutoResizeWithMaxWidth:25];
    
    _supportButton.sd_layout
    .rightSpaceToView(_favnumLabel,margin)
    .topEqualToView(_timeLabel).heightIs(15).widthIs(15);
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(Circle *)model{
    _model = model;
    
    _iconView.image = [UIImage imageNamed:model.avatar];
    [_iconView loadPortrait:model.avatar];
    _nameLable.text = model.uname;
    _contentLabel.text = model.content;
    if([model.picurl isEqualToString:@""]){
        _picContainerView.picPathStringsArray = [NSArray new];
    }else{
        _picContainerView.picPathStringsArray = [model.picurl componentsSeparatedByString:@","];
    }
//    if (model.shouldShowMoreButton) { // 如果文字高度超过60
//        _moreButton.sd_layout.heightIs(20);
//        _moreButton.hidden = NO;
//        if (model.isOpening) { // 如果需要展开
//            _contentLabel.sd_layout.maxHeightIs(MAXFLOAT);
//            [_moreButton setTitle:@"收起" forState:UIControlStateNormal];
//        } else {
//            _contentLabel.sd_layout.maxHeightIs(maxContentLabelHeights);
//            [_moreButton setTitle:@"全文" forState:UIControlStateNormal];
//        }
//    } else {
//        _moreButton.sd_layout.heightIs(0);
//        _moreButton.hidden = YES;
//    }
    
    CGFloat picContainerTopMargin = 0;
    if (_picContainerView.picPathStringsArray.count) {
        picContainerTopMargin = 10;
    }
    _picContainerView.sd_layout.topSpaceToView(_contentLabel, picContainerTopMargin);
    
    
    [self setupAutoHeightWithBottomView:_timeLabel bottomMargin:15];
    
    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSDate* date = [formatter dateFromString:model.publishtime];
    [_timeLabel setAttributedText:[Utils attributedTimeString:date]];
    
    if (model.favstatus != 0) {
        _supportButton.selected = YES;
    }else{
        _supportButton.selected = NO;
    }
    _favnumLabel.text = [NSString stringWithFormat:@"%ld",model.favnum];
}

- (void)moreButtonClicked
{
}

- (void)supportClicked:(id)sender{
    //    if (tap.state == UIGestureRecognizerStateBegan) {
    //        NSLog(@"data-->beginclick");
    //    }else if(tap.state == UIGestureRecognizerStateEnded){
    //        NSLog(@"data-->endedclick");
    //    }
//    UIButton *button = (UIButton *)sender;
//    button.selected = !button.selected;
    NSLog(@"data-->666");
    NSString *userId = [NSString stringWithFormat:@"%lld",[Config getOwnID]];;
    NSString *token = [Config getToken];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    
    NSString* urlStr = [NSString stringWithFormat:@"%@%@",BASE_URL,API_CIRCLE_FAV];
    
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"POST" URLString:urlStr parameters:@{@"commentid":@"-1",@"postid":[NSString stringWithFormat:@"%ld",_model.id]}                                                                                    error:nil];
    [request addValue:userId forHTTPHeaderField:@"userId"];
    [request addValue:token forHTTPHeaderField:@"token"];
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id _Nonnull responseObject, NSError *error) {
        if (error) {
            NSLog(@"Error:-->%@", error);
        } else {
            NSString *responseString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            NSLog(@"DATA UNREAD-->%@", responseString);
            if (responseObject) {
                NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
                if ([dictionary[@"result"] intValue] == 1) {
                    if (_model.favstatus == 0) {
                        _model.favstatus = 1;
                        _model.favnum++;
                        _supportButton.selected = YES;
                        _favnumLabel.text = [NSString stringWithFormat:@"%ld",_model.favnum];
                    }else{
                        _model.favstatus = 0;
                        _model.favnum--;
                        _supportButton.selected = NO;
                        _favnumLabel.text = [NSString stringWithFormat:@"%ld",_model.favnum];
                    }
                }else{
                    
                }
                
            }else{
                
            }
        }
    }];
    [dataTask resume];
}

@end
