//
//  CircleDetailsTableViewCell.m
//  sales
//
//  Created by user on 2016/11/17.
//  Copyright © 2016年 rayootech. All rights reserved.
//

#import "CircleDetailsTableViewCell.h"
#import "BCommentView.h"

@implementation CircleDetailsTableViewCell
{
    UIImageView              *_iconView;
    UILabel                  *_unameLable;
    UILabel                  *_commentLabel;
    UILabel                  *_bcommentLable;
    UILabel                  *_timeLabel;
    UILabel                  *_favnumLabel;
    UIButton                 *_supportButton;     //点赞图片
    BCommentView             *_bcommentView;
}
- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
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
    _iconView.layer.cornerRadius = 18;
    _iconView.layer.masksToBounds = true;
    
    _unameLable = [UILabel new];
    _unameLable.font = [UIFont systemFontOfSize:14];
    _unameLable.textColor = [UIColor colorWithRed:(54 / 255.0) green:(71 / 255.0) blue:(121 / 255.0) alpha:0.9];
    
    _commentLabel = [UILabel new];
    _commentLabel.font = [UIFont systemFontOfSize:14];
    _commentLabel.numberOfLines = 0;
    
    
    _timeLabel = [UILabel new];
    _timeLabel.font = [UIFont systemFontOfSize:13];
    
    _favnumLabel = [UILabel new];
    _favnumLabel.font = [UIFont systemFontOfSize:13];
    
    _bcommentView = [BCommentView new];
    
    _supportButton = [UIButton new];
    [_supportButton setImage:[UIImage imageNamed:@"moments_support_nor"] forState:UIControlStateNormal];
    [_supportButton addTarget:self action:@selector(supportClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_supportButton setImage:[UIImage imageNamed:@"moments_support_sel"] forState:UIControlStateSelected];
    
    
    NSArray *views = @[_iconView, _unameLable, _commentLabel, _timeLabel,_supportButton,_bcommentView,_favnumLabel];
    
    [self.contentView sd_addSubviews:views];
    
    UIView *contentView = self.contentView;
    CGFloat margin = 12;
    
    _iconView.sd_layout
    .leftSpaceToView(contentView, margin)
    .topSpaceToView(contentView, margin + 5)
    .widthIs(36)
    .heightIs(36);
    
    _unameLable.sd_layout
    .leftSpaceToView(_iconView, margin)
    .topEqualToView(_iconView)
    .heightIs(18);
    [_unameLable setSingleLineAutoResizeWithMaxWidth:200];
    
    _timeLabel.sd_layout
    .leftEqualToView(_unameLable)
    .topSpaceToView(_unameLable, 5)
    .heightIs(15);
    [_timeLabel setSingleLineAutoResizeWithMaxWidth:200];
    
    _favnumLabel.sd_layout
    .rightSpaceToView(contentView,margin+8)
    .centerYEqualToView(_unameLable).heightIs(15);
    [_favnumLabel setSingleLineAutoResizeWithMaxWidth:25];
    
    _supportButton.sd_layout
    .rightSpaceToView(_favnumLabel,margin)
    .centerYEqualToView(_unameLable).heightIs(20).widthIs(16);
    
    _commentLabel.sd_layout
    .leftEqualToView(_unameLable)
    .topSpaceToView(_timeLabel, margin)
    .rightSpaceToView(contentView, margin)
    .autoHeightRatio(0);
    
    _bcommentView.sd_layout
    .leftEqualToView(_commentLabel)
    .rightSpaceToView(contentView, margin)
    .topSpaceToView(_commentLabel, margin);
    
}

- (void)setType:(NSInteger)type{
    _type = type;
}

- (void)setModel:(Comment *)model{
    _model = model;
    
    
    _iconView.image = [UIImage imageNamed:model.avatar];
    [_iconView loadPortrait:model.avatar];
    _unameLable.text = model.uname;
    _commentLabel.text = model.comment;
    
    [_bcommentView setBComment:model];
    if (model.bname.length == 0) {
        [self setupAutoHeightWithBottomView:_commentLabel bottomMargin:15];
    }else
        [self setupAutoHeightWithBottomView:_bcommentView bottomMargin:15];
    
    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSDate* date;
    if ([NSStringUtils isEmpty:model.publishtime]) {
        date = [formatter dateFromString:model.createtime];
    }else{
        date = [formatter dateFromString:model.publishtime];
    }
//    NSDate* date = [formatter dateFromString:model.publishtime];
    [_timeLabel setAttributedText:[Utils attributedTimeString:date]];
    
    if (model.favstatus == 0) {
        _supportButton.selected = NO;
    }else{
        _supportButton.selected = YES;
    }
    _favnumLabel.text = [NSString stringWithFormat:@"%ld",model.favnum];
}

- (void)setUnread:(BOOL)unread{
    if (unread) {
        _supportButton.hidden = YES;
    }
}

- (void)supportClicked:(id)sender{
    
    if (_type == 1) {
        [self setCircleFav];
    }else if(_type == 2){
        [self setBlackBoardFav];
    }else if(_type == 3){
        [self setWorkFav];
    }
}

- (void)setBlackBoardFav{
    NSString *userId = [NSString stringWithFormat:@"%ld",[Config getOrgUserID]];;
    NSString *token = [Config getToken];
    NSString *dbid = [NSString stringWithFormat:@"%ld",[Config getDbID]];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    
    NSString* urlStr = [NSString stringWithFormat:@"%@%@",BASE_URL,API_BLACKBOARD_FAV];
    
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"POST" URLString:urlStr parameters:@{@"postid":@"-1",@"commentid":[NSString stringWithFormat:@"%ld",_model.id]}                                                                                    error:nil];
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
                }else{
                    
                }
                
            }else{
                
            }
        }
    }];
    [dataTask resume];
}

- (void)setCircleFav{
    NSString *userId = [NSString stringWithFormat:@"%lld",[Config getOwnID]];;
    NSString *token = [Config getToken];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    
    NSString* urlStr = [NSString stringWithFormat:@"%@%@",BASE_URL,API_CIRCLE_FAV];
    
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"POST" URLString:urlStr parameters:@{@"postid":@"-1",@"commentid":[NSString stringWithFormat:@"%ld",_model.id]}                                                                                    error:nil];
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

- (void)setWorkFav{
    NSString *userId = [NSString stringWithFormat:@"%ld",[Config getOrgUserID]];;
    NSString *token = [Config getToken];
    NSString *dbid = [NSString stringWithFormat:@"%ld",[Config getDbID]];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    
    NSString* urlStr = [NSString stringWithFormat:@"%@%@",BASE_URL,API_WORK_FAV];
    
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"POST" URLString:urlStr parameters:@{@"workid":@"-1",@"commentid":[NSString stringWithFormat:@"%ld",_model.id]}                                                                                    error:nil];
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
                }else{
                    
                }
                
            }else{
                
            }
        }
    }];
    [dataTask resume];
}

@end
