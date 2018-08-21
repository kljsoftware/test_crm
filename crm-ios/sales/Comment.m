//
//  Comment.m
//  sales
//
//  Created by user on 2016/11/16.
//  Copyright © 2016年 rayootech. All rights reserved.
//


@implementation Comment



-(void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeInteger:self.id forKey:@"id"];
    [aCoder encodeInteger:self.buid forKey:@"buid"];
    [aCoder encodeInteger:self.toid forKey:@"toid"];
    [aCoder encodeInteger:self.uid forKey:@"uid"];
    [aCoder encodeObject:self.comment forKey:@"comment"];
    [aCoder encodeObject:self.uname forKey:@"uname"];
    [aCoder encodeObject:self.bname forKey:@"bname"];
    [aCoder encodeObject:self.bcomment forKey:@"bcomment"];
    [aCoder encodeObject:self.avatar forKey:@"avatar"];
    [aCoder encodeObject:self.publishtime forKey:@"publishtime"];
    [aCoder encodeObject:self.createtime forKey:@"createtime"];
    [aCoder encodeObject:self.attributedContent forKey:@"attributedContent"];
    [aCoder encodeObject:self.integerList forKey:@"integerList"];
    [aCoder encodeInteger:self.counts forKey:@"counts"];
    [aCoder encodeObject:self.content forKey:@"content"];
    [aCoder encodeObject:self.commentsidlist forKey:@"commentsidlist"];
}
-(id)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super init]) {
        self.id = [aDecoder decodeIntegerForKey:@"id"];
        self.buid = [aDecoder decodeIntegerForKey:@"buid"];
        self.toid = [aDecoder decodeIntegerForKey:@"toid"];
        self.uid = [aDecoder decodeIntegerForKey:@"uid"];
        self.comment = [aDecoder decodeObjectForKey:@"comment"];
        self.uname = [aDecoder decodeObjectForKey:@"uname"];
        self.bname = [aDecoder decodeObjectForKey:@"bname"];
        self.bcomment = [aDecoder decodeObjectForKey:@"bcomment"];
        self.avatar = [aDecoder decodeObjectForKey:@"avatar"];
        self.publishtime = [aDecoder decodeObjectForKey:@"publishtime"];
        self.createtime  = [aDecoder decodeObjectForKey:@"createtime"];
        self.attributedContent = [aDecoder decodeObjectForKey:@"attributedContent"];
        self.integerList = [aDecoder decodeObjectForKey:@"integerList"];
        self.counts = [aDecoder decodeIntegerForKey:@"counts"];
        self.content = [aDecoder decodeObjectForKey:@"content"];
        self.commentsidlist = [aDecoder decodeObjectForKey:@"commentsidlist"];
        
    }
    return self;
}

+ (NSDictionary *)mj_objectClassInArray{
    return @{ @"integerList":@"NSInteger",@"commentsidlist":@"NSInteger"
              };
}
@end
