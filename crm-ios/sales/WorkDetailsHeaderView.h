//
//  WorkDetailsHeaderView.h
//  sales
//
//  Created by user on 2017/4/11.
//  Copyright © 2017年 rayootech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Work.h"
@interface WorkDetailsHeaderView : UIView
@property (nonatomic,strong) Work *model;

@property (nonatomic, strong) NSIndexPath *indexPath;
@end
