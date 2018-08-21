//
//  ContactDetailsViewController.h
//  sales
//
//  Created by user on 2016/12/5.
//  Copyright © 2016年 rayootech. All rights reserved.
//

#import "BaseTableViewController.h"
#import "Contact.h"
@interface ContactDetailsViewController : BaseTableViewController
@property (nonatomic,strong) Contact *contact;

- (instancetype)initWithContact:(Contact *)contact;

@end
