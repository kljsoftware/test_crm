//
//  BlackBoard.h
//  sales
//
//  Created by user on 2017/2/14.
//  Copyright © 2017年 rayootech. All rights reserved.
//

#import "BaseModel.h"

@interface BlackBoard : BaseModel

@property (nonatomic,assign) NSInteger id;

@property (nonatomic,assign) NSInteger uid;

@property (nonatomic,copy) NSString *img;

@property (nonatomic,copy) NSString *uname;

@property (nonatomic,copy) NSString *content;

@property (nonatomic,copy) NSString *posttime;

@property (nonatomic,copy) NSString *avatar;

@property (nonatomic,assign) BOOL isOpening;

@property (nonatomic, assign, readonly) BOOL shouldShowMoreButton;

@property (nonatomic,strong) NSMutableArray *bbCommentsList;

@property (nonatomic,assign) NSInteger favnum;

@property (nonatomic,assign) NSInteger favstatus;

@end
