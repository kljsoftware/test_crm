//
//  Active.h
//  sales
//
//  Created by user on 2017/2/14.
//  Copyright © 2017年 rayootech. All rights reserved.
//

#import "BaseModel.h"

@interface Active : BaseModel

@property (nonatomic,assign) NSInteger id;

@property (nonatomic,copy) NSString *title;

@property (nonatomic,copy) NSString *img;

@property (nonatomic,copy) NSString *content;

@property (nonatomic,assign) NSInteger price;

@property (nonatomic,copy) NSString *activetime;

@property (nonatomic,copy) NSString *content_url;

@property (nonatomic,copy) NSString *crom;

@end
