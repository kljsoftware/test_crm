//
//  WorkDbUtil.h
//  sales
//
//  Created by user on 2017/4/10.
//  Copyright © 2017年 rayootech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FMDatabase.h>
#import "Work.h"
@interface WorkDbUtil : NSObject

@property (nonatomic,strong) FMDatabase *db;
@property (nonatomic,strong) NSString *createTableSql;
-(void)insertWork:(Work *)work;
-(Work *)selectWorkById:(NSInteger )id;
-(void)updateWork:(Work *)work;
-(NSMutableArray *)selectAll:(NSInteger)type pageNum:(NSInteger)page;
@end
