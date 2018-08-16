//
//  User.h
//  sales
//
//  Created by user on 2016/11/7.
//  Copyright © 2016年 rayootech. All rights reserved.
//

#import "BaseModel.h"

@interface User : BaseModel

@property (nonatomic,strong) NSString *name;

@property (nonatomic,strong) NSString *avatar;

@property (nonatomic,assign) NSInteger id;

@property (nonatomic,strong) NSString *token;

@property (nonatomic,strong) NSString *rotoken;

@property (nonatomic,strong) NSString *mobile;

@property (nonatomic,strong) NSString *linkedin;

@property (nonatomic,strong) NSString *area;

@property (nonatomic,strong) NSString *weibo;

@property (nonatomic,strong) NSString *email;

@property (nonatomic,strong) NSString *sex;

@property (nonatomic,strong) NSString *wechat;

@property (nonatomic,strong) NSString *Description;

@property (nonatomic,strong) User *data;

@end
