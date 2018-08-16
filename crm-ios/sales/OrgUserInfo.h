//
//  OrgUserInfo.h
//  sales
//
//  Created by user on 2017/1/4.
//  Copyright © 2017年 rayootech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseModel.h"
@interface OrgUserInfo : BaseModel

@property (nonatomic,assign) NSInteger id;

@property (nonatomic,copy) NSString *name;

@property (nonatomic,copy) NSString *avatar;

@property (nonatomic,copy) NSString *mobile;

@property (nonatomic,assign) NSInteger status;

@property (nonatomic,assign) NSInteger sex;

@property (nonatomic,copy) NSString *area;

@property (nonatomic,copy) NSString *email;

@property (nonatomic,copy) NSString *wechat;

@property (nonatomic,copy) NSString *title;

@property (nonatomic,copy) NSString *rotoken;

@property (nonatomic,copy) NSString *picurl;        //工作中，参与同事avatar，此次字段没有和avatar统一

@property (nonatomic,assign) NSInteger deptparentid;

@property (nonatomic,assign) NSInteger deptid;

@end
