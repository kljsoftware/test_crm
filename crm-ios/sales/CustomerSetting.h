//
//  CustomerSetting.h
//  sales
//
//  Created by user on 2017/2/24.
//  Copyright © 2017年 rayootech. All rights reserved.
//

#import "BaseModel.h"

@interface CustomerSetting : BaseModel

@property (nonatomic,copy) NSString *owner;

@property (nonatomic,copy) NSString *createtime;

@property (nonatomic,copy) NSString *modifytime;

@property (nonatomic,copy) NSMutableArray *historyList;

@end
