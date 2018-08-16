//
//  CustomerDbUtil.h
//  sales
//
//  Created by user on 2017/2/15.
//  Copyright © 2017年 rayootech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FMDatabase.h>
#import "Customer.h"
@interface CustomerDbUtil : NSObject

@property (nonatomic,strong) FMDatabase *db;
@property (nonatomic,strong) NSString *createTableSql;

-(void)insertCustomer:(Customer *)customer;
-(NSMutableArray *)selectAll:(NSString *)type;
-(NSMutableArray *)selectSortAll:(NSString *)type;
-(Customer *)selectCustomerById:(NSInteger )id;
-(void)updateCustomer:(Customer *)customer;
-(void)deleteCustomerById:(NSInteger)id;

@end
