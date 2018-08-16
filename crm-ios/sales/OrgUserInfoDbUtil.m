//
//  OrgUserInfoDbUtil.m
//  sales
//
//  Created by user on 2017/1/4.
//  Copyright © 2017年 rayootech. All rights reserved.
//

#import "OrgUserInfoDbUtil.h"
#import "Config.h"
#import "NSStringUtils.h"
#define PATH_OF_DOCUMENT    [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]

@implementation OrgUserInfoDbUtil

-(instancetype)init{
    self = [super init];
    if (self) {
        NSString *dbname = [@"in_" stringByAppendingString:[NSString stringWithFormat:@"%ld_%ld",[Config getDbID],[Config getOrgUserID]]];
        _db = [FMDatabase databaseWithPath:[PATH_OF_DOCUMENT stringByAppendingPathComponent:dbname]];
        _createTableSql = @"CREATE TABLE IF NOT EXISTS 'TABLE_ORGUSERINFO' ('_id' INTEGER PRIMARY KEY AUTOINCREMENT, 'id' INTEGER, 'avatar' TEXT, 'name' TEXT, 'mobile' TEXT, 'sex' INTERGER, 'area' TEXT, 'email' TEXT,'wechat' TEXT, 'title' TEXT)";
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


-(void)insertOrgUserInfo:(OrgUserInfo *)orgUserInfo{
    if ([_db open]) {
        if([NSStringUtils isEmpty:orgUserInfo.title] || [orgUserInfo.title isEqualToString:@"(null)"]){
            orgUserInfo.title = @"";
        }
        if([NSStringUtils isEmpty:orgUserInfo.area] || [orgUserInfo.area isEqualToString:@"(null)"]){
            orgUserInfo.area = @"";
        }
        if([NSStringUtils isEmpty:orgUserInfo.wechat] || [orgUserInfo.wechat isEqualToString:@"(null)"]){
            orgUserInfo.wechat = @"";
        }
        if([NSStringUtils isEmpty:orgUserInfo.email] || [orgUserInfo.email isEqualToString:@"(null)"]){
            orgUserInfo.email = @"";
        }
        
        NSString *insertSql = [NSString stringWithFormat:@"INSERT INTO 'TABLE_ORGUSERINFO' ('id', 'name', 'avatar', 'mobile','sex','area','email','wechat','title') VALUES ('%ld', '%@', '%@', '%@','%ld','%@','%@','%@','%@')",orgUserInfo.id,orgUserInfo.name,orgUserInfo.avatar,orgUserInfo.mobile,orgUserInfo.sex,orgUserInfo.area,orgUserInfo.email,orgUserInfo.wechat,orgUserInfo.title];
        
        BOOL res = [_db executeUpdate:insertSql];
        if (!res) {
        }else{
        }
        [_db close];
    }
}

-(NSMutableArray *)selectAll{
    NSMutableArray *result = [[NSMutableArray alloc] init];
    if ([_db open]) {
        NSString *sql = @"SELECT * FROM 'TABLE_ORGUSERINFO'";
        FMResultSet *rs = [_db executeQuery:sql];
        while ([rs next]) {
            OrgUserInfo *orgUserInfo = [[OrgUserInfo alloc] init];
            orgUserInfo.id = [[rs stringForColumn:@"id"] integerValue];
            orgUserInfo.avatar = [rs stringForColumn:@"avatar"];
            orgUserInfo.name = [rs stringForColumn:@"name"];
            orgUserInfo.mobile = [rs stringForColumn:@"mobile"];
            orgUserInfo.sex = [[rs stringForColumn:@"sex"] integerValue];
            orgUserInfo.area = [rs stringForColumn:@"area"];
            orgUserInfo.email = [rs stringForColumn:@"email"];
            orgUserInfo.wechat = [rs stringForColumn:@"wechat"];
            orgUserInfo.title = [rs stringForColumn:@"title"];
            [result addObject:orgUserInfo];
        }
        [_db close];
    }else{
        
    }
    return result;
}
-(OrgUserInfo *)selectOrgUserById:(NSInteger)id{
    OrgUserInfo *orgUserInfo = [OrgUserInfo new];
    if ([_db open]) {
        NSString *sql = [NSString stringWithFormat:@"SELECT * FROM 'TABLE_ORGUSERINFO' where id = %ld",id];
        FMResultSet *rs = [_db executeQuery:sql];
        orgUserInfo.id = 0;
        while ([rs next]) {
            orgUserInfo.id = [[rs stringForColumn:@"id"] integerValue];
            orgUserInfo.avatar = [rs stringForColumn:@"avatar"];
            orgUserInfo.name = [rs stringForColumn:@"name"];
            orgUserInfo.mobile = [rs stringForColumn:@"mobile"];
            orgUserInfo.sex = [[rs stringForColumn:@"sex"] integerValue];
            orgUserInfo.area = [rs stringForColumn:@"area"];
            orgUserInfo.email = [rs stringForColumn:@"email"];
            orgUserInfo.wechat = [rs stringForColumn:@"wechat"];
            orgUserInfo.title = [rs stringForColumn:@"title"];
        }
        [_db close];
    }
    return orgUserInfo;
}
- (void) updateOrgUserInfo:(OrgUserInfo *)orgUserInfo{
    if ([_db open]) {
        NSString *sql = [NSString stringWithFormat:@"UPDATE 'TABLE_ORGUSERINFO' SET name = '%@', mobile = '%@', avatar = '%@' where id = %ld",orgUserInfo.name,orgUserInfo.mobile,orgUserInfo.avatar,orgUserInfo.id];
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

- (void)deleteOrgUserById:(NSInteger)id{
    if ([_db open]) {
        NSString *sql = [NSString stringWithFormat:@"delete from 'TABLE_ORGUSERINFO' where id = %ld",id];
        [_db executeUpdate:sql];
        [_db close];
    }
}

@end
