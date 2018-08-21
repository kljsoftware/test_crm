//
//  PackageAPI.m
//  sales
//
//  Created by user on 2017/4/13.
//  Copyright © 2017年 rayootech. All rights reserved.
//

#import "PackageAPI.h"
#import <CommonCrypto/CommonDigest.h>
#import <sys/sysctl.h>
#import <ASIHTTPRequest.h>
#define ERROR_SERVER @"服务器请求超时，请重试"
@implementation PackageAPI
//将小写转换为大写
-(NSString*)lower2Uppercase:(NSString*)str
{
    char *strP;
    strP = [str UTF8String];
    const char *conStrP = strP;
    
    while (*strP != '\0') {
        if (*strP >= 'a' && *strP <= 'z') {
            *strP-=32;
        }
        strP++;
    }
    NSString *uppercase = [[NSString alloc] initWithUTF8String:conStrP];
    return uppercase;
}

//获取手机uuid，作为rand
-(NSString*)rand_uuid
{
//    CFUUIDRef uuid_ref = CFUUIDCreate(NULL);
//    
//    CFStringRef uuid_string_ref= CFUUIDCreateString(NULL, uuid_ref);
//    
//    
//    CFRelease(uuid_ref);
    
//    NSString *uuid = [NSString stringWithString:(NSString*)uuid_string_ref];
    
    
//    CFRelease(uuid_string_ref);
    NSString *uuid = @"1234567890";
    return uuid;
    
}

#pragma mark -- md5
- (NSString *)md5:(NSString *)str
{
    if (str == nil) {
        return nil;
    }
    
    const char *cStr = [str UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, strlen(cStr), result); // This is the md5 call
    return [NSString stringWithFormat:
            @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}

//获取当前时间戳
-(NSString*)currentTimestamp
{
    NSString *sTime = [[NSString alloc] initWithFormat:@"%f", [[NSDate date] timeIntervalSince1970]*1000];
    NSLog(@"%@", sTime);
    return  [sTime substringToIndex:13];
}

-(NSString *)getPhoneModel
{
    size_t size;
    // get the length of machine name
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    // get machine name
    char *machine = (char*)malloc(size);
    sysctlbyname("hw.machine", machine, &size, NULL, 0);
    NSString *platform = [NSString stringWithCString:machine encoding:NSASCIIStringEncoding];
    free(machine);
    if ([platform isEqualToString:@"iPhone1,1"])    return @"iPhone 1G";
    if ([platform isEqualToString:@"iPhone1,2"])    return @"iPhone 3G";
    if ([platform isEqualToString:@"iPhone2,1"])    return @"iPhone 3GS";
    if ([platform isEqualToString:@"iPhone3,1"])    return @"iPhone 4";
    if ([platform isEqualToString:@"iPhone4,1"])    return @"iPhone 4S";
    if ([platform isEqualToString:@"iPhone5,1"])    return @"iPhone 5";
    if ([platform isEqualToString:@"iPhone5,3"])    return @"iPhone 5C";
    if ([platform isEqualToString:@"iPhone6,1"])    return @"iPhone 5S";
    if ([platform isEqualToString:@"iPhone7,2"])    return @"iPhone 6";
    if ([platform isEqualToString:@"iPhone3,2"])    return @"Verizon iPhone 4";
    if ([platform isEqualToString:@"iPod1,1"])      return @"iPod Touch 1G";
    if ([platform isEqualToString:@"iPod2,1"])      return @"iPod Touch 2G";
    if ([platform isEqualToString:@"iPod3,1"])      return @"iPod Touch 3G";
    if ([platform isEqualToString:@"iPod4,1"])      return @"iPod Touch 4G";
    if ([platform isEqualToString:@"iPad1,1"])      return @"iPad";
    if ([platform isEqualToString:@"iPad2,1"])      return @"iPad 2(WiFi)";
    if ([platform isEqualToString:@"iPad2,2"])      return @"iPad 2(GSM)";
    if ([platform isEqualToString:@"iPad2,3"])      return @"iPad 2(CDMA)";
    if ([platform isEqualToString:@"iPad4,1"])      return @"iPad Air(WiFi)";
    if ([platform isEqualToString:@"i386"])         return @"Simulator";
    if ([platform isEqualToString:@"x86_64"])       return @"x64Simulator";
    else
        return platform;
}


-(NSString *)uploadPackage:(NSData*)imageData andindexPath:(NSInteger)indexPath
{
    NSString *upAction;
    NSString *username = @"b593b3d5-6f2e-4964-8319-1aa06b7d8f07";
    NSString *psd = @"ZpZeAqDTUbfOlatKSDPBprTUVWiKvn";
    NSString *md5Psd = [self md5:psd];
    NSString *deviceType = [self getPhoneModel];
    NSString *currentTime = [[NSString alloc] initWithString:[self currentTimestamp]];
    NSString *rand = [[NSString alloc] initWithString:[self rand_uuid]] ;
    if (indexPath == 0) {
        upAction = @"namecard.scan";
    }
    NSString *verify = [[NSString alloc] initWithFormat:@"%@%@%@%@%@", upAction, username, rand, currentTime, psd];
    verify = [self md5:verify];
    //    verify = [self lower2Uppercase:verify];
    
    int ocrlang = 2;
    int keylang = 0;
    NSString *fileExt = [self typeForImageData:imageData];
    
    NSString *imageStr = [imageData base64Encoding];
    
    NSMutableString *upPackageString = [[NSMutableString alloc] init] ;
    
    upPackageString = [[NSMutableString alloc] initWithFormat:@"<action>%@</action><client>%@</client><system>%@</system><password>%@</password><key>%@</key><time>%@</time><verify>%@</verify><ocrlang>%d</ocrlang><keylang>%d</keylang><ext>%@</ext><type>%@</type><file>%@</file>", upAction, username, deviceType, md5Psd, rand, currentTime, verify,ocrlang,keylang, fileExt,@"1", imageStr];
    
    NSMutableData *postData = (NSMutableData *)[upPackageString dataUsingEncoding:NSUTF8StringEncoding];
    
    [self doASIHttpWithData:postData];
    return [self analyResult];
}

//ASIHttp获取数据
-(void) doASIHttpWithData:(NSMutableData*)postData
{
    NSURL *url = [[NSURL alloc] initWithString:serverUrl];
    ASIHTTPRequest *urlRequest = [ASIHTTPRequest requestWithURL:url];
    [urlRequest setPostBody:postData];
    [urlRequest setDelegate:self];
    [urlRequest setRequestMethod:@"POST"];
    [urlRequest startSynchronous];
    NSError *error = [urlRequest error];
    if (!error) {
        NSData * nsData = [urlRequest responseData];
        self.result = [[NSString alloc]initWithBytes:[nsData bytes]length:[nsData length]encoding:NSUTF8StringEncoding];
    }
    else
    {
        self.result = ERROR_SERVER;
    }
}

-(NSString *)analyResult
{
    return self.result;
}

-(NSString *)typeForImageData:(NSData *)data
{
    uint8_t c;
    [data getBytes:&c length:1];
    switch (c) {
        case 0xFF:
            return @"jpeg";
            
        case 0x89:
            return @"png";
            
        case 0x47:
            return @"gif";
            
        case 0x49:
            
        case 0x4D:
            return @"tiff";
    }
    return nil;
}


@end
