//
//  PackageAPI.h
//  sales
//
//  Created by user on 2017/4/13.
//  Copyright © 2017年 rayootech. All rights reserved.
//

#import <Foundation/Foundation.h>
#define serverUrl @"http://www.yunmaiocr.com/SrvXMLAPI"
@interface PackageAPI : NSObject
@property (nonatomic, copy) NSString *statusStr;
@property (nonatomic, copy) NSData *receiveData;
@property (nonatomic, copy) NSString *result;

-(NSString *)uploadPackage:(NSData*)imageData andindexPath:(NSInteger)indexPath;
@end
