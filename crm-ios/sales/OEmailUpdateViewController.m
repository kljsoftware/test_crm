//
//  OEmailUpdateViewController.m
//  sales
//
//  Created by user on 2017/4/24.
//  Copyright © 2017年 rayootech. All rights reserved.
//

#import "OEmailUpdateViewController.h"

@interface OEmailUpdateViewController ()

@property (nonatomic,weak) IBOutlet UITextField         *emailText;

@end

@implementation OEmailUpdateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"邮件";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(sureButtonClicked)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setModel:(NSString *)model{
    _model = model;
    _emailText.text = model;
}

- (void)sureButtonClicked{
    [_delegate emailUpdate:_emailText.text];
    if (self.navigationController.viewControllers.count <= 1) {
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}
@end
