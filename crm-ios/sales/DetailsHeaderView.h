//
//  DetailsHeaderView.h
//  sales
//
//  Created by user on 2016/11/23.
//  Copyright © 2016年 rayootech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Circle.h"

@interface DetailsHeaderView : UIView
@property (nonatomic,strong) Circle *model;

@property (nonatomic, strong) NSIndexPath *indexPath;

@end
