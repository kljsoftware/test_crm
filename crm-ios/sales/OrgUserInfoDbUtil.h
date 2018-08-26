//
//  OrgUserInfoDbUtil.h
//  sales
//
//  Created by user on 2017/1/4.
//  Copyright © 2017年 rayootech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OrgUserInfo.h"
@interface OrgUserInfoDbUtil : NSObject

@property (nonatomic,strong) FMDatabase *db;
@property (nonatomic,strong) NSString *createTableSql;

-(void)insertOrgUserInfo:(OrgUserInfo *)orgUserInfo;
-(NSMutableArray *)selectAll;
-(OrgUserInfo *)selectOrgUserById:(NSInteger )id;
-(void)updateOrgUserInfo:(OrgUserInfo *)orgUserInfo;
-(void)deleteOrgUserById:(NSInteger)id;
@end
