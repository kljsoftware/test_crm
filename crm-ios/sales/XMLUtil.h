//
//  XMLUtil.h
//  sales
//
//  Created by user on 2017/4/13.
//  Copyright © 2017年 rayootech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XMLUtil : NSObject<NSXMLParserDelegate>

@property (nonatomic,strong) NSXMLParser *par;
@property (nonatomic,copy) NSString *currentElement;
@property (nonatomic,strong) NSMutableDictionary *map;
@property (nonatomic,strong) NSString *key;
@property (nonatomic,strong) NSString *value;
-(void)parse:(NSString *)result;
- (NSMutableDictionary *)getMap;
@end
