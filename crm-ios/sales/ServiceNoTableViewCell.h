//
//  ServiceNoTableViewCell.h
//  sales
//
//  Created by user on 2017/2/9.
//  Copyright © 2017年 rayootech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ServiceNo.h"

@protocol ServiceNoCellDelegate <NSObject>

- (void)dealService:(NSIndexPath *)index status:(NSInteger)status;

@end

@interface ServiceNoTableViewCell : UITableViewCell

@property (nonatomic, strong) ServiceNo *model;

@property (nonatomic,assign) id <ServiceNoCellDelegate> delegate;

@property (nonatomic, strong) NSIndexPath *index;

@end
