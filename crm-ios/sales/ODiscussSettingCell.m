//
//  ODiscussSettingCell.m
//  sales
//
//  Created by Sunny on 2018/8/26.
//  Copyright © 2018年 rayootech. All rights reserved.
//

#import "ODiscussSettingCell.h"

@interface ODiscussSettingCell () <UITextFieldDelegate>

@end

@implementation ODiscussSettingCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    _contentTF.inputAccessoryView = [self createToolbar];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (UIToolbar *)createToolbar{
    
    UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, KSCREEN_SIZE.width, 44)];
    UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *done = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(textFieldDone)];
    
    toolBar.items = @[space, done];
    return toolBar;
}

- (void)textFieldDone {
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
    if (self.block) {
        self.block(self.indexPath, self.contentTF.text);
    }
}

@end
