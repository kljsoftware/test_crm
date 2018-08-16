//
//  FileUtils.m
//  sales
//
//  Created by user on 2017/3/16.
//  Copyright © 2017年 rayootech. All rights reserved.
//

#import "FileUtils.h"
#import "Config.h"
#define PATH_OF_DOCUMENT    [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]
@implementation FileUtils

+ (void)saveDataToFile:(NSString *)prename data:(NSMutableArray *)saveDatas{
    NSString *filename = [prename stringByAppendingString:[NSString stringWithFormat:@"%lld",[Config getOwnID]]];
    filename = [PATH_OF_DOCUMENT stringByAppendingPathComponent:filename];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:saveDatas];
    [data writeToFile:filename atomically:YES];
}
+ (NSMutableArray *)readDataFromFile:(NSString *)prename{
    NSString *filename = [prename stringByAppendingString:[NSString stringWithFormat:@"%lld",[Config getOwnID]]];

    filename = [PATH_OF_DOCUMENT stringByAppendingPathComponent:filename];
    NSData *tempData = [NSData dataWithContentsOfFile:filename options:0 error:NULL];
    NSMutableArray *temp = [NSKeyedUnarchiver unarchiveObjectWithData:tempData];
    if (temp == nil) {
        temp = [NSMutableArray new];
    }
    return temp;
}

+ (void)inSaveDataToFile:(NSString *)prename data:(NSMutableArray *)saveDatas{
    NSString *filename = [prename stringByAppendingString:[NSString stringWithFormat:@"%lld",[Config getOwnID]]];
    filename = [filename stringByAppendingString:@"_"];
    filename = [filename stringByAppendingString:[NSString stringWithFormat:@"%ld",[Config getDbID]]];
    filename = [PATH_OF_DOCUMENT stringByAppendingPathComponent:filename];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:saveDatas];
    [data writeToFile:filename atomically:YES];
}
+ (NSMutableArray *)inReadDataFromFile:(NSString *)prename{
    NSString *filename = [prename stringByAppendingString:[NSString stringWithFormat:@"%lld",[Config getOwnID]]];
    filename = [filename stringByAppendingString:@"_"];
    filename = [filename stringByAppendingString:[NSString stringWithFormat:@"%ld",[Config getDbID]]];
    filename = [PATH_OF_DOCUMENT stringByAppendingPathComponent:filename];
    NSData *tempData = [NSData dataWithContentsOfFile:filename options:0 error:NULL];
    NSMutableArray *temp = [NSKeyedUnarchiver unarchiveObjectWithData:tempData];
    if (temp == nil) {
        temp = [NSMutableArray new];
    }
    return temp;
}

@end
