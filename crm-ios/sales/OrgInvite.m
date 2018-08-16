//
//  OrgInvite.m
//  sales
//
//  Created by user on 2017/3/16.
//  Copyright © 2017年 rayootech. All rights reserved.
//

#import "OrgInvite.h"

@implementation OrgInvite

-(void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.inviter forKey:@"inviter"];
    [aCoder encodeObject:self.dbid forKey:@"dbid"];
    [aCoder encodeObject:self.orgname forKey:@"orgname"];
    [aCoder encodeObject:self.recevied forKey:@"recevied"];
}
-(id)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super init]) {
        self.inviter = [aDecoder decodeObjectForKey:@"inviter"];
        self.dbid  = [aDecoder decodeObjectForKey:@"dbid"];
        self.orgname = [aDecoder decodeObjectForKey:@"orgname"];
        self.recevied = [aDecoder decodeObjectForKey:@"recevied"];
    }
    return self;
}

@end
