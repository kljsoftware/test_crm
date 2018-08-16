//
//  PaperTableViewCell.m
//  sales
//
//  Created by user on 2017/1/18.
//  Copyright © 2017年 rayootech. All rights reserved.
//

#import "PaperTableViewCell.h"
#import "UIImageView+Util.h"
#import "Utils.h"
@interface PaperTableViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *pictureImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@end
@implementation PaperTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(Paper *)model{
    _model = model;
    _titleLabel.text = model.title;
    _contentLabel.text = model.content;
//    _timeLabel.text = model.createtime;
    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSDate* date = [formatter dateFromString:model.createtime];
    [_timeLabel setAttributedText:[Utils attributedTimeString:date]];
    [_pictureImageView loadPortrait:@"00"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
