//
//  CustomerDeepViewController.m
//  sales
//
//  Created by user on 2017/2/21.
//  Copyright © 2017年 rayootech. All rights reserved.
//

#import "CustomerDeepViewController.h"
#import "CustomerInfoViewController.h"
#import "CustomerSocialViewController.h"
#import "CustomerEvaluationViewController.h"
#import "CustomerSettingViewController.h"
#define kMainWidth [UIScreen mainScreen].bounds.size.width
@interface CustomerDeepViewController ()

@property (nonatomic,weak) IBOutlet UILabel *nameLabel;
@property (nonatomic,weak) IBOutlet UILabel *sexLabel;
@property (nonatomic,weak) IBOutlet UILabel *companyLabel;
@property (nonatomic,weak) IBOutlet UILabel *titleLabel;
@property (nonatomic,weak) IBOutlet UIView  *lineView;

@property (nonatomic,strong) UIView         *infoView;
@property (nonatomic,strong) UIView         *scocialView;
@property (nonatomic,strong) UIView         *evaluationView;
@property (nonatomic,strong) UIView         *dataView;
@property (nonatomic,strong) UIView         *orgView;
@property (nonatomic,strong) UIView         *settingView;

@property (nonatomic,strong) UILabel        *infoLabel;
@property (nonatomic,strong) UILabel        *scocialLabel;
@property (nonatomic,strong) UILabel        *evaluationLabel;
@property (nonatomic,strong) UILabel        *dataLabel;
@property (nonatomic,strong) UILabel        *orgLabel;
@property (nonatomic,strong) UILabel        *settingLabel;

@property (nonatomic,strong) UIImageView    *infoImage;
@property (nonatomic,strong) UIImageView    *scocialImage;
@property (nonatomic,strong) UIImageView    *evaluationImage;
@property (nonatomic,strong) UIImageView    *dataImage;
@property (nonatomic,strong) UIImageView    *orgImage;
@property (nonatomic,strong) UIImageView    *settingImage;

@property (nonatomic,assign) NSInteger length;
@end

@implementation CustomerDeepViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"深度管理";
    [self setupView];
}

