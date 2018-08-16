//
//  BlackBoardTableViewCell.h
//  sales
//
//  Created by user on 2017/2/14.
//  Copyright © 2017年 rayootech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BlackBoard.h"
@protocol BlackBoardCellDelegate <NSObject>

-(void) deleteClick:(NSIndexPath *)indexPath;

-(void) commentClick:(NSIndexPath *)indexPath;

@end
@interface BlackBoardTableViewCell : UITableViewCell

@property (nonatomic,strong) BlackBoard *model;

@property (nonatomic, strong) NSIndexPath *indexPath;

@property (nonatomic, copy) void (^moreButtonClickedBlock)(NSIndexPath *indexPath);

@property (nonatomic,assign) id <BlackBoardCellDelegate> delegate;

@end
