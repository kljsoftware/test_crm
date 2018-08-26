//
//  CCSegmentControl.h
//  自定义segment
//
//  Created by Sunny on 17/11/12.
//  Copyright (c) 2017年 合作喵. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^CCSegmentBlock)(NSInteger index);

// Segment视图
@interface CCSegmentView : UIView

@property (nonatomic, copy) CCSegmentBlock segmentBlock; // 点击回调

- (instancetype)initWithTitles:(NSArray *)titles normalColor:(UIColor *)normalColor selectColor:(UIColor *)selectColor;
- (void)setIndex:(NSInteger)index;

@end
