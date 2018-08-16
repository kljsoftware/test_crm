//
//  PreferUtil.h
//  sales
//
//  Created by user on 2016/11/10.
//  Copyright © 2016年 rayootech. All rights reserved.
//

#import <Foundation/Foundation.h>

#define LastContactListUpdate               @"LastContactListUpdate"
#define LastColleagueListUpdate             @"LastColleagueListUpdate"
#define LastCustomerListUpdate              @"LastCustomerListUpdate"
#define LastUnreadCircleTime                @"LastUnreadCircleTime"
#define UnreadCircleList                    @"UnreadCircleList_"
#define UnreadCircleListCount               @"UnreadCircleListCount_"
#define OrgInviteList                       @"OrgInviteList_"
#define OrgInviteCount                      @"OrgInviteCount"
#define LastUnreadBlackBoardTime            @"LastUnreadBlackBoardTime"
#define UnreadBlackBoardListCount           @"UnreadBlackBoardListUount_"
#define UnreadBlackBoardList                @"UnreadBlackBoardList_"
#define LastWorkUpdate                      @"LastWorkUpdate"
#define LastUnreadWorkTime                  @"LastUnreadWorkTime"
#define UnreadWorkList                      @"UnreadWorkList_"
#define UnreadWorkListCount                 @"UnreadWorkListUount_"
#define NewFriendReq                        @"NewFriendReq"

@interface PreferUtil : NSObject

-(void)initIN;
-(void)initOUT;
-(NSInteger)getInt:(NSString *)type;
-(void)setInt:(NSString *)type data:(NSInteger)time;

@end
