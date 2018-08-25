//
//  ImagePickerCell.m
//  sales
//
//  Created by Sunny on 2018/8/25.
//  Copyright © 2018年 rayootech. All rights reserved.
//

#import "ImagePickerCell.h"

@implementation ImagePickerCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createCell];
    }
    return self;
}

- (void)createCell {
    
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:self.bounds];
    imgView.contentMode = UIViewContentModeScaleAspectFill;
    imgView.clipsToBounds = YES;
    [self.contentView addSubview:imgView];
    self.imgView = imgView;
    
    UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    deleteBtn.frame = CGRectMake(self.bounds.size.width-20, 0, 20, 20);
    deleteBtn.hidden = true;
    [deleteBtn setImage:[UIImage imageNamed:@"delete_member_tip"] forState:UIControlStateNormal];
    [deleteBtn addTarget:self action:@selector(deleteClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:deleteBtn];
    self.deleteBtn = deleteBtn;
}

- (void)deleteClicked:(UIButton *)sender {
    if (self.deleteBlock) {
        self.deleteBlock(self.indexPath);
    }
}

@end
