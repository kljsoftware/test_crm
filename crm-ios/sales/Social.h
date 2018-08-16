//
//  Social.h
//  sales
//
//  Created by user on 2017/2/23.
//  Copyright © 2017年 rayootech. All rights reserved.
//

#import "BaseModel.h"

@interface Social : BaseModel

@property (nonatomic,assign) NSInteger type;

@property (nonatomic,copy) NSString *typename;

@property (nonatomic,copy) NSString *account;

@end
