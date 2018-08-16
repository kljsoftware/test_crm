//
//  ReqFriendDbUtil.m
//  sales
//
//  Created by user on 2017/3/9.
//  Copyright © 2017年 rayootech. All rights reserved.
//

#import "ReqFriendDbUtil.h"
#import "Config.h"
#define PATH_OF_DOCUMENT    [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]
@implementation ReqFriendDbUtil

-(instancetype)init{
    self = [super init];
    if (self) {
        NSLog(@"----%@",PATH_OF_DOCUMENT);
        NSString *dbname = [@"out_" stringByAppendingString:[NSString stringWithFormat:@"%lld",[Config getOwnID]]];
        _db = [FMDatabase databaseWithPath:[PATH_OF_DOCUMENT stringByAppendingPathComponent:dbname]];
        _createTableSql = @"CREATE TABLE IF NOT EXISTS 'TABLE_REQFRIEND' ('_id' INTEGER PRIMARY KEY AUTOINCREMENT, 'id' INTEGER,  'avatar' TEXT, 'name' TEXT, 'recevied' INTEGER)";
        [self createTableIfNotExists:_createTableSql];
    }
    return self;
}

-(bool)createTableIfNotExists:(NSString *)sqlCreateTable
{
    if ([_db open]) {
        BOOL res = [_db executeUpdate:sqlCreateTable];
        if (!res) {
            NSLog(@"error when creating db table");
        } else {
            NSLog(@"success to creating db table");
        }
        [_db close];
    }
    return false;
}

-(void)insertContact:(Contact *)contact{
    if ([_db open]) {
        NSString *insertSql = [NSString stringWithFormat:@"INSERT INTO 'TABLE_REQFRIEND' ('id', 'name', 'avatar', 'recevied') VALUES ('%ld', '%@', '%@', '%ld')",contact.id,contact.name,contact.avatar,contact.recevied];
        
        BOOL res = [_db executeUpdate:insertSql];
        if (!res) {
            NSLog(@"data--insert error");
        }else{
            //            NSLog(@"data--insert ok");
        }
        [_db close];
    }
}

-(NSMutableArray *)selectAll{
    NSMutableArray *result = [[NSMutableArray alloc] init];
    if ([_db open]) {
        NSString *sql = @"SELECT * FROM 'TABLE_REQFRIEND'";
        FMResultSet *rs = [_db executeQuery:sql];
        while ([rs next]) {
            
            Contact *contact = [[Contact alloc] init];
            contact.id = [[rs stringForColumn:@"id"] integerValue];
            contact.avatar = [rs stringForColumn:@"avatar"];
            contact.name = [rs stringForColumn:@"name"];
            contact.recevied = [[rs stringForColumn:@"recevied"] integerValue];
            [result addObject:contact];
        }
        [_db close];
    }else{
        NSLog(@"data-->open error");
    }
    return result;
}
-(Contact *)selectUserById:(NSInteger)id{
    Contact *contact = [Contact new];
    if ([_db open]) {
        NSString *sql = [NSString stringWithFormat:@"SELECT * FROM 'TABLE_REQFRIEND' where id = %ld",id];
        FMResultSet *rs = [_db executeQuery:sql];
        contact.id = 0;
        while ([rs next]) {
            contact.id = [[rs stringForColumn:@"id"] integerValue];
            contact.avatar = [rs stringForColumn:@"avatar"];
            contact.name = [rs stringForColumn:@"name"];
            contact.recevied = [[rs stringForColumn:@"recevied"] integerValue];
        }
        [_db close];
    }
    return contact;
}
- (void) updateContact:(Contact *)contact{
    if ([_db open]) {
        NSString *sql = [NSString stringWithFormat:@"UPDATE 'TABLE_REQFRIEND' SET name = '%@',  recevied = %ld where id = %ld",contact.name,contact.recevied,contact.id];
        Boolean res = [_db executeUpdate:sql];
        NSLog(@"%@",sql);
        if (res) {
            NSLog(@"----update ok");
        }else{
            NSLog(@"---update error");
        }
        [_db close];
    }
}
-(Contact *)selectContactById:(NSInteger)id{
    Contact *contact = [Contact new];
    if ([_db open]) {
        NSString *sql = [NSString stringWithFormat:@"SELECT * FROM 'TABLE_REQFRIEND' where id = %ld",id];
        FMResultSet *rs = [_db executeQuery:sql];
        contact.id = 0;
        while ([rs next]) {
            contact.id = [[rs stringForColumn:@"id"] integerValue];
            contact.avatar = [rs stringForColumn:@"avatar"];
            contact.name = [rs stringForColumn:@"name"];
            
            contact.recevied = [[rs stringForColumn:@"recevied"] integerValue];
        }
        [_db close];
    }
    return contact;
}
- (void)deleteContactById:(NSInteger)id{
    if ([_db open]) {
        NSString *sql = [NSString stringWithFormat:@"delete from 'TABLE_REQFRIEND' where id = %ld",id];
        [_db executeUpdate:sql];
        [_db close];
    }
}

-(NSMutableArray *)selectAllFriends{
    NSMutableArray *result = [[NSMutableArray alloc] init];
    if ([_db open]) {
        NSString *sql = @"SELECT * FROM 'TABLE_REQFRIEND' where fid != 0 and relation = 2";
        FMResultSet *rs = [_db executeQuery:sql];
        while ([rs next]) {
            Contact *contact = [[Contact alloc] init];
            contact.id = [[rs stringForColumn:@"id"] integerValue];
            contact.avatar = [rs stringForColumn:@"avatar"];
            contact.fid = [[rs stringForColumn:@"fid"] integerValue];
            contact.name = [rs stringForColumn:@"name"];
            contact.mobile = [rs stringForColumn:@"mobile"];
            contact.orgname = [rs stringForColumn:@"orgname"];
            contact.title = [rs stringForColumn:@"title"];
            contact.dept = [rs stringForColumn:@"dept"];
            contact.tel = [rs stringForColumn:@"tel"];
            contact.mail = [rs stringForColumn:@"mail"];
            contact.address = [rs stringForColumn:@"address"];
            contact.website = [rs stringForColumn:@"website"];
            contact.remark = [rs stringForColumn:@"remark"];
            contact.relation = [[rs stringForColumn:@"relation"] integerValue];
            [result addObject:contact];
        }
        [_db close];
    }else{
        NSLog(@"data-->open error");
    }
    return result;
}


@end
