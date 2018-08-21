//
//  WorkDbUtil.m
//  sales
//
//  Created by user on 2017/4/10.
//  Copyright © 2017年 rayootech. All rights reserved.
//

#import "WorkDbUtil.h"
#define PATH_OF_DOCUMENT    [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]
@implementation WorkDbUtil

-(instancetype)init{
    self = [super init];
    if (self) {
        NSString *dbname = [@"in_" stringByAppendingString:[NSString stringWithFormat:@"%ld_%ld",[Config getDbID],[Config getOrgUserID]]];
        _db = [FMDatabase databaseWithPath:[PATH_OF_DOCUMENT stringByAppendingPathComponent:dbname]];
        _createTableSql = @"CREATE TABLE IF NOT EXISTS 'TABLE_WORK' ('_id' INTEGER PRIMARY KEY AUTOINCREMENT, 'id' INTEGER, 'worktype' INTEGER, 'type' INTEGER, 'content' TEXT, 'user' TEXT, 'picurl' TEXT, 'status' INTEGER,'worktime' TEXT, 'address' TEXT,'favstatus' INTEGER,'avatar' TEXT,'customerName' TEXT,'favnum' INTEGER)";
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

-(void)insertWork:(Work *)work{
    if ([_db open]) {
        NSString *insertSql = [NSString stringWithFormat:@"INSERT INTO 'TABLE_WORK' ('id', 'worktype', 'type', 'content','user','picurl','status','worktime','address','favstatus','avatar','customerName','favnum') VALUES ('%ld', '%ld', '%ld', '%@','%@','%@','%ld','%@','%@','%ld','%@','%@','%ld')",work.id,work.worktype,work.type,work.content,work.user,work.picurl,work.status,work.worktime,work.address,work.favstatus,work.avatar,work.customerName,work.favnum];
        
        BOOL res = [_db executeUpdate:insertSql];
        if (!res) {
        }else{
        }
        [_db close];
    }
}

-(Work *)selectWorkById:(NSInteger)id{
    Work *work = [Work new];
    if ([_db open]) {
        NSString *sql = [NSString stringWithFormat:@"SELECT * FROM 'TABLE_WORK' where id = %ld",id];
        FMResultSet *rs = [_db executeQuery:sql];
        work.id = 0;
        while ([rs next]) {
            work.id = [[rs stringForColumn:@"id"] integerValue];
            work.worktype = [[rs stringForColumn:@"worktype"] integerValue];
            work.type = [[rs stringForColumn:@"type"] integerValue];
            work.content = [rs stringForColumn:@"content"];
            work.user = [rs stringForColumn:@"user"];
            work.picurl = [rs stringForColumn:@"picurl"];
            work.status = [[rs stringForColumn:@"status"] integerValue];
            work.worktime = [rs stringForColumn:@"worktime"];
            work.address = [rs stringForColumn:@"address"];
            work.favstatus = [[rs stringForColumn:@"favstatus"] integerValue];
            work.avatar = [rs stringForColumn:@"avatar"];
            work.customerName = [rs stringForColumn:@"customerName"];
            work.favnum = [[rs stringForColumn:@"favnum"] integerValue];
        }
        [_db close];
    }
    return work;
}

-(NSMutableArray *)selectAll:(NSInteger)type pageNum:(NSInteger)page{
    NSMutableArray *result = [[NSMutableArray alloc] init];
    if ([_db open]) {
        NSString *sql = [NSString stringWithFormat:@"SELECT * FROM 'TABLE_WORK' where type = %ld order by id desc",type];
        if (type == 0) {
            sql = @"SELECT * FROM 'TABLE_WORK' order by id desc";
        }else if(type == 2 || type == 3){
            sql = [NSString stringWithFormat:@"SELECT * FROM 'TABLE_WORK' where type = %ld or type = 5 order by id desc",type];
        }else{
            sql = [NSString stringWithFormat:@"SELECT * FROM 'TABLE_WORK' where type = %ld order by id desc",type];
        }
        FMResultSet *rs = [_db executeQuery:sql];
        int count = 0,i = 0;
        while (count < page * 20) {
            if([rs next])
            {
                count++;
            }else{
                return result;
            }
        }
        while ([rs next] && i < 20) {
            i++;
            Work *work = [[Work alloc] init];
            work.id = [[rs stringForColumn:@"id"] integerValue];
            work.avatar = [rs stringForColumn:@"avatar"];
            work.worktype = [[rs stringForColumn:@"worktype"] integerValue];
            work.type = [[rs stringForColumn:@"type"] integerValue];
            work.content = [rs stringForColumn:@"content"];
            work.status = [[rs stringForColumn:@"status"] integerValue];
            work.worktime = [rs stringForColumn:@"worktime"];
            work.address = [rs stringForColumn:@"address"];
            work.favstatus = [[rs stringForColumn:@"favstatus"] integerValue];
            work.favnum = [[rs stringForColumn:@"favnum"] integerValue];
            work.customerName = [rs stringForColumn:@"customerName"];
            work.user = [rs stringForColumn:@"user"];
            work.picurl = [rs stringForColumn:@"picurl"];
            [result addObject:work];
        }
        [_db close];
    }else{
        NSLog(@"data-->open error");
    }
    return result;
}
- (void)updateWork:(Work *)work{
    [NSString stringWithFormat:@"INSERT INTO 'TABLE_WORK' ('id', 'worktype', 'type', 'content','user','picurl','status','worktime','address','favstatus','avatar','customerName','favnum') VALUES ('%ld', '%ld', '%ld', '%@','%@','%@','%ld','%@','%@','%ld','%@','%@','%ld')",work.id,work.worktype,work.type,work.content,work.user,work.picurl,work.status,work.worktime,work.address,work.favstatus,work.avatar,work.customerName,work.favnum];

    if ([_db open]) {
        NSString *sql = [NSString stringWithFormat:@"UPDATE 'TABLE_WORK' SET worktype = '%ld', type = '%ld', content = '%@', user = '%@', picurl = '%@', status = '%ld', worktime = '%@',address = '%@', favstatus = '%ld', avatar = '%@', customerName = '%@',favnum = '%ld' where id = '%ld'",work.worktype,work.type,work.content,work.user,work.picurl,work.status,work.worktime,work.address,work.favstatus,work.avatar,work.customerName,work.favnum,work.id];
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
@end
