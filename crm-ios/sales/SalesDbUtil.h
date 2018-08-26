//
//  SalesDbUtil.h
//  sales
//
//  Created by user on 2016/11/10.
//  Copyright © 2016年 rayootech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Contact.h"

@interface SalesDbUtil : NSObject

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
