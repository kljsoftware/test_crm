//
//  NoticeDetailsViewController.m
//  sales
//
//  Created by user on 2017/1/20.
//  Copyright © 2017年 rayootech. All rights reserved.
//

#import "NoticeDetailsViewController.h"
@interface NoticeDetailsViewController ()
//@property (nonatomic,weak) IBOutlet UIScrollView *scrollView;
//@property (nonatomic,weak) IBOutlet UIView  *contentView;
//@property (nonatomic,weak) IBOutlet UILabel *titleLabel;
//@property (nonatomic,weak) IBOutlet UILabel *timeLabel;
//@property (nonatomic,weak) IBOutlet UILabel *contentLabel;

@property (nonatomic,strong) UIScrollView *scrollView;
@property (nonnull,strong)   UIView  *contentView;
@property (nonatomic,strong) UIView  *lineView;
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UILabel *timeLabel;
@property (nonatomic,strong) UILabel *contentLabel;
@end

@implementation NoticeDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUpView];
}

- (void)setUpView{
    _scrollView = [UIScrollView new];
    [self.view addSubview:_scrollView];
    _scrollView.sd_layout
    .topSpaceToView(self.view, 0)
    .rightSpaceToView(self.view, 0)
    .leftSpaceToView(self.view, 0)
    .bottomSpaceToView(self.view, 0);
    
    _contentView = [UIView new];
    [_scrollView addSubview:_contentView];
    _contentView.sd_layout
    .topSpaceToView(_scrollView, 0)
    .leftSpaceToView(_scrollView, 0)
    .rightSpaceToView(_scrollView, 0)
    .bottomSpaceToView(_scrollView, 0);
    
    _titleLabel = [UILabel new];
    _timeLabel.font = [UIFont systemFontOfSize:14];
    [_contentView addSubview:_titleLabel];
    _titleLabel.sd_layout
    .topSpaceToView(_contentView, 20)
    .leftSpaceToView(_contentView, 20)
    .rightSpaceToView(_contentView, 20)
    .autoHeightRatio(0);
    _titleLabel.numberOfLines = 0;
    
    _timeLabel = [UILabel new];
    _timeLabel.font = [UIFont systemFontOfSize:12];
    [_contentView addSubview:_timeLabel];
    _timeLabel.sd_layout
    .topSpaceToView(_titleLabel, 10)
    .leftSpaceToView(_contentView, 20)
    .rightSpaceToView(_contentView, 20)
    .heightIs(20);
    
    _lineView = [UIView new];
    [_contentView addSubview:_lineView];
    _lineView.backgroundColor = [UIColor grayColor];
    _lineView.sd_layout
    .topSpaceToView(_timeLabel, 5)
    .rightSpaceToView(_contentView, 20)
    .leftSpaceToView(_contentView, 20)
    .heightIs(1);
    
    _contentLabel = [UILabel new];
    _contentLabel.font = [UIFont systemFontOfSize:14];
    [_contentView addSubview:_contentLabel];
    _contentLabel.sd_layout
    .topSpaceToView(_lineView, 20)
    .leftSpaceToView(_contentView, 20)
    .rightSpaceToView(_contentView, 20)
    .autoHeightRatio(0);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    CGFloat w = self.view.bounds.size.width;
    CGFloat h = _contentLabel.bounds.size.height + 96 + _titleLabel.bounds.size.height;
    _scrollView.contentSize = CGSizeMake(w, h);
}
- (void)setNotice:(Notice *)notice{
    _notice = notice;
    _titleLabel.text = notice.title;
    _timeLabel.text = notice.createtime;
    _contentLabel.text = notice.content;
}

@end
