//
//  UIImageView+Util.m
//  sales
//
//  Created by user on 2016/11/9.
//  Copyright © 2016年 rayootech. All rights reserved.
//

#import <SDWebImage/UIImageView+WebCache.h>
#import <CommonCrypto/CommonHMAC.h>
#import <CommonCrypto/CommonDigest.h>
#import <QN_GTM_Base64.h>
#import <QNUrlSafeBase64.h>

@implementation UIImageView (Util)

- (void)loadPortrait:(NSString *)portraitURL
{
    if ([NSStringUtils isEmpty:portraitURL]) {
        portraitURL = @"";
    }
    NSURL *url = [NSURL URLWithString:[QINIU stringByAppendingString:portraitURL]];
    NSString *str = [QINIU stringByAppendingString:portraitURL];
    NSRange rang = [str rangeOfString:@"?"];
    if (rang.location != NSNotFound) {
        str = [str stringByAppendingString:@"&e=2049840000"];
    }else{
        str = [str stringByAppendingString:@"?e=2049840000"];
    }
    /*
#kY7FjqBcZLCJ_DmgO02DqxcIO4Dgi4pSBb3D8HKg
#0tCiEsbLAD2zYirGWOo6qBxQXDI8JJ0aVRZfuog3
#sv1pbO9prG756lgA72aQd2V-SmxB6xuL0wjGVBgP
#3zhXb6H7L-Jjr76xSh5-gTdsGJ6wNnPMM-Ni7LBa
    */
    NSString *sign =  [self hmacsha1:str key:@"kY7FjqBcZLCJ_DmgO02DqxcIO4Dgi4pSBb3D8HKg"];
    
//    NSString *encode = [QNUrlSafeBase64 encodeString:sign];
    NSString *token = [NSString stringWithFormat:@"3zhXb6H7L-Jjr76xSh5-gTdsGJ6wNnPMM-Ni7LBa:%@",sign];
    str = [NSString stringWithFormat:@"%@&token=%@",str,token];
    url = [NSURL URLWithString:str];
    [self sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"default-portrait"]];
    
}

- (NSString *)hmacsha1:(NSString *)url key:(NSString *)secret{
    const char *cKey = [secret cStringUsingEncoding:NSUTF8StringEncoding];
    const char *cData = [url cStringUsingEncoding:NSUTF8StringEncoding];
    uint8_t cHMAC[CC_SHA1_DIGEST_LENGTH];
    CCHmac(kCCHmacAlgSHA1, cKey, strlen(cKey), cData, strlen(cData), cHMAC);
    
    NSString *hash;
//    NSMutableString *output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
//    for (int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++) {
//        [output appendFormat:@"%02x",cHMAC[i]];
//    }
//    hash = output;
    NSData *hmac = [[NSData alloc] initWithBytes:cHMAC length:sizeof(cHMAC)];
    hash = [QNUrlSafeBase64 encodeData:hmac];
    return hash;
}

- (NSString *)rongPortrait:(NSString *)avatar{
    if ([NSStringUtils isEmpty:avatar]) {
        avatar = @"";
    }
    NSString *str = [QINIU stringByAppendingString:avatar];
    NSRange rang = [str rangeOfString:@"?"];
    if (rang.location != NSNotFound) {
        str = [str stringByAppendingString:@"&e=2049840000"];
    }else{
        str = [str stringByAppendingString:@"?e=2049840000"];
    }
    NSString *sign =  [self hmacsha1:str key:@"0tCiEsbLAD2zYirGWOo6qBxQXDI8JJ0aVRZfuog3"];
    NSString *token = [NSString stringWithFormat:@"sv1pbO9prG756lgA72aQd2V-SmxB6xuL0wjGVBgP:%@",sign];
    str = [NSString stringWithFormat:@"%@&token=%@",str,token];
    return str;
}
@end
