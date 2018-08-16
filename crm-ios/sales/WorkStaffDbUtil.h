//
//  WorkStaffDbUtil.h
//  sales
//
//  Created by user on 2017/4/12.
//  Copyright © 2017年 rayootech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FMDatabase.h>
#import "OrgUserInfo.h"
@interface WorkStaffDbUtil : NSObject

@property (nonatomic,strong) FMDatabase *db;
@property (nonatomic,strong) NSString *createTableSql;

-(void)insertStaffInfo:(OrgUserInfo *)staff workId:(NSInteger)workid;
-(NSMutableArray *)selectAllByWorkId:(NSInteger)workid;
@end
