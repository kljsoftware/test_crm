//
//  News.h
//  sales
//
//  Created by user on 2017/2/8.
//  Copyright © 2017年 rayootech. All rights reserved.
//

#import "BaseModel.h"

@interface News : BaseModel

@property (nonatomic,assign) NSInteger id;

@property (nonatomic,copy) NSString *img;

@property (nonatomic,copy) NSString *title;

@property (nonatomic,copy) NSString *content;

@property (nonatomic,copy) NSString *createtime;

@property (nonatomic,copy) NSString *source;

@end
