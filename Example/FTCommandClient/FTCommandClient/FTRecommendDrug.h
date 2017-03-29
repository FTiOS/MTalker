//
//  FTRecommendDrug.h
//  Talkback
//
//  Created by xiachao on 15/6/25.
//
//

#import <Foundation/Foundation.h>
#import "FTJsonSerializable.h"


#define FT_STORE_TYPE_VIRTUAL 0
#define FT_STORE_TYPE_ENTITY 1
#define FT_STORE_TYPE_STORE_END 2
#define FT_STORE_STATUS_OFFLINE 0
#define FT_STORE_STATUS_ONLINE 1

@interface FTRecommendDrug : NSObject<FTJsonSerializable>

@property (nonatomic) int64_t storeId;//配送药店id
@property (nonatomic) NSString* name;//	配送药店名称
@property (nonatomic) double longitude;//	配送药店经度
@property (nonatomic) double latitude;//	配送药店纬度
@property (nonatomic) NSString* address;//配送药店地址
@property (nonatomic) int type;//药店类型
@property (nonatomic) int status;//药店状态
@property (nonatomic) NSArray *drugInfos;//List<DrugInfo>

@property (nonatomic) double postage; //药店收取邮费



@end
