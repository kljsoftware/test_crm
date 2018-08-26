//
//  ReqFriendDbUtil.h
//  sales
//
//  Created by user on 2017/3/9.
//  Copyright © 2017年 rayootech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Contact.h"

@interface ReqFriendDbUtil : NSObject

@property (nonatomic,strong) FMDatabase *db;
@property (nonatomic,strong) NSString *createTableSql;

-(void)insertContact:(Contact *)contact;
-(NSMutableArray *)selectAll;
-(Contact *)selectUserById:(NSInteger )fid;
-(Contact *)selectContactById:(NSInteger )id;
-(void)updateContact:(Contact *)contact;
-(void)deleteContactById:(NSInteger)id;
-(NSMutableArray *)selectAllFriends;
@end
