//
//  EasyUI.h
//  EasyUI
//
//  Created by 何霞雨 on 2017/3/29.
//  Copyright © 2017年 何霞雨. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ConsultViewController.h"


/**
 网络上传图片的回调，上传成功调用SuccessBlock，上传失败调用FailBlock，上传进度调用ProgressBlock

 @param progress 进度
 @param index 上传中图片的index
 */
typedef void (^ProgressBlock)(NSProgress * _Nullable progress, int index);

/**
 上传成功的回调

 @param imagePath 上传图片的路径
 */
typedef void (^SuccessBlock)(NSString * _Nullable imagePath);


/**
 上传失败的回调

 @param error 上传失败的原因
 */
typedef void (^FailBlock)(NSError * _Nullable error);

@class EasyUISettings;
@interface EasyUI : NSObject


/**
 配置器创建

 @return easyui 配置器
 */
+(instancetype _Nonnull )instance;

/**
 加载配置，返回咨询页面

 @param settings 设置的model
 @param startBlock 设置成功，开始咨询的回调
 @param finishBlock 咨询完成后的回调
 */
-(void)setup:(EasyUISettings *_Nonnull)settings startBlock:(void(^_Nonnull)(ConsultViewController * _Nullable consultVC))startBlock finishBlock:(void(^_Nonnull)(ConsultViewController * _Nullable consultVC,double callTime))finishBlock;


/**
 上传图片

 @param uploadBlock 网络上传处理，成功后调用successcall
 @param progresscall 上传进度
 @param successCall 成功上传回调
 @param failedCall 失败上传回调
 */
-(void)setUploadImages:(void(^_Nonnull)(NSArray<UIImage *> * _Nullable images,ProgressBlock _Nullable progressBlock,SuccessBlock _Nullable successBlock,FailBlock _Nullable failBlock))uploadBlock;

@end


/**
 创建咨询页面的配置信息
 */
@interface EasyUISettings : NSObject

@property (nonatomic,strong,nullable)NSString *api;//设置service地址，一般不用设置
@property (nonatomic,assign)int port;//设置service端口，一般不用设置

@property (nonatomic,strong,nonnull)NSString *platformKey;//平台密钥
@property (nonatomic,strong,nonnull)NSString *appId;//应用id

@property (nonatomic,strong,nonnull)NSString *tel;//用户电话
@property (nonatomic,strong,nonnull)NSString *dUserId;//用户ID

@property (nonatomic,strong,nonnull)NSString *account;//医生账号

@end
