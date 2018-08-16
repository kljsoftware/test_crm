//
//  Comment.h
//  sales
//
//  Created by user on 2016/11/16.
//  Copyright © 2016年 rayootech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseModel.h"

@interface Comment : BaseModel <NSCoding>

@property (nonatomic,assign) NSInteger id;

@property (nonatomic,assign) NSInteger buid;

@property (nonatomic,assign) NSInteger toid;

@property (nonatomic,assign) NSInteger uid;

@property (nonatomic,copy) NSString *comment;

@property (nonatomic,copy) NSString *uname;

@property (nonatomic,copy) NSString *bname;

@property (nonatomic,copy) NSString *bcomment;

@property (nonatomic,copy) NSString *avatar;

@property (nonatomic,copy) NSString *publishtime;

@property (nonatomic,copy) NSString *createtime;

@property (nonatomic,copy) NSAttributedString *attributedContent;

@property (nonatomic,strong) NSMutableArray *integerList;

@property (nonatomic,assign) NSInteger counts;

@property (nonatomic,copy) NSString *content;

@property (nonatomic,strong) NSMutableArray *commentsidlist;

@property (nonatomic,assign) NSInteger favnum;

@property (nonatomic,assign) NSInteger favstatus;

@end