- (void)setupView{
    _length = kMainWidth / 3;
    NSInteger imageSize = _length / 2;
    _infoView = [[UIView alloc] initWithFrame:CGRectMake(0, 226, _length, _length)];
    [self.view addSubview:_infoView];
    _infoView.sd_layout
    .topSpaceToView(_lineView,0);
    _infoImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"customer_info_nor"]];
    [_infoView addSubview:_infoImage];
    _infoImage.sd_layout.centerXEqualToView(_infoView).heightIs(imageSize).widthIs(imageSize).topSpaceToView(_infoView,imageSize / 4);
    _infoLabel = [UILabel new];
    _infoLabel.text = @"个人信息";
    _infoLabel.textAlignment = NSTextAlignmentCenter;
    _infoLabel.font = [UIFont systemFontOfSize:15];
    [_infoView addSubview:_infoLabel];
    _infoLabel.sd_layout.centerXEqualToView(_infoView).heightIs(imageSize / 2).widthIs(_length).topSpaceToView(_infoImage,0);
    UILongPressGestureRecognizer *gesturRecognizer1=[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(infoClicked:)];
    gesturRecognizer1.minimumPressDuration = 0;
    [_infoView addGestureRecognizer:gesturRecognizer1];
    
    _scocialView = [[UIView alloc] initWithFrame:CGRectMake(_length, 226, _length, _length)];
    [self.view addSubview:_scocialView];
    _scocialView.sd_layout.topSpaceToView(_lineView,0).leftSpaceToView(_infoView,0);
    _scocialImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"customer_scoical_nor"]];
    [_scocialView addSubview:_scocialImage];
    _scocialImage.sd_layout.centerXEqualToView(_scocialView).heightIs(imageSize).widthIs(imageSize).topSpaceToView(_scocialView,imageSize / 4);
    _scocialLabel = [UILabel new];
    _scocialLabel.text = @"社交账号";
    _scocialLabel.textAlignment = NSTextAlignmentCenter;
    _scocialLabel.font = [UIFont systemFontOfSize:15];
    [_scocialView addSubview:_scocialLabel];
    _scocialLabel.sd_layout.centerXEqualToView(_scocialView).heightIs(imageSize / 2).widthIs(_length).topSpaceToView(_scocialImage,0);
    UILongPressGestureRecognizer *gesturRecognizer2=[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(scoicalClicked:)];
    gesturRecognizer2.minimumPressDuration = 0;
    [_scocialView addGestureRecognizer:gesturRecognizer2];
    
    _evaluationView = [[UIView alloc] initWithFrame:CGRectMake(_length * 2, 226, _length, _length)];
    [self.view addSubview:_evaluationView];
    _evaluationView.sd_layout.topSpaceToView(_lineView,0);
    _evaluationImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"customer_evaluation_nor"]];
    [_evaluationView addSubview:_evaluationImage];
    _evaluationImage.sd_layout.centerXEqualToView(_evaluationView).heightIs(imageSize).widthIs(imageSize).topSpaceToView(_evaluationView,imageSize / 4);
    _evaluationLabel = [UILabel new];
    _evaluationLabel.text = @"评估";
    _evaluationLabel.textAlignment = NSTextAlignmentCenter;
    _evaluationLabel.font = [UIFont systemFontOfSize:15];
    [_evaluationView addSubview:_evaluationLabel];
    _evaluationLabel.sd_layout.centerXEqualToView(_evaluationView).heightIs(imageSize / 2).widthIs(_length).topSpaceToView(_evaluationImage,0);
    UILongPressGestureRecognizer *gesturRecognizer3=[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(evaluationClicked:)];
    gesturRecognizer3.minimumPressDuration = 0;
    [_evaluationView addGestureRecognizer:gesturRecognizer3];
    
    _dataView = [[UIView alloc] initWithFrame:CGRectMake(0, 226+_length, _length, _length)];
    [self.view addSubview:_dataView];
    _dataView.sd_layout.topSpaceToView(_infoView,0);
    _dataImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"customer_data_nor"]];
    [_dataView addSubview:_dataImage];
    _dataImage.sd_layout.centerXEqualToView(_dataView).heightIs(imageSize).widthIs(imageSize).topSpaceToView(_dataView,imageSize / 4);
    _dataLabel = [UILabel new];
    _dataLabel.text = @"数据挖掘";
    _dataLabel.textAlignment = NSTextAlignmentCenter;
    _dataLabel.font = [UIFont systemFontOfSize:15];
    [_dataView addSubview:_dataLabel];
    _dataLabel.sd_layout.centerXEqualToView(_dataView).heightIs(imageSize / 2).widthIs(_length).topSpaceToView(_dataImage,0);
    UILongPressGestureRecognizer *gesturRecognizer4=[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(dataClicked:)];
    gesturRecognizer4.minimumPressDuration = 0;
    [_dataView addGestureRecognizer:gesturRecognizer4];
    
    _orgView = [[UIView alloc] initWithFrame:CGRectMake(_length, 226+_length, _length, _length)];
    [self.view addSubview:_orgView];
    _orgView.sd_layout.topSpaceToView(_scocialView,0).leftSpaceToView(_dataView,0);
    _orgImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"customer_org_nor"]];
    [_orgView addSubview:_orgImage];
    _orgImage.sd_layout.centerXEqualToView(_orgView).heightIs(imageSize).widthIs(imageSize).topSpaceToView(_orgView,imageSize / 4);
    _orgLabel = [UILabel new];
    _orgLabel.text = @"数据机构挖掘";
    _orgLabel.textAlignment = NSTextAlignmentCenter;
    _orgLabel.font = [UIFont systemFontOfSize:15];
    [_orgView addSubview:_orgLabel];
    _orgLabel.sd_layout.centerXEqualToView(_orgView).heightIs(imageSize / 2).widthIs(_length).topSpaceToView(_orgImage,0);
    UILongPressGestureRecognizer *gesturRecognizer5=[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(orgClicked:)];
    gesturRecognizer5.minimumPressDuration = 0;
    [_orgView addGestureRecognizer:gesturRecognizer5];
    
    _settingView = [[UIView alloc] initWithFrame:CGRectMake(_length*2, 226+_length, _length, _length)];
    [self.view addSubview:_settingView];
    _settingView.sd_layout.topSpaceToView(_evaluationView,0).leftSpaceToView(_orgView,0);
    _settingImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"customer_setting_nor"]];
    [_settingView addSubview:_settingImage];
    _settingImage.sd_layout.centerXEqualToView(_settingView).heightIs(imageSize).widthIs(imageSize).topSpaceToView(_settingView,imageSize / 4);
    _settingLabel = [UILabel new];
    _settingLabel.text = @"设置";
    _settingLabel.textAlignment = NSTextAlignmentCenter;
    _settingLabel.font = [UIFont systemFontOfSize:15];
    [_settingView addSubview:_settingLabel];
    _settingLabel.sd_layout.centerXEqualToView(_settingView).heightIs(imageSize / 2).widthIs(_length).topSpaceToView(_settingImage,0);
    UILongPressGestureRecognizer *gesturRecognizer6=[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(settingClicked:)];
    gesturRecognizer6.minimumPressDuration = 0;
    [_settingView addGestureRecognizer:gesturRecognizer6];
}
- (void)setCustomer:(Customer *)customer{
    _customer = customer;
    [self setupData];
}

