//
//  WorkDetailsHeaderView.m
//  sales
//
//  Created by user on 2017/4/11.
//  Copyright © 2017年 rayootech. All rights reserved.
//

#import "WorkDetailsHeaderView.h"
#import "PhotoContainerView.h"
#import "WorkDbUtil.h"

const CGFloat contentLabelFontSize4 = 14;
CGFloat maxContentLabelHeight4 = 0; // 根据具体font而定
@interface WorkDetailsHeaderView ()

@property (nonatomic,strong) WorkDbUtil             *workDb;

@end
@implementation WorkDetailsHeaderView

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
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithHex:0xEEEEEE];
        [self setup];
    }
    return self;
}
- (void)setup{
    _workDb = [[WorkDbUtil alloc] init];
    _iconView = [UIImageView new];
    
    _nameLable = [UILabel new];
    _nameLable.font = [UIFont systemFontOfSize:14];
    _nameLable.textColor = [UIColor colorWithRed:(54 / 255.0) green:(71 / 255.0) blue:(121 / 255.0) alpha:0.9];
    
    _contentLabel = [UILabel new];
    _contentLabel.font = [UIFont systemFontOfSize:contentLabelFontSize4];
    
    _moreButton = [UIButton new];
    [_moreButton setTitle:@"全文" forState:UIControlStateNormal];
    [_moreButton setTitleColor:TimeLineCellHighlightedColor forState:UIControlStateNormal];
    [_moreButton addTarget:self action:@selector(moreButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    _moreButton.titleLabel.font = [UIFont systemFontOfSize:14];
    
    
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
    
    
    _picContainerView.sd_layout
    .leftEqualToView(_contentLabel); // 已经在内部实现宽度和高度自适应所以不需要再设置宽度高度，top值是具体有无图片在setModel方法中设置
    
    _timeLabel.sd_layout
    .leftEqualToView(_contentLabel)
    .topSpaceToView(_picContainerView, margin)
    .heightIs(15);
    [_timeLabel setSingleLineAutoResizeWithMaxWidth:200];
    
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

- (void)setModel:(Work *)model{
    _model = model;
    
    _iconView.image = [UIImage imageNamed:model.avatar];
    [_iconView loadPortrait:model.avatar];
    _nameLable.text = model.user;
    _contentLabel.text = model.content;
    if([model.picurl isEqualToString:@""]){
        _picContainerView.picPathStringsArray = [NSArray new];
    }else{
        _picContainerView.picPathStringsArray = [model.picurl componentsSeparatedByString:@","];
    }
    
    CGFloat picContainerTopMargin = 0;
    if (_picContainerView.picPathStringsArray.count) {
        picContainerTopMargin = 10;
    }
    _picContainerView.sd_layout.topSpaceToView(_contentLabel, picContainerTopMargin);
    
    
    [self setupAutoHeightWithBottomView:_timeLabel bottomMargin:15];
    
    NSString *time = [model.worktime substringToIndex:10];
    _timeLabel.text = time;
    
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
    NSString *userId = [NSString stringWithFormat:@"%ld",[Config getOrgUserID]];;
    NSString *token = [Config getToken];
    NSString *dbid = [NSString stringWithFormat:@"%ld",[Config getDbID]];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    
    NSString* urlStr = [NSString stringWithFormat:@"%@%@",BASE_URL,API_WORK_FAV];
    
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"POST" URLString:urlStr parameters:@{@"commentid":@"-1",@"workid":[NSString stringWithFormat:@"%ld",_model.id]}                                                                                    error:nil];
    [request addValue:userId forHTTPHeaderField:@"userId"];
    [request addValue:token forHTTPHeaderField:@"token"];
    [request addValue:dbid forHTTPHeaderField:@"dbid"];
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
                    [_workDb updateWork:_model];
                }else{
                    
                }
                
            }else{
                
            }
        }
    }];
    [dataTask resume];
}

@end
