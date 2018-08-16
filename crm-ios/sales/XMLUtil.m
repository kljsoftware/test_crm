//
//  XMLUtil.m
//  sales
//
//  Created by user on 2017/4/13.
//  Copyright © 2017年 rayootech. All rights reserved.
//

#import "XMLUtil.h"

@implementation XMLUtil

- (instancetype)init{
    self = [super init];
    if (self) {
    }
    return self;
}
- (void)parserDidStartDocument:(NSXMLParser *)parser{}
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary<NSString *,NSString *> *)attributeDict{
    self.currentElement = elementName;
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
    if ([self.currentElement isEqualToString:@"f"]) {
        
    }else if([self.currentElement isEqualToString:@"v"]){
        self.value = string;
    }else if([self.currentElement isEqualToString:@"n"]){
        self.key = string;
    }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{
    if ([elementName isEqualToString:@"f"]) {
        [_map setValue:self.value forKey:self.key];
    }
    self.currentElement = nil;
}

- (void)parserDidEndDocument:(NSXMLParser *)parser{
    for (int i = 0; i < self.map.count; i++) {
    }
}

- (void)parse:(NSString *)result{
    NSData *data = [result dataUsingEncoding:NSUTF8StringEncoding];
    self.key = @"key";
    self.value = @"value";
    _map = [[NSMutableDictionary alloc] init];
    self.par = [[NSXMLParser alloc] initWithData:data];
    self.par.delegate = self;
    [self.par parse];
}

- (NSMutableDictionary *)getMap{
    return _map;
}
@end
