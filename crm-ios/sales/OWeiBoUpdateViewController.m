//
//  OWeiBoUpdateViewController.m
//  sales
//
//  Created by user on 2017/4/24.
//  Copyright © 2017年 rayootech. All rights reserved.
//

#import "OWeiBoUpdateViewController.h"

@interface OWeiBoUpdateViewController ()

@property (nonatomic,weak) IBOutlet UITextField          *weiboText;

@end

@implementation OWeiBoUpdateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"微博";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(sureButtonClicked)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setModel:(NSString *)model{
    _model = model;
    _weiboText.text = model;
}

- (void)sureButtonClicked{
    [_delegate weiboUpdate:_weiboText.text];
    if (self.navigationController.viewControllers.count <= 1) {
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

@end
