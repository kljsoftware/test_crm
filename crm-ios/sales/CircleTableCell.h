//
//  CircleTableCell.h
//  sales
//
//  Created by user on 2016/11/11.
//  Copyright © 2016年 rayootech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Circle.h"

@protocol CircleCellDelegate <NSObject>

-(void) deleteClick:(NSIndexPath *)indexPath;

@end

@interface CircleTableCell : UITableViewCell

@property (nonatomic,strong) Circle *model;

@property (nonatomic, strong) NSIndexPath *indexPath;

@property (nonatomic, copy) void (^moreButtonClickedBlock)(NSIndexPath *indexPath);

@property (nonatomic,assign) id <CircleCellDelegate> delegate;

@end
