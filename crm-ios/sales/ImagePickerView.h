//
//  ImagePickerView.h
//  sales
//
//  Created by user on 2016/11/24.
//  Copyright © 2016年 rayootech. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ImagePickerConfig;
@interface ImagePickerView : UIView

@property (nonatomic, strong) UINavigationController *navigationController;
@property (nonatomic, copy) void(^viewHeightChanged)(CGFloat height);

- (instancetype)initWithFrame:(CGRect)frame config:(ImagePickerConfig *)config;
- (void)refreshImagePickerViewWithPhotoArray:(NSArray<UIImage *> *)array;
- (NSArray<UIImage *> *)getPhotos;
@end

@interface ImagePickerConfig : NSObject

@property (nonatomic, assign) CGSize itemSize; //每张图片的缩略图尺寸 默认CGSizeMake(60, 60);
@property (nonatomic, assign) UIEdgeInsets sectionInset; //距离上下左右的边距 默认UIEdgeInsetsMake(10, 10, 10, 10);
@property (nonatomic, assign) CGFloat minimumLineSpacing; //最小行高 默认10.0f;
@property (nonatomic, assign) CGFloat minimumInteritemSpacing; //最小列宽 默认10.0f;
@property (nonatomic, assign) NSInteger photosMaxCount; //最多选择照片张数 默认9张
@end
