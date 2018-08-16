//
//  ONameUpdateViewController.m
//  sales
//
//  Created by user on 2017/4/24.
//  Copyright © 2017年 rayootech. All rights reserved.
//

#import "ONameUpdateViewController.h"

@interface ONameUpdateViewController ()

@property (nonatomic,weak) IBOutlet UITextField          *nameText;

@end

@implementation ONameUpdateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"名称";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(sureButtonClicked)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setModel:(NSString *)model{
    _model = model;
    _nameText.text = model;
}

- (void)sureButtonClicked{
    [_delegate nameUpdate:_nameText.text];
    if (self.navigationController.viewControllers.count <= 1) {
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

@end
