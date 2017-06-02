//
//  FTLoginParam.h
//  Talkback
//
//  Created by xiachao on 15/6/25.
//
//

#import <Foundation/Foundation.h>
#import "FTJsonSerializable.h"

@interface FTLoginParam : NSObject<FTJsonSerializable>
/**
 * 咨询账号
 * 如果是设备登录不设置
 */
@property(nonatomic) NSString *account;

/**
 * 设备类型
 * 使用代码: Build.HARDWARE + " " + Build.MODEL;
 */
@property(nonatomic) NSString *deviceType;

/**
 * 设备系统操作系统版本号
 * 使用代码：Build.VERSION.RELEASE
 */
@property(nonatomic) NSString *osVersion;

/**
 * app包名
 */
@property(nonatomic) NSString *appId;

/**
 * app版本号
 * 在调用者app中使用代码：BuildConfig.VERSION_NAME
 */
@property(nonatomic) NSString *version;

/**
 * 设备号 imei
 * 和account必须设置其中之一
 */
@property(nonatomic) NSString *deviceId;
/**
 * 手机分辨率
 */
@property(nonatomic) NSString *resolution;
/**
 * 手机dpi
 */
@property(nonatomic) NSString *dpi;
/**
 * "IOS"或"Android"
 */
@property(nonatomic) NSString *osType;
/**
 * 应用渠道 默认为sdk
 */
@property(nonatomic) NSString *channel;
/**
 * CPU类型
 */
@property(nonatomic) NSString *cpu;
/**
 * 用户或设备登录的令牌id
 */
@property(nonatomic) NSString *tokenId;
/**
 *  预支付订单id
 */
@property(nonatomic) long orderId;

/**
 *  线上挂号预约id
 */
@property (nonatomic) long apptId;

/**
 * 咨询源类型
 * 1-咨询（平台医生），
 * 2-咨询（私人医生），
 * 3-测量（ROOTi设备自动测量）
 * 4-就医（外出就医病历），
 * 5-回访（私人医生文字回访），
 * 6-咨询（平台药师）
 */
@property(nonatomic) int originType;

/**
 * 如果 是测量咨询和就医记录咨询的需要 传该值，0为无效值
 */
@property(nonatomic) int64_t originId;


/**
 * 医生类型
 */
@property(nonatomic) int doctorType;


/**
 * 医生账号
 */
//@property(nonatomic) NSString *doctorAccount;
@property(nonatomic) NSString *userName;//用户名称
@property(nonatomic) NSString *userAvatar;//用户头像

@property(nonatomic) NSString *hospitalId;//医院id
@property(nonatomic) NSString *druggistId;//医生帐号
@property(nonatomic) NSString *userId;//用户线上id
@property(nonatomic) NSString *offlineUserId;//用户线下id
@property(nonatomic) NSString *cardNo;//信用卡号
@property(nonatomic) NSString *cardSsno;//CVV卡安全码
@property(nonatomic) NSString *cardDeadline;//信用卡有效期
@property(nonatomic) NSString *cardType;//类型
@property(nonatomic) NSString *payType;//支付类型

@property(nonatomic) NSString *others;//其它传给调度的参数json字符串

@property(nonatomic) NSString *longitude;//经纬度
@property(nonatomic) NSString *latitude;//经纬度

+(FTLoginParam *) instance;

-(void) save;

-(void) load;

@end