- (void)setupData{
    if ([NSStringUtils isEmpty:_customer.name]) {
        _nameLabel.text = @"  ";
    }else{
        _nameLabel.text = _customer.name;
    }
    if ([NSStringUtils isEmpty:_customer.company]) {
        _companyLabel.text = @"  ";
    }else{
        _companyLabel.text = _customer.company;
    }
    if ([NSStringUtils isEmpty:_customer.title]) {
        _titleLabel.text = @"  ";
    }else{
        _titleLabel.text = _customer.title;
    }
    if (_customer.sex == 0) {
        _sexLabel.text = @"男";
    }else{
        _sexLabel.text = @"女";
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)infoClicked:(UITapGestureRecognizer *)rec{
    if (rec.state == UIGestureRecognizerStateBegan) {
        _infoImage.image = [UIImage imageNamed:@"customer_info_cover"];
    }else if(rec.state == UIGestureRecognizerStateEnded){
        NSLog(@"infoClicked");
        _infoImage.image = [UIImage imageNamed:@"customer_info_nor"];
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Customer" bundle:nil];
        
        CustomerInfoViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"CustomerInfo"];
        vc.hidesBottomBarWhenPushed = YES;
        vc.view.backgroundColor = [UIColor whiteColor];
        vc.customer = _customer;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)scoicalClicked:(UITapGestureRecognizer *)rec{
    if (rec.state == UIGestureRecognizerStateBegan) {
        _scocialImage.image = [UIImage imageNamed:@"customer_scoical_cover"];
    }else if(rec.state == UIGestureRecognizerStateEnded){
        _scocialImage.image = [UIImage imageNamed:@"customer_scoical_nor"];
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Customer" bundle:nil];
        
        CustomerSocialViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"CustomerSocial"];
        vc.hidesBottomBarWhenPushed = YES;
        vc.view.backgroundColor = [UIColor whiteColor];
        vc.customer = _customer;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)evaluationClicked:(UITapGestureRecognizer *)rec{
    if (rec.state == UIGestureRecognizerStateBegan) {
        _evaluationImage.image = [UIImage imageNamed:@"customer_evaluation_cover"];
    }else if(rec.state == UIGestureRecognizerStateEnded){
        _evaluationImage.image = [UIImage imageNamed:@"customer_evaluation_nor"];
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Customer" bundle:nil];
        
        CustomerEvaluationViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"CustomerEvaluation"];
        vc.hidesBottomBarWhenPushed = YES;
        vc.view.backgroundColor = [UIColor whiteColor];
        vc.customer = _customer;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)dataClicked:(UITapGestureRecognizer *)rec{
    if (rec.state == UIGestureRecognizerStateBegan) {
        _dataImage.image = [UIImage imageNamed:@"customer_data_cover"];
    }else if(rec.state == UIGestureRecognizerStateEnded){
        NSLog(@"dataClicked");
        _dataImage.image = [UIImage imageNamed:@"customer_data_nor"];
    }
}

- (void)orgClicked:(UITapGestureRecognizer *)rec{
    if (rec.state == UIGestureRecognizerStateBegan) {
        _orgImage.image = [UIImage imageNamed:@"customer_org_cover"];
    }else if(rec.state == UIGestureRecognizerStateEnded){
        NSLog(@"orgClicked");
        _orgImage.image = [UIImage imageNamed:@"customer_org_nor"];
    }
}

- (void)settingClicked:(UITapGestureRecognizer *)rec{
    if (rec.state == UIGestureRecognizerStateBegan) {
        _settingImage.image = [UIImage imageNamed:@"customer_setting_cover"];
    }else if(rec.state == UIGestureRecognizerStateEnded){
        _settingImage.image = [UIImage imageNamed:@"customer_setting_nor"];
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Customer" bundle:nil];
        
        CustomerSettingViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"CustomerSetting"];
        vc.hidesBottomBarWhenPushed = YES;
        vc.view.backgroundColor = [UIColor whiteColor];
        vc.customer = _customer;
        [self.navigationController pushViewController:vc animated:YES];
    }
}
@end
