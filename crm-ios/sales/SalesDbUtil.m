//
//  SalesDbUtil.m
//  sales
//
//  Created by user on 2016/11/10.
//  Copyright © 2016年 rayootech. All rights reserved.
//

#import "SalesDbUtil.h"

#define PATH_OF_DOCUMENT    [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]

@implementation SalesDbUtil

-(instancetype)init{
    self = [super init];
    if (self) {
        NSLog(@"----%@",PATH_OF_DOCUMENT);
        NSString *dbname = [@"out_" stringByAppendingString:[NSString stringWithFormat:@"%lld",[Config getOwnID]]];
        _db = [FMDatabase databaseWithPath:[PATH_OF_DOCUMENT stringByAppendingPathComponent:dbname]];
        _createTableSql = @"CREATE TABLE IF NOT EXISTS 'TABLE_CONTACT' ('_id' INTEGER PRIMARY KEY AUTOINCREMENT, 'id' INTEGER, 'fid' INTEGER, 'avatar' TEXT, 'name' TEXT, 'mobile' TEXT,'orgname' TEXT,'title' TEXT,'dept' TEXT,'tel' TEXT,'mail' TEXT,'address' TEXT,'website' TEXT,'remark' TEXT,'relation' INTEGER)";
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
        NSString *insertSql = [NSString stringWithFormat:@"INSERT INTO 'TABLE_CONTACT' ('id', 'fid', 'name', 'avatar', 'mobile','orgname','title','dept','tel','mail','address','website','remark','relation') VALUES ('%ld', '%ld', '%@', '%@', '%@','%@','%@','%@','%@','%@','%@','%@','%@','%ld')",contact.id,contact.fid,contact.name,contact.avatar,contact.mobile,contact.orgname,contact.title,contact.dept,contact.tel,contact.mail,contact.address,contact.website,contact.remark,contact.relation];
        
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
        NSString *sql = @"SELECT * FROM 'TABLE_CONTACT'";
        FMResultSet *rs = [_db executeQuery:sql];
        while ([rs next]) {
//            NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
//            [dictionary setObject:[rs stringForColumn:@"id"] forKey:@"id"];
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
-(Contact *)selectUserById:(NSInteger)fid{
    Contact *contact = [Contact new];
    if ([_db open]) {
        NSString *sql = [NSString stringWithFormat:@"SELECT * FROM 'TABLE_CONTACT' where fid = %ld",fid];
        FMResultSet *rs = [_db executeQuery:sql];
        contact.fid = 0;
        while ([rs next]) {
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
        }
        [_db close];
    }
    return contact;
}
- (void) updateContact:(Contact *)contact{
    if ([_db open]) {
        NSString *sql = [NSString stringWithFormat:@"UPDATE 'TABLE_CONTACT' SET name = '%@', mobile = '%@', orgname = '%@', title = '%@', dept = '%@', mail = '%@', address = '%@', website = '%@', remark = '%@', tel = '%@', relation = %ld where id = %ld",contact.name,contact.mobile,contact.orgname,contact.title,contact.dept,contact.mail,contact.address,contact.website,contact.remark,contact.tel,contact.relation,contact.id];
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
        NSString *sql = [NSString stringWithFormat:@"SELECT * FROM 'TABLE_CONTACT' where id = %ld",id];
        FMResultSet *rs = [_db executeQuery:sql];
        contact.id = 0;
        while ([rs next]) {
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
        }
        [_db close];
    }
    return contact;
}
- (void)deleteContactById:(NSInteger)id{
    if ([_db open]) {
        NSString *sql = [NSString stringWithFormat:@"delete from 'TABLE_CONTACT' where id = %ld",id];
        [_db executeUpdate:sql];
        [_db close];
    }
}

-(NSMutableArray *)selectAllFriends{
    NSMutableArray *result = [[NSMutableArray alloc] init];
    if ([_db open]) {
        NSString *sql = @"SELECT * FROM 'TABLE_CONTACT' where fid != 0 and relation = 2";
        FMResultSet *rs = [_db executeQuery:sql];
        while ([rs next]) {
            //            NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
            //            [dictionary setObject:[rs stringForColumn:@"id"] forKey:@"id"];
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
