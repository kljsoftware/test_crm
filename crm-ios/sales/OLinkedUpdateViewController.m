//
//  OLinkedUpdateViewController.m
//  sales
//
//  Created by user on 2017/4/24.
//  Copyright © 2017年 rayootech. All rights reserved.
//

#import "OLinkedUpdateViewController.h"

@interface OLinkedUpdateViewController ()

@property (nonatomic,weak) IBOutlet UITextField          *linkedText;

@end

@implementation OLinkedUpdateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Linked";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(sureButtonClicked)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setModel:(NSString *)model{
    _model = model;
    _linkedText.text = model;
}

- (void)sureButtonClicked{
    [_delegate linkedUpdate:_linkedText.text];
    if (self.navigationController.viewControllers.count <= 1) {
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

@end
