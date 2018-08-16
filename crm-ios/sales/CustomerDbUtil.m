//
//  CustomerDbUtil.m
//  sales
//
//  Created by user on 2017/2/15.
//  Copyright © 2017年 rayootech. All rights reserved.
//

#import "CustomerDbUtil.h"
#import "Config.h"
#import "NSStringUtils.h"
#define PATH_OF_DOCUMENT    [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]

@implementation CustomerDbUtil

-(instancetype)init{
    self = [super init];
    if (self) {
        NSString *dbname = [@"in_" stringByAppendingString:[NSString stringWithFormat:@"%ld_%ld",[Config getDbID],[Config getOrgUserID]]];
        _db = [FMDatabase databaseWithPath:[PATH_OF_DOCUMENT stringByAppendingPathComponent:dbname]];
        _createTableSql = @"CREATE TABLE IF NOT EXISTS 'TABLE_CUSTOMER' ('_id' INTEGER PRIMARY KEY AUTOINCREMENT, 'id' INTEGER, 'name' TEXT, 'mobile' TEXT, 'title' TEXT, 'department' TEXT,'address' TEXT, 'tel' TEXT, 'mail' TEXT, 'website' TEXT, 'remark' TEXT, 'company' TEXT, 'age' INTERGER, 'sex' INTERGER, 'hometown' TEXT, 'school' TEXT, 'specialty' TEXT, 'likes' TEXT, 'homeaddress' TEXT, 'homeinfo' TEXT,'type' TEXT,'updatetime' INTEGER)";
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


-(void)insertCustomer:(Customer *)customer{
    if ([_db open]) {
        if([NSStringUtils isEmpty:customer.title] || [customer.title isEqualToString:@"(null)"]){
            customer.title = @"";
        }
        if([NSStringUtils isEmpty:customer.department] || [customer.department isEqualToString:@"(null)"]){
            customer.department = @"";
        }
        if([NSStringUtils isEmpty:customer.tel] || [customer.tel isEqualToString:@"(null)"]){
            customer.tel = @"";
        }
        if([NSStringUtils isEmpty:customer.mail] || [customer.mail isEqualToString:@"(null)"]){
            customer.mail = @"";
        }
        if([NSStringUtils isEmpty:customer.website] || [customer.website isEqualToString:@"(null)"]){
            customer.website = @"";
        }
        if([NSStringUtils isEmpty:customer.mobile] || [customer.mobile isEqualToString:@"(null)"]){
            customer.mobile = @"";
        }
        if([NSStringUtils isEmpty:customer.remark] || [customer.remark isEqualToString:@"(null)"]){
            customer.remark = @"";
        }
        if([NSStringUtils isEmpty:customer.company] || [customer.company isEqualToString:@"(null)"]){
            customer.company = @"";
        }
        if([NSStringUtils isEmpty:customer.address] || [customer.address isEqualToString:@"(null)"]){
            customer.address = @"";
        }
        if([NSStringUtils isEmpty:customer.hometown] || [customer.hometown isEqualToString:@"(null)"]){
            customer.hometown = @"";
        }
        if([NSStringUtils isEmpty:customer.school] || [customer.school isEqualToString:@"(null)"]){
            customer.school = @"";
        }
        if([NSStringUtils isEmpty:customer.specialty] || [customer.specialty isEqualToString:@"(null)"]){
            customer.specialty = @"";
        }
        if([NSStringUtils isEmpty:customer.likes] || [customer.likes isEqualToString:@"(null)"]){
            customer.likes = @"";
        }
        if([NSStringUtils isEmpty:customer.homeaddress] || [customer.homeaddress isEqualToString:@"(null)"]){
            customer.homeaddress = @"";
        }
        if([NSStringUtils isEmpty:customer.homeinfo] || [customer.homeinfo isEqualToString:@"(null)"]){
            customer.homeinfo = @"";
        }
        if([NSStringUtils isEmpty:customer.type] || [customer.type isEqualToString:@"(null)"]){
            customer.type = @"";
        }
        NSString *insertSql = [NSString stringWithFormat:@"INSERT INTO 'TABLE_CUSTOMER' ('id', 'name', 'mobile','title','department','address','tel','mail','website','remark','company','age','sex','hometown','school','specialty','likes','homeaddress','homeinfo','type','updatetime') VALUES ('%ld', '%@', '%@','%@','%@','%@','%@','%@','%@','%@','%@','%ld','%ld','%@','%@','%@','%@','%@','%@','%@','%ld')",customer.id,customer.name,customer.mobile,customer.title,customer.department,customer.address,customer.tel,customer.mail,customer.website,customer.remark,customer.company,customer.age,customer.sex,customer.hometown,customer.school,customer.specialty,customer.likes,customer.homeaddress,customer.homeinfo,customer.type,customer.updatetime];
        NSLog(@"jjjj-- %@",insertSql);
        BOOL res = [_db executeUpdate:insertSql];
        if (res) {
            NSLog(@"insert success ");
        }else{
            NSLog(@"insert error");
        }
        [_db close];
    }
}

-(NSMutableArray *)selectAll:(NSString *)type{
    NSMutableArray *result = [[NSMutableArray alloc] init];
    if ([_db open]) {
        NSString *sql = [NSString stringWithFormat:@"SELECT * FROM 'TABLE_CUSTOMER' where type = %@",type];
        if ([type isEqualToString:@"0"]) {
            sql = @"SELECT * FROM 'TABLE_CUSTOMER'";
        }
        FMResultSet *rs = [_db executeQuery:sql];
        while ([rs next]) {
            Customer *customer = [[Customer alloc] init];
            customer.id = [[rs stringForColumn:@"id"] integerValue];
            customer.name = [rs stringForColumn:@"name"];
            customer.mobile = [rs stringForColumn:@"mobile"];
            customer.title = [rs stringForColumn:@"title"];
            customer.department = [rs stringForColumn:@"department"];
            customer.address = [rs stringForColumn:@"address"];
            customer.tel = [rs stringForColumn:@"tel"];
            customer.mail = [rs stringForColumn:@"mail"];
            customer.website = [rs stringForColumn:@"website"];
            customer.remark = [rs stringForColumn:@"remark"];
            customer.company = [rs stringForColumn:@"company"];
            customer.age = [[rs stringForColumn:@"age"] integerValue];
            customer.sex = [[rs stringForColumn:@"sex"] integerValue];
            customer.hometown = [rs stringForColumn:@"hometown"];
            customer.school = [rs stringForColumn:@"school"];
            customer.specialty = [rs stringForColumn:@"specialty"];
            customer.likes = [rs stringForColumn:@"likes"];
            customer.homeaddress = [rs stringForColumn:@"homeaddress"];
            customer.homeinfo = [rs stringForColumn:@"homeinfo"];
            customer.type = [rs stringForColumn:@"type"];
            [result addObject:customer];
        }
        [_db close];
    }else{
        
    }
    return result;
}

-(NSMutableArray *)selectSortAll:(NSString *)type{
    NSMutableArray *result = [[NSMutableArray alloc] init];
    if ([_db open]) {
        NSString *sql = [NSString stringWithFormat:@"SELECT * FROM 'TABLE_CUSTOMER' where type = %@ order by updatetime desc",type];
        if ([type isEqualToString:@"0"]) {
            sql = @"SELECT * FROM 'TABLE_CUSTOMER' order by updatetime desc";
        }
        FMResultSet *rs = [_db executeQuery:sql];
        while ([rs next]) {
            Customer *customer = [[Customer alloc] init];
            customer.id = [[rs stringForColumn:@"id"] integerValue];
            customer.name = [rs stringForColumn:@"name"];
            customer.mobile = [rs stringForColumn:@"mobile"];
            customer.title = [rs stringForColumn:@"title"];
            customer.department = [rs stringForColumn:@"department"];
            customer.address = [rs stringForColumn:@"address"];
            customer.tel = [rs stringForColumn:@"tel"];
            customer.mail = [rs stringForColumn:@"mail"];
            customer.website = [rs stringForColumn:@"website"];
            customer.remark = [rs stringForColumn:@"remark"];
            customer.company = [rs stringForColumn:@"company"];
            customer.age = [[rs stringForColumn:@"age"] integerValue];
            customer.sex = [[rs stringForColumn:@"sex"] integerValue];
            customer.hometown = [rs stringForColumn:@"hometown"];
            customer.school = [rs stringForColumn:@"school"];
            customer.specialty = [rs stringForColumn:@"specialty"];
            customer.likes = [rs stringForColumn:@"likes"];
            customer.homeaddress = [rs stringForColumn:@"homeaddress"];
            customer.homeinfo = [rs stringForColumn:@"homeinfo"];
            customer.type = [rs stringForColumn:@"type"];
            [result addObject:customer];
        }
        [_db close];
    }else{
        
    }
    return result;
}

-(Customer *)selectCustomerById:(NSInteger)id{
    Customer *customer = [Customer new];
    if ([_db open]) {
        NSString *sql = [NSString stringWithFormat:@"SELECT * FROM 'TABLE_CUSTOMER' where id = %ld",id];
        FMResultSet *rs = [_db executeQuery:sql];
        customer.id = 0;
        while ([rs next]) {
            customer.id = [[rs stringForColumn:@"id"] integerValue];
            customer.name = [rs stringForColumn:@"name"];
            customer.mobile = [rs stringForColumn:@"mobile"];
            customer.title = [rs stringForColumn:@"title"];
            customer.department = [rs stringForColumn:@"department"];
            customer.address = [rs stringForColumn:@"address"];
            customer.tel = [rs stringForColumn:@"tel"];
            customer.mail = [rs stringForColumn:@"mail"];
            customer.website = [rs stringForColumn:@"website"];
            customer.remark = [rs stringForColumn:@"remark"];
            customer.company = [rs stringForColumn:@"company"];
            customer.age = [[rs stringForColumn:@"age"] integerValue];
            customer.sex = [[rs stringForColumn:@"sex"] integerValue];
            customer.hometown = [rs stringForColumn:@"hometown"];
            customer.school = [rs stringForColumn:@"school"];
            customer.specialty = [rs stringForColumn:@"specialty"];
            customer.likes = [rs stringForColumn:@"likes"];
            customer.homeaddress = [rs stringForColumn:@"homeaddress"];
            customer.homeinfo = [rs stringForColumn:@"homeinfo"];
            customer.type = [rs stringForColumn:@"type"];
        }
        [_db close];
    }
    return customer;
}
- (void) updateCustomer:(Customer *)customer{
    if ([_db open]) {
        if([NSStringUtils isEmpty:customer.title] || [customer.title isEqualToString:@"(null)"]){
            customer.title = @"";
        }
        if([NSStringUtils isEmpty:customer.department] || [customer.department isEqualToString:@"(null)"]){
            customer.department = @"";
        }
        if([NSStringUtils isEmpty:customer.tel] || [customer.tel isEqualToString:@"(null)"]){
            customer.tel = @"";
        }
        if([NSStringUtils isEmpty:customer.mail] || [customer.mail isEqualToString:@"(null)"]){
            customer.mail = @"";
        }
        if([NSStringUtils isEmpty:customer.website] || [customer.website isEqualToString:@"(null)"]){
            customer.website = @"";
        }
        if([NSStringUtils isEmpty:customer.mobile] || [customer.mobile isEqualToString:@"(null)"]){
            customer.mobile = @"";
        }
        if([NSStringUtils isEmpty:customer.remark] || [customer.remark isEqualToString:@"(null)"]){
            customer.remark = @"";
        }
        if([NSStringUtils isEmpty:customer.company] || [customer.company isEqualToString:@"(null)"]){
            customer.company = @"";
        }
        if([NSStringUtils isEmpty:customer.address] || [customer.address isEqualToString:@"(null)"]){
            customer.address = @"";
        }
        if([NSStringUtils isEmpty:customer.hometown] || [customer.hometown isEqualToString:@"(null)"]){
            customer.hometown = @"";
        }
        if([NSStringUtils isEmpty:customer.school] || [customer.school isEqualToString:@"(null)"]){
            customer.school = @"";
        }
        if([NSStringUtils isEmpty:customer.specialty] || [customer.specialty isEqualToString:@"(null)"]){
            customer.specialty = @"";
        }
        if([NSStringUtils isEmpty:customer.likes] || [customer.likes isEqualToString:@"(null)"]){
            customer.likes = @"";
        }
        if([NSStringUtils isEmpty:customer.homeaddress] || [customer.homeaddress isEqualToString:@"(null)"]){
            customer.homeaddress = @"";
        }
        if([NSStringUtils isEmpty:customer.homeinfo] || [customer.homeinfo isEqualToString:@"(null)"]){
            customer.homeinfo = @"";
        }
        if([NSStringUtils isEmpty:customer.type] || [customer.type isEqualToString:@"(null)"]){
            customer.type = @"";
        }

        NSString *sql = [NSString stringWithFormat:@"UPDATE 'TABLE_CUSTOMER' SET name = '%@', mobile = '%@',title = '%@',department = '%@',address = '%@',tel = '%@', mail = '%@',website = '%@',remark = '%@',company = '%@',age = '%ld',sex = '%ld',hometown = '%@', school = '%@', specialty = '%@', likes = '%@', homeaddress = '%@', homeinfo = '%@',type = '%@' where id = %ld",customer.name,customer.mobile,customer.title,customer.department,customer.address,customer.tel,customer.mail,customer.website,customer.remark,customer.company,customer.age,customer.sex,customer.hometown,customer.school,customer.specialty,customer.likes,customer.homeaddress,customer.homeinfo,customer.type,customer.id];
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

- (void)deleteCustomerById:(NSInteger)id{
    if ([_db open]) {
        NSString *sql = [NSString stringWithFormat:@"delete from 'TABLE_CUSTOMER' where id = %ld",id];
        [_db executeUpdate:sql];
        [_db close];
    }
}

@end

