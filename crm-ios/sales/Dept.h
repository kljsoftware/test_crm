//
//  Dept.h
//  sales
//
//  Created by user on 2017/4/17.
//  Copyright © 2017年 rayootech. All rights reserved.
//

#import "BaseModel.h"

@interface Dept : BaseModel

@property (nonatomic,assign) NSInteger id;

@property (nonatomic,copy) NSString *departname;

@property (nonatomic,assign) NSInteger parentid;

@end
