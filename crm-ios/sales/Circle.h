//
//  Circle.h
//  sales
//
//  Created by user on 2016/11/11.
//  Copyright © 2016年 rayootech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Comment.h"
#import "BaseModel.h"
#import <MJExtension.h>

@interface Circle : BaseModel

@property (nonatomic,assign) NSInteger id;

@property (nonatomic,assign) NSInteger uid;

@property (nonatomic,copy) NSString *uname;

@property (nonatomic,copy) NSString *avatar;

@property (nonatomic,copy) NSString *content;

@property (nonatomic,copy) NSString *publishtime;

@property (nonatomic,copy) NSString *picurl;

@property (nonatomic,assign) BOOL isOpening;

@property (nonatomic, assign, readonly) BOOL shouldShowMoreButton;

@property (nonatomic,copy) NSMutableArray *commentsList;

@property (nonatomic,assign) NSInteger favstatus;

@property (nonatomic,assign) NSInteger favnum;

@end

