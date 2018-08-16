//
//  BlackBoardDetailsHeaderView.h
//  sales
//
//  Created by user on 2017/2/15.
//  Copyright © 2017年 rayootech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BlackBoard.h"
@interface BlackBoardDetailsHeaderView : UIView

@property (nonatomic,strong) BlackBoard *model;

@property (nonatomic, strong) NSIndexPath *indexPath;

@end
