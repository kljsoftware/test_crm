//
//  ODescUpdateViewController.m
//  sales
//
//  Created by user on 2017/4/24.
//  Copyright © 2017年 rayootech. All rights reserved.
//

#import "ODescUpdateViewController.h"

@interface ODescUpdateViewController ()

@property (nonatomic,weak) IBOutlet UITextField             *descText;

@end

@implementation ODescUpdateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"描述";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(sureButtonClicked)];}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setModel:(NSString *)model{
    _model = model;
    _descText.text = model;
}

- (void)sureButtonClicked{
    [_delegate descUpdate:_descText.text];
    if (self.navigationController.viewControllers.count <= 1) {
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

@end
