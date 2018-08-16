//
//  Organization.h
//  sales
//
//  Created by user on 2016/12/30.
//  Copyright © 2016年 rayootech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseModel.h"
@interface Organizations : BaseModel

@property (nonatomic,assign) NSInteger id;

@property (nonatomic,assign) NSInteger dbid;

@property (nonatomic,copy) NSString *name;

@property (nonatomic,copy) NSString *logo;

@property (nonatomic,copy) NSString *creater;

@property (nonatomic,copy) NSString *Description;

@property (nonatomic,assign) NSInteger createuser;

@end
