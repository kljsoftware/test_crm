//
//  ServiceNo.h
//  sales
//
//  Created by user on 2017/2/9.
//  Copyright © 2017年 rayootech. All rights reserved.
//

#import "BaseModel.h"

@interface ServiceNo : BaseModel

@property (nonatomic,assign) NSInteger id;

@property (nonatomic,assign) NSInteger status;

@property (nonatomic,assign) NSInteger sentTime;

@property (nonatomic,copy) NSString *content;

@property (nonatomic,copy) NSString *department;

@property (nonatomic,copy) NSString *contenturl;

@property (nonatomic,copy) NSMutableArray *detailList;

@end
