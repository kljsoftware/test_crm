//
//  ContactTableViewCell.h
//  sales
//
//  Created by user on 2016/11/9.
//  Copyright © 2016年 rayootech. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Contact;

@protocol ContactCellDelegate <NSObject>

-(void) userPortraitDidClick;

-(void) userChatDidClick:(Contact *)contact;

@end

@interface ContactTableViewCell : UITableViewCell

@property (nonatomic,strong) Contact *model;

+ (CGFloat)fixedHeight;

@property (nonatomic,assign) id <ContactCellDelegate> delegate;

@end
