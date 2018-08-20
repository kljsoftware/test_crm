//
//  BIUPNetworkManager.h
//  Biup
//
//  Created by Sunny on 2018/7/23.
//  Copyright © 2018年 rekoo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking.h>
@class BIUPError;

#define GET_METHOD      @"GET"
#define POST_METHOD     @"POST"
#define NetWorkManager  [BIUPNetworkManager sharedManager]

/** 请求结束回调*/
typedef void (^RequestSuccess)(NSURLSessionDataTask *task, id responseObject);
typedef void (^RequestFailure)(NSURLSessionDataTask *task, BIUPError *error);
/** 上传/下载进度回调*/
typedef void (^RequestProgress)(NSProgress *progress);

/**
 网络请求工具类
 */
@interface BIUPNetworkManager : NSObject

/**
 创建单利对象

 @return self
 */
+ (instancetype)sharedManager;

/**
 网络请求入口
 
 @param method  方法 GET POST
 @param url     二级接口(如果没有测试服务器，直接传完整URL)
 @param params  参数
 @param success 成功回调
 @param failure 失败回调
 */
- (void)request:(NSString *)method
            URL:(NSString *)url
     parameters:(NSDictionary *)params
        success:(RequestSuccess)success
        failure:(RequestFailure)failure;

@end


/**
 错误模型
 */
@interface BIUPError : NSObject

/**
 错误码
 */
@property (nonatomic, assign) NSInteger code;

/**
 错误信息
 */
@property (nonatomic, strong) NSString *message;

/**
 实例化方法

 @param error error
 @return self
 */
- (instancetype)initWithError:(NSError *)error;

@end
