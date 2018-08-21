//
//  WorkCommentDbUtil.h
//  sales
//
//  Created by user on 2017/4/11.
//  Copyright © 2017年 rayootech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FMDatabase.h>
#import "Work.h"
@interface WorkCommentDbUtil : NSObject

@property (nonatomic,strong) FMDatabase *db;
@property (nonatomic,strong) NSString *createTableSql;
-(void)insertComment:(Comment *)comment workid:(NSInteger )wid;
-(void)deleteCommentByWorkId:(NSInteger)workid;
-(NSMutableArray *)selectAll:(NSInteger)workid;
@end
