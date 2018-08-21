//
//  WorkCommentDbUtil.m
//  sales
//
//  Created by user on 2017/4/11.
//  Copyright © 2017年 rayootech. All rights reserved.
//

#import "WorkCommentDbUtil.h"
#define PATH_OF_DOCUMENT    [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]
@implementation WorkCommentDbUtil

-(instancetype)init{
    self = [super init];
    if (self) {
        NSString *dbname = [@"in_" stringByAppendingString:[NSString stringWithFormat:@"%ld_%ld",(long)[Config getDbID],(long)[Config getOrgUserID]]];
        _db = [FMDatabase databaseWithPath:[PATH_OF_DOCUMENT stringByAppendingPathComponent:dbname]];
        _createTableSql = @"CREATE TABLE IF NOT EXISTS 'TABLE_WORKCOMMENT' ('_id' INTEGER PRIMARY KEY AUTOINCREMENT, 'id' INTEGER, 'workid' INTEGER, 'uid' INTEGER, 'uname' TEXT, 'buid' INTEGER, 'bname' TEXT, 'comment' TEXT,'bcomment' TEXT, 'favnum' INTEGER,'favstatus' INTEGER,'avatar' TEXT)";
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

-(void)insertComment:(Comment *)comment workid:(NSInteger )wid{
    if ([_db open]) {
//        NSString *insertSql = [NSString stringWithFormat:@"INSERT INTO 'TABLE_WORKCOMMENT' ('id', 'workid', 'uid', 'uname','buid','bname','comment','bcomment','favnum','favstatus','avatar') VALUES ('%ld', '%ld', '%ld', '%@','%ld','%@','%@','%@','%ld','%ld','%@')",(long)comment.id,(long)wid,(long)comment.uid,comment.uname,(long)comment.buid,comment.bname,comment.comment,comment.bcomment,(long)comment.favnum,(long)comment.favstatus,comment.avatar];
//        
//        BOOL res = [_db executeUpdate:insertSql];
//        if (!res) {
//        }else{
//        }
        
        [_db executeUpdateWithFormat:@"INSERT INTO TABLE_WORKCOMMENT (id, workid, uid,uname,buid,bname,comment,bcomment,favnum,favstatus,avatar) VALUES (%ld, %ld, %ld, %@,%ld,%@,%@,%@,%ld,%ld,%@);",(long)comment.id,(long)wid,(long)comment.uid,comment.uname,(long)comment.buid,comment.bname,comment.comment,comment.bcomment,(long)comment.favnum,(long)comment.favstatus,comment.avatar];
        [_db close];
    }
}

- (NSMutableArray *)selectAll:(NSInteger)workid{
    NSMutableArray *result = [[NSMutableArray alloc] init];
    if ([_db open]) {
        NSString *sql = [NSString stringWithFormat:@"SELECT * FROM 'TABLE_WORKCOMMENT' where workid = %ld",(long)workid];
        
        FMResultSet *rs = [_db executeQuery:sql];
        
        while ([rs next] ) {
            Comment *comment = [[Comment alloc] init];
            comment.id = [[rs stringForColumn:@"id"] integerValue];
            comment.avatar = [rs stringForColumn:@"avatar"];
            comment.uid = [[rs stringForColumn:@"uid"] integerValue];
            comment.buid = [[rs stringForColumn:@"buid"] integerValue];
            comment.comment = [rs stringForColumn:@"comment"];
            comment.favstatus = [[rs stringForColumn:@"favstatus"] integerValue];
            comment.uname = [rs stringForColumn:@"uname"];
            comment.bname = [rs stringForColumn:@"bname"];
            comment.favnum = [[rs stringForColumn:@"favnum"] integerValue];
            comment.bcomment = [rs stringForColumn:@"comment"];
            [result addObject:comment];
        }
        [_db close];
    }else{
        NSLog(@"data-->open error");
    }
    return result;
}
- (void)deleteCommentByWorkId:(NSInteger)workid{
    if ([_db open]) {
        NSString *sql = [NSString stringWithFormat:@"delete from 'TABLE_WORKCOMMENT' where workid = %ld",(long)workid];
        [_db executeUpdate:sql];
        [_db close];
    }
}


@end
