//
//  Work.h
//  sales
//
//  Created by user on 2017/4/10.
//  Copyright © 2017年 rayootech. All rights reserved.
//

#import "BaseModel.h"

@interface Work : BaseModel <NSCoding>

@property (nonatomic,assign) NSInteger id;

@property (nonatomic,assign) NSInteger worktype;

@property (nonatomic,assign) NSInteger type;// 2下属 3参与 1我的

@property (nonatomic,copy) NSString *content;

@property (nonatomic,assign) NSInteger uid;

@property (nonatomic,copy) NSString *user;

@property (nonatomic,copy) NSString *picurl;

@property (nonatomic,assign) NSInteger status;      //该工作是否被删除，1没有，0删除

@property (nonatomic,copy) NSString *worktime;

@property (nonatomic,copy) NSString *address;

@property (nonatomic,assign) NSInteger favstatus;   //是否点赞过，0没有

@property (nonatomic,assign) NSInteger favnum;      //点赞数

@property (nonatomic,copy) NSString *colleaguelist;

@property (nonatomic,copy) NSString *commentlist;

@property (nonatomic,copy) NSString *avatar;

@property (nonatomic,copy) NSString *customerName;

@property (nonatomic,copy) NSString *customerList;

@property (nonatomic,copy) NSMutableArray *workCommentsList;

@property (nonatomic,copy) NSMutableArray *staffList;

@property (nonatomic,strong) NSMutableArray *workCommentsIds;// 未读评论id列表

@property (nonatomic,assign) NSInteger counts;  //未读评论计数

@property (nonatomic,assign) BOOL isOpening;

@property (nonatomic, assign, readonly) BOOL shouldShowMoreButton;

@end
