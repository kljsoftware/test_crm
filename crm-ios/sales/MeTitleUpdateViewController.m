//
//  MeTitleUpdateViewController.m
//  sales
//
//  Created by user on 2017/4/26.
//  Copyright © 2017年 rayootech. All rights reserved.
//

#import "MeTitleUpdateViewController.h"

@interface MeTitleUpdateViewController ()

@property (nonatomic,weak) IBOutlet UITextField          *titleText;

@end

@implementation MeTitleUpdateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"职位";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(sureButtonClicked)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setModel:(NSString *)model{
    _model = model;
    _titleText.text = model;
}

- (void)sureButtonClicked{
    [_delegate titleUpdate:_titleText.text];
    if (self.navigationController.viewControllers.count <= 1) {
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}
@end
