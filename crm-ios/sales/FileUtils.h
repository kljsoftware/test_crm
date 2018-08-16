//
//  FileUtils.h
//  sales
//
//  Created by user on 2017/3/16.
//  Copyright © 2017年 rayootech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FileUtils : NSObject

+ (void)saveDataToFile:(NSString *)prename data:(NSMutableArray *)saveDatas;

+ (NSMutableArray *)readDataFromFile:(NSString *)prename;

+ (void)inSaveDataToFile:(NSString *)prename data:(NSMutableArray *)saveDatas;

+ (NSMutableArray *)inReadDataFromFile:(NSString *)prename;

@end
