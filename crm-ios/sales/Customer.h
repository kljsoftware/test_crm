//
//  Customer.h
//  sales
//
//  Created by user on 2017/2/15.
//  Copyright © 2017年 rayootech. All rights reserved.
//

#import "BaseModel.h"

@interface Customer : BaseModel

@property (nonatomic,assign) NSInteger id;

@property (nonatomic,copy) NSString *name;

@property (nonatomic,copy) NSString *avatar;

@property (nonatomic,copy) NSString *mobile;

@property (nonatomic,copy) NSString *title;

@property (nonatomic,copy) NSString *department;

@property (nonatomic,copy) NSString *tel;

@property (nonatomic,copy) NSString *mail;

@property (nonatomic,copy) NSString *address;

@property (nonatomic,copy) NSString *website;

@property (nonatomic,copy) NSString *remark;

@property (nonatomic,copy) NSString *company;

@property (nonatomic,assign) NSInteger age;

@property (nonatomic,assign) NSInteger sex; // 0 man

@property (nonatomic,copy) NSString *hometown;

@property (nonatomic,copy) NSString *school;

@property (nonatomic,copy) NSString *specialty;

@property (nonatomic,copy) NSString *likes;

@property (nonatomic,copy) NSString *homeaddress;

@property (nonatomic,copy) NSString *homeinfo;

@property (nonatomic,assign) NSInteger status;

@property (nonatomic,copy) NSString *owner;

@property (nonatomic,copy) NSString *uname;

@property (nonatomic,copy) NSString *type;

@property (nonatomic,assign) NSInteger updatetime;

@end
