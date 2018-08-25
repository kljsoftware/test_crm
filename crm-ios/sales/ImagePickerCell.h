//
//  ImagePickerCell.h
//  sales
//
//  Created by Sunny on 2018/8/25.
//  Copyright © 2018年 rayootech. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ImagePickerCellBlock)(NSIndexPath *indexPath);

@interface ImagePickerCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) UIButton *deleteBtn;
@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, copy) ImagePickerCellBlock deleteBlock;

@end
