//
//  Contact.h
//  sales
//
//  Created by user on 2016/11/8.
//  Copyright © 2016年 rayootech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseModel.h"
@interface Contact : BaseModel

@property (nonatomic,assign) NSInteger id;

@property (nonatomic,assign) NSInteger fid;

@property (nonatomic,copy) NSString *name;

@property (nonatomic,copy) NSString *avatar;

@property (nonatomic,copy) NSString *mobile;

@property (nonatomic,copy) NSString *orgname;

@property (nonatomic,copy) NSString *tel;

@property (nonatomic,copy) NSString *title;

@property (nonatomic,copy) NSString *dept;

@property (nonatomic,copy) NSString *mail;

@property (nonatomic,copy) NSString *address;

@property (nonatomic,copy) NSString *website;

@property (nonatomic,copy) NSString *remark;

@property (nonatomic,assign) NSUInteger status;

@property (nonatomic,assign) NSInteger relation;

@property (nonatomic,assign) NSInteger recevied;

@end
