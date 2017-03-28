//
//  BaseRequestClient.h
//  XY_NetworkClient
//
//  Created by 何霞雨 on 16/6/8.
//  Copyright © 2016年 何霞雨. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ErrorCodeAnalyzer.h"

static NSString *StatuCodeKey = @"resultCode";//默认的返回的数据中获取状态的key
static NSString *ResultKey = @"result";//默认的返回的数据中获取结果的key

@class AFHTTPSessionManager;
@interface BaseRequestClient : NSObject

@property (nonatomic,strong)ErrorCodeAnalyzer *errorAnlyzer;//错误码解析器
@property(nonatomic,strong)AFHTTPSessionManager *manager; //AF请求对象
@property (nonatomic,readonly,strong)NSMutableDictionary *defaultParmas;//所有接口都默认传递的参数

//返回结果状态码
@property (nonatomic,strong)NSString *statusKey;//返回的数据中获取状态的key
@property (nonatomic,strong)NSString *resultKey;//返回的数据中获取结果的key
@property (nonatomic,assign)NSInteger rightCode;//获取到正确数据的状态码,默认为0

//设置默认需要传递的参数
-(void)addInitParmarterWithKey:(NSString *)key Value:(id)value;
//单例
+(instancetype)defaultClient;

//异步请求-通用
-(void)jsonPostGlobal : (NSString*) url
            forParams : (NSDictionary*) params
          successCall : (void(^)(NSDictionary *responseObject))success
           failedCall : (void (^)(NSError *error))failure;
//停止当前URL请求
-(void)stopPostRequest:(NSString *)url;


///上传文件
/*
 ** params1:必须包含：fileName[上传文件对应的key值(img,file...)]
 */
#define  FILEKEY @"keyName"
/*
 ** params2:必须包含：fileType[上传文件对应的类型(jpg,png...)]
 */
#define  FILETYPE @"fileType"
/*
 ** params3:必须包含：fileType[上传文件对应的mimeTpe(image/png,image/jpeg,...)]
 */
#define  MIMETYPE @"mimeTpe"
///

//单个文件传输
-(void)JsonPostSingleFile:(NSString*) url forParams : (NSDictionary*) params forFile:(NSData *)data forProgress:(void (^)(NSProgress * progress))progresscall successCall : (void(^)(NSDictionary *responseObject))success failedCall : (void (^)(NSError *error))failure;


@end
