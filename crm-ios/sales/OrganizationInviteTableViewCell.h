//
//  OrganizationInviteTableViewCell.h
//  sales
//
//  Created by user on 2017/3/17.
//  Copyright © 2017年 rayootech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrgInvite.h"
@protocol OrgInviteCellDelegate <NSObject>

-(void) agreeDidClick:(OrgInvite *)orgInvite index:(NSIndexPath *)indexPath;

@end
@interface OrganizationInviteTableViewCell : UITableViewCell

@property (nonatomic,strong) OrgInvite *model;

+ (CGFloat)fixedHeight;
@property (nonatomic, strong) NSIndexPath *index;
@property (nonatomic,assign) id <OrgInviteCellDelegate> delegate;
@end
