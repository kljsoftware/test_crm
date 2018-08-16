//
//  PreferUtil.m
//  sales
//
//  Created by user on 2016/11/10.
//  Copyright © 2016年 rayootech. All rights reserved.
//

#import "PreferUtil.h"
#import "Config.h"

@interface PreferUtil ()

@property (nonatomic,strong) NSUserDefaults *defaults;

@end

@implementation PreferUtil
- (void)initOUT{
    NSString *suiteName = [@"setting_" stringByAppendingString:[NSString stringWithFormat:@"%lld",[Config getOwnID]]];
    _defaults = [[NSUserDefaults alloc] initWithSuiteName:suiteName];
}
- (void)initIN{
    NSString *orgUserID = [NSString stringWithFormat:@"%ld",[Config getOrgUserID]];
    NSString *dbID = [NSString stringWithFormat:@"%ld",[Config getDbID]];
    NSString *suiteName = [@"setting_" stringByAppendingString:[NSString stringWithFormat:@"%@_%@",dbID,orgUserID]];
    _defaults = [[NSUserDefaults alloc] initWithSuiteName:suiteName];
}
- (void)setInt:(NSString *)type data:(NSInteger)time{
//    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    [_defaults setInteger:time forKey:type];
    [_defaults synchronize];
}

- (NSInteger)getInt:(NSString *)type{
//    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [_defaults integerForKey:type];
}
@end
