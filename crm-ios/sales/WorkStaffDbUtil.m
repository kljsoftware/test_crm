//
//  WorkStaffDbUtil.m
//  sales
//
//  Created by user on 2017/4/12.
//  Copyright © 2017年 rayootech. All rights reserved.
//

#import "WorkStaffDbUtil.h"
#define PATH_OF_DOCUMENT    [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]

@implementation WorkStaffDbUtil

-(instancetype)init{
    self = [super init];
    if (self) {
        NSString *dbname = [@"in_" stringByAppendingString:[NSString stringWithFormat:@"%ld_%ld",[Config getDbID],[Config getOrgUserID]]];
        _db = [FMDatabase databaseWithPath:[PATH_OF_DOCUMENT stringByAppendingPathComponent:dbname]];
        _createTableSql = @"CREATE TABLE IF NOT EXISTS 'TABLE_WORKSTAFF' ('_id' INTEGER PRIMARY KEY AUTOINCREMENT, 'id' INTEGER, 'picurl' TEXT, 'name' TEXT,'workid' INTEGER)";
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


-(void)insertStaffInfo:(OrgUserInfo *)staff workId:(NSInteger)workid{
    if ([_db open]) {
        NSString *insertSql = [NSString stringWithFormat:@"INSERT INTO 'TABLE_WORKSTAFF' ('id', 'name', 'picurl','workid') VALUES ('%ld', '%@', '%@','%ld')",staff.id,staff.name,staff.picurl,workid];
        
        BOOL res = [_db executeUpdate:insertSql];
        if (!res) {
        }else{
        }
        [_db close];
    }
}

-(NSMutableArray *)selectAllByWorkId:(NSInteger)workid{
    NSMutableArray *result = [[NSMutableArray alloc] init];
    if ([_db open]) {
        NSString *sql = [NSString stringWithFormat:@"SELECT * FROM 'TABLE_WORKSTAFF' where workid = %ld",workid];
        FMResultSet *rs = [_db executeQuery:sql];
        while ([rs next]) {
            OrgUserInfo *orgUserInfo = [[OrgUserInfo alloc] init];
            orgUserInfo.id = [[rs stringForColumn:@"id"] integerValue];
            orgUserInfo.name = [rs stringForColumn:@"name"];
            orgUserInfo.picurl = [rs stringForColumn:@"picurl"];
            [result addObject:orgUserInfo];
        }
        [_db close];
    }else{
        
    }
    return result;
}
@end
