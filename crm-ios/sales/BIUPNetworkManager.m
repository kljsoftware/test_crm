//
//  BIUPNetworkManager.h
//  Biup
//
//  Created by Sunny on 2018/7/23.
//  Copyright © 2018年 rekoo. All rights reserved.
//


@interface BIUPNetworkManager () 

@property (nonatomic, strong) AFHTTPSessionManager *httpManager;

@end

@implementation BIUPNetworkManager

// MARK: - 类方法
+ (instancetype)sharedManager {
    static BIUPNetworkManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];
    });
    return manager;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    static BIUPNetworkManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [super allocWithZone:zone];
    });
    return manager;
}

// MARK: - 公开方法
- (void)request:(NSString *)method URL:(NSString *)url requestHeader:(NSDictionary *)requestHeader parameters:(NSDictionary *)params success:(RequestSuccess)success failure:(RequestFailure)failure {

    self.httpManager.requestSerializer.timeoutInterval = 10;
    [self setRequestHeader:requestHeader];

    // 请求方式
    if ([method isEqualToString:GET_METHOD]) {
        
        [self P_GETWithURL:url parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
            
            NSInteger result = [responseObject[@"result"] integerValue];
            if (result == 1) {
                success ? success(task, responseObject) : nil;
            } else {
                NSString *urlStr = task.response.URL.absoluteString;
                NSString *message = responseObject[@"msg"];
                if ([urlStr containsString:API_PUSH_IDENTIFYCODE] || [urlStr containsString:API_REGISTER] || [urlStr containsString:API_FORGETPWD]) {
                    switch (result) {
                        case 0:
                            message = @"失败";
                            break;
                        case 2:
                            message = @"验证码校验失败";
                            break;
                        case 3:
                            message = @"验证码失效";
                            break;
                        case 101:
                            message = @"手机号码不能为空";
                            break;
                        case 102:
                            message = @"手机号码的格式不正确";
                            break;
                        case 1021:
                            message = @"手机号码已经注册过了";
                            break;
                        case 103:
                            message = @"密码不能为空";
                            break;
                        case 104:
                            message = @"密码长度不能小于6位";
                            break;
                        case 105:
                            message = @"原始密码不正确";
                            break;
                        case 106:
                            message = @"新密码不能为空";
                            break;
                        case 107:
                            message = @"新密码长度不能小于6位";
                            break;
                        case 108:
                            message = @"手机验证码不能为空";
                            break;
                        case 109:
                            message = @"手机验证码发送超时";
                            break;
                        case 110:
                            message = @"验证码发送超过上限";
                            break;
                        case 111:
                            message = @"该用户不存在";
                            break;
                        case 112:
                            message = @"姓名不能为空";
                            break;
                        default:
                            break;
                    }
                }
                BIUPError *errorInfo = [[BIUPError alloc] init];
                errorInfo.message = message;
                errorInfo.code = result;
                failure ? failure(task, errorInfo) : nil;
                NSLog(@"error: %@",errorInfo.message);
            }
       
        } failure:^(NSURLSessionDataTask *task, BIUPError *error) {
            
            failure ? failure(task, error) : nil;
            NSLog(@"error: %@",error.message);
        }];
        
    } else if ([method isEqualToString:POST_METHOD]) {
        
        [self P_POSTWithURL:url parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
            
            NSInteger result = [responseObject[@"result"] integerValue];
            if (result == 1) {
                success ? success(task, responseObject) : nil;
            } else {
                NSString *urlStr = task.response.URL.absoluteString;
                NSString *message = responseObject[@"msg"];
                if ([urlStr containsString:API_PUSH_IDENTIFYCODE] || [urlStr containsString:API_REGISTER] || [urlStr containsString:API_FORGETPWD]) {
                    switch (result) {
                        case 0:
                            message = @"失败";
                            break;
                        case 2:
                            message = @"验证码校验失败";
                            break;
                        case 3:
                            message = @"验证码失效";
                            break;
                        case 101:
                            message = @"手机号码不能为空";
                            break;
                        case 102:
                            message = @"手机号码的格式不正确";
                            break;
                        case 1021:
                            message = @"手机号码已经注册过了";
                            break;
                        case 103:
                            message = @"密码不能为空";
                            break;
                        case 104:
                            message = @"密码长度不能小于6位";
                            break;
                        case 105:
                            message = @"原始密码不正确";
                            break;
                        case 106:
                            message = @"新密码不能为空";
                            break;
                        case 107:
                            message = @"新密码长度不能小于6位";
                            break;
                        case 108:
                            message = @"手机验证码不能为空";
                            break;
                        case 109:
                            message = @"手机验证码发送超时";
                            break;
                        case 110:
                            message = @"验证码发送超过上限";
                            break;
                        case 111:
                            message = @"该用户不存在";
                            break;
                        case 112:
                            message = @"姓名不能为空";
                            break;
                        default:
                            break;
                    }
                }
                BIUPError *errorInfo = [[BIUPError alloc] init];
                errorInfo.message = message;
                errorInfo.code = result;
                failure ? failure(task, errorInfo) : nil;
                NSLog(@"error: %@",errorInfo.message);
            }
       
        } failure:^(NSURLSessionDataTask *task, BIUPError *error) {
            
            failure ? failure(task, error) : nil;
            NSLog(@"error: %@",error.message);
        }];
        
    } else {
        NSLog(@"Unrecognized request type");
    }
}

// GET
- (void)P_GETWithURL:(NSString *)URLString parameters:(NSDictionary *)params success:(RequestSuccess)success failure:(RequestFailure)failure {
    
    [self.httpManager GET:URLString parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        success(task, responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        BIUPError *errorInfo = [[BIUPError alloc] initWithError:error];
        failure ? failure(task, errorInfo) : nil;
    }];
}

// POST
- (void)P_POSTWithURL:(NSString *)URLString parameters:(NSDictionary *)params success:(RequestSuccess)success failure:(RequestFailure)failure {
    
    [self.httpManager POST:URLString parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        
        success(task, responseObject);

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        BIUPError *errorInfo = [[BIUPError alloc] initWithError:error];
        failure ? failure(task, errorInfo) : nil;
    }];
}

// 懒加载
- (AFHTTPSessionManager *)httpManager {
    if (!_httpManager) {
        _httpManager = [AFHTTPSessionManager manager];
        [_httpManager.responseSerializer setAcceptableContentTypes:[NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", @"text/css", @"text/plain", @"application/javascript", @"application/json", @"application/x-www-form-urlencoded", @"multipart/form-data", nil]];
    }
    return _httpManager;
}

- (void)setRequestHeader:(NSDictionary *)params {
    
    for (NSString *key in params.allKeys) {
        [self.httpManager.requestSerializer setValue:params[key] forHTTPHeaderField:key];
    }
}

@end

// MARK: - 错误信息
@implementation BIUPError

- (instancetype)initWithError:(NSError *)error {
    if (self = [super init]) {
        _code = error.code;
        _message = error.localizedDescription;
    }
    return self;
}

@end
