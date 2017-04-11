//
//  BaseRequestClient.m
//  XY_NetworkClient
//
//  Created by 何霞雨 on 16/6/8.
//  Copyright © 2016年 何霞雨. All rights reserved.
//

#import "BaseRequestClient.h"

#import "AFNetworking.h"

#import "NSMutableDictionary+FTMutableDictionary.h"
#import "NSDictionary+FTDictionary.h"

@implementation BaseRequestClient{
    NSMutableDictionary<NSString *,NSURLSessionDataTask *> *requestDic;//请求中的字典［url-request］;
}
@synthesize defaultParmas;

#pragma mark - init
//单例
+(instancetype)defaultClient{
     static BaseRequestClient *shareClient = nil;
     static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        shareClient = [[self alloc] init];
    });
    return shareClient;
}

-(id)init{
    self= [super init];
    //enter the code what u want to init;
    [self httpInit];
    requestDic = [NSMutableDictionary new];
    return self;
}


/**
 * 初始化HTTP
 */
- (void)httpInit{
    
    //应用配置文件
    self.manager =[AFHTTPSessionManager manager];
    
    [self.manager.requestSerializer setValue:@"application/json;charset=utf-8" forHTTPHeaderField:@"Accept"];
    [self.manager.requestSerializer setValue:@"text/html;charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    //请求数据－放在httpbody 内容是nsdictory json化
    [self.manager.requestSerializer setQueryStringSerializationWithBlock:^NSString *(NSURLRequest *request, NSDictionary *parameters, NSError *__autoreleasing *error) {
        NSString *soapMessage;
        NSData *data=[NSJSONSerialization dataWithJSONObject:parameters options:NSJSONWritingPrettyPrinted error:nil];
        soapMessage=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        return soapMessage;
    }];
    
    //如果报接受类型不一致请替换一致text/html
    self.manager.responseSerializer = [AFJSONResponseSerializer serializer];
    self.manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", nil];
    //清求超时时间
    self.manager.requestSerializer.timeoutInterval = 15;

}

#pragma mark - Pamras [参数]
-(void)addInitParmarterWithKey:(NSString *)key Value:(id)value{
    [self.defaultParmas ft_setObject:value forKey:key];
}

#pragma mark - async network[异步请求]
-(void)jsonPostGlobal : (NSString*) url
            forParams : (NSDictionary*) params
          successCall : (void(^)(NSDictionary *responseObject))success
           failedCall : (void (^)(NSError *error))failure{
    
    NSLog(@"网络请求URL:%@",url);
    
    //参数设置
    NSMutableDictionary *postParmas= [[NSMutableDictionary alloc]initWithDictionary:params];
    [postParmas addEntriesFromDictionary:self.defaultParmas];
    NSLog(@"网络请求参数为:%@",postParmas);
    
    //网络请求
    NSURLSessionDataTask *currentTask = [self.manager POST:url parameters:postParmas success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (currentTask.state == NSURLSessionTaskStateCanceling) {
            return ;
        }
        NSLog(@"网络请求成功:%@",responseObject);
        [requestDic removeObjectForKey:url];//移除对应的task
        
        NSInteger statusCode = [[responseObject ft_numberForKey:self.statusKey] integerValue];
        if (statusCode == self.rightCode) {
            dispatch_async(dispatch_get_main_queue(), ^{
                success(responseObject);
            });
            
        }else{
            NSError *error = [self.errorAnlyzer desErrorCode:statusCode];
            if (!error) {
                error = [[NSError alloc]initWithDomain:@"com.xy_network.www" code:-1 userInfo:nil];
            }
            NSLog(@"网络请求失败:%@",error);
            dispatch_async(dispatch_get_main_queue(), ^{
                failure(error);
            });
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (currentTask.state == NSURLSessionTaskStateCanceling) {
            return ;
        }
        [requestDic removeObjectForKey:url];//移除对应的task
        NSError *recError = [self.errorAnlyzer desErrorCode:error.code];
        if (!recError) {
            recError = error;
        }
        NSLog(@"网络请求失败:%@",[error localizedDescription]);
        dispatch_async(dispatch_get_main_queue(), ^{
            failure(recError);
        });
    }];
    
    [requestDic ft_setObject:currentTask forKey:url];//添加对应的task
    
    [currentTask resume];//开始执行
}
-(void)JsonPostSingleFile:(NSString*) url forParams : (NSDictionary*) params forFile:(NSData *)data forProgress:(void (^)(NSProgress * progress))progresscall successCall : (void(^)(NSDictionary *responseObject))success failedCall : (void (^)(NSError *error))failure{
    NSLog(@"网络请求URL:%@",url);
    
    //参数设置
    NSMutableDictionary *postParmas= [[NSMutableDictionary alloc]initWithDictionary:params];
    [postParmas setDictionary:self.defaultParmas];
    NSLog(@"网络请求参数为:%@",postParmas);
    
    //文件名解析
    NSString *fileKey = [params objectForKey:FILEKEY];
    NSString *fileType = [params objectForKey:FILETYPE];
    NSString *mimeType = [params objectForKey:MIMETYPE];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyyMMddHHmmss";
    NSString *str = [NSString stringWithFormat:@"%@",[formatter stringFromDate:[NSDate date]]];
    NSString *fileName = [NSString stringWithFormat:@"%@.%@", str,fileType];
    
    [postParmas setObject:fileName forKey:@"fileName"];
    
    //网络请求
    NSURLSessionDataTask *currentTask =[self.manager POST:url parameters:postParmas constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        [formData appendPartWithFileData:data name:fileKey fileName:fileName mimeType:mimeType];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        progresscall(uploadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (currentTask.state == NSURLSessionTaskStateCanceling) {
            return ;
        }
        [requestDic removeObjectForKey:url];//移除对应的task
        
        NSInteger statusCode = [[responseObject ft_numberForKey:self.statusKey] integerValue];
        if (statusCode == self.rightCode) {
            dispatch_async(dispatch_get_main_queue(), ^{
                success(responseObject);
            });
        }else{
            NSError *error = [self.errorAnlyzer desErrorCode:statusCode];
            if (!error) {
                error = [NSError new];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                failure(error);
            });
        }
        
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:responseObject options:NSJSONWritingPrettyPrinted error:nil];
        NSString *jsonStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        jsonStr = [jsonStr stringByReplacingOccurrencesOfString:@"\\/" withString:@"/"];//替换转换url时产生的\/斜杠
        NSLog(@"网络请求成功:\n:%@",jsonStr);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"网络请求失败:%@",[error localizedDescription]);
        
        if (currentTask.state == NSURLSessionTaskStateCanceling) {
            return ;
        }
        [requestDic removeObjectForKey:url];//移除对应的task
        NSError *recError = [self.errorAnlyzer desErrorCode:error.code];
        if (!recError) {
            recError = error;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            failure(recError);
        });
    }];
    
    [requestDic ft_setObject:currentTask forKey:url];//添加对应的task
    [currentTask resume];//开始执行
    
}
-(void)stopPostRequest:(NSString *)url{
    NSURLSessionDataTask *currentTask = [requestDic objectForKey:url];
    if (!currentTask) {
        NSLog(@"当前%@网络请求已经不存在了！",url);
        return;
    }
    [requestDic removeObjectForKey:url];//移除task
    
    [currentTask cancel];
}
#pragma mark - sync network[同步请求]

#pragma mark - Getter and Setter
-(NSMutableDictionary *)defaultParmas{
    if (!defaultParmas) {
        defaultParmas = [[NSMutableDictionary alloc]init];
    }
    return defaultParmas;
}
-(NSString *)statusKey{
    if (!_statusKey) {
        _statusKey = StatuCodeKey;
    }
    return _statusKey;
}
-(NSString *)resultKey{
    if (!_resultKey) {
        _resultKey = ResultKey;
    }
    return _resultKey;
}
@end
