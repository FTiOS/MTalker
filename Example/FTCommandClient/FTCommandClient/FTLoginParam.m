//
//  FTLoginParam.m
//  Talkback
//
//  Created by xiachao on 15/6/25.
//
//

#import "FTLoginParam.h"

@implementation FTLoginParam

+(FTLoginParam *)instance{
    static FTLoginParam *instance = nil;
    @synchronized(self) {
        if (instance == nil) {
            instance = [[FTLoginParam alloc]init];
        }
    }
    return instance;
}


-(void)serialize:(NSMutableDictionary *)jsonObject{
    if ([_account length]!=0) {
        [jsonObject setObject:_account forKey:@"account"];
    }
    [jsonObject setObject:_deviceType forKey:@"deviceType"];
    [jsonObject setObject:_osVersion forKey:@"osVersion"];
    [jsonObject setObject:_appId forKey:@"appId"];
    [jsonObject setObject:_version forKey:@"version"];
    [jsonObject setObject:_deviceId forKey:@"deviceId"];
    [jsonObject setObject:_tokenId forKey:@"tokenId"];
    [jsonObject setObject:[NSNumber numberWithInt:_originType] forKey:@"originType"];
    [jsonObject setObject:[NSNumber numberWithLongLong:_originId] forKey:@"originId"];
    [jsonObject setObject:[NSNumber numberWithLong:_orderId] forKey:@"orderId"];//添加预支付订单id
    
//    if ([_druggistId length]!=0) {
//        [jsonObject setObject:_druggistId forKey:@"druggistId"];
//    }
    [jsonObject setObject:_druggistId forKey:@"druggistId"];
    [jsonObject setObject:[NSNumber numberWithLongLong:_doctorType] forKey:@"doctorType"];
    [jsonObject setObject:_resolution forKey:@"resolution"];
    [jsonObject setObject:_dpi forKey:@"dpi"];
    [jsonObject setObject:_osType forKey:@"osType"];
    [jsonObject setObject:_channel forKey:@"channel"];
    [jsonObject setObject:_cpu forKey:@"cpu"];
    
//    [jsonObject setObject:_userId forKey:@"userId"];
    [jsonObject setObject:_hospitalId forKey:@"hospitalId"];
    [jsonObject setObject:_offlineUserId forKey:@"offlineUserId"];
    
    [jsonObject setObject:_cardNo forKey:@"cardNo"];
    [jsonObject setObject:_cardSsno forKey:@"cardSsno"];
    [jsonObject setObject:_cardDeadline forKey:@"cardDeadline"];
    [jsonObject setObject:_cardType forKey:@"cardType"];
    [jsonObject setObject:_payType forKey:@"payType"];
    
    //其它传给调度的参数json字符串
    [jsonObject setObject:_others forKey:@"others"];
    
    [jsonObject setObject:_userName forKey:@"userName"];
    [jsonObject setObject:_userAvatar forKey:@"userAvatar"];
    
    [jsonObject setObject:_longitude forKey:@"longitude"];
    [jsonObject setObject:_latitude forKey:@"latitude"];
    
    [jsonObject setObject:[NSNumber numberWithLong:_apptId] forKey:@"apptId"];
    
}

-(void)deserialize:(NSDictionary *)jsonObject{
    //设备信息
    _deviceType = [jsonObject objectForKey:@"deviceType"];
    _osVersion = [jsonObject objectForKey:@"osVersion"];
    _appId = [jsonObject objectForKey:@"appId"];
    _version = [jsonObject objectForKey:@"version"];
    _deviceId = [jsonObject objectForKey:@"deviceId"];
    _tokenId = [jsonObject objectForKey:@"tokenId"];
    _resolution=[jsonObject objectForKey:@"resolution"];
    _dpi=[jsonObject objectForKey:@"dpi"];
    _osType=[jsonObject objectForKey:@"osType"];
    _channel=[jsonObject objectForKey:@"channel"];
    _cpu=[jsonObject objectForKey:@"cpu"];
    
    //帐号
    _account = [jsonObject objectForKey:@"account"];
    _hospitalId = [jsonObject objectForKey:@"hospitalId"];
    _offlineUserId = [jsonObject objectForKey:@"offlineUserId"];
    _originType = [[jsonObject objectForKey:@"originType"] intValue];
    _originId = [[jsonObject objectForKey:@"originId"] longLongValue];
    _doctorType = [[jsonObject objectForKey:@"doctorType"] intValue];
    _druggistId = [jsonObject objectForKey:@"druggistId"];
    _orderId = [[jsonObject objectForKey:@"orderId"] intValue];//添加预支付订单id
    //信用卡
    _cardNo = [jsonObject objectForKey:@"cardNo"];
    _cardSsno = [jsonObject objectForKey:@"cardSsno"];
    _cardDeadline = [jsonObject objectForKey:@"cardDeadline"];
    _cardType = [jsonObject objectForKey:@"cardType"];
    _payType = [jsonObject objectForKey:@"payType"];
    
    //其它传给调度的参数json字符串
    _others =[jsonObject objectForKey:@"others"];
    
    _userName = [jsonObject objectForKey:@"userName"];
    _userAvatar = [jsonObject objectForKey:@"userAvatar"];
    
    _longitude = [jsonObject objectForKey:@"longitude"];
    _latitude = [jsonObject objectForKey:@"latitude"];

    _apptId = [[jsonObject objectForKey:@"apptId"] longValue];
}

-(void)load {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    _account = [ud valueForKey:@"_account"];
    _deviceType = [ud valueForKey:@"_deviceType"];
    _osVersion = [ud valueForKey:@"_osVersion"];
    _appId = [ud valueForKey:@"_appId"];
    _version = [ud valueForKey:@"_version"];
    _deviceId = [ud valueForKey:@"_deviceId"];
    _tokenId = [ud valueForKey:@"_tokenId"];
    
    _orderId = (int)[ud valueForKey:@"_orderId"]; //添加预支付订单id
    _originType = (int)[ud integerForKey:@"_originType"];
    _originId = (int)[ud integerForKey:@"_originId"];
    
    _druggistId = [ud valueForKey:@"_druggistId"];
    _doctorType = (int)[ud integerForKey:@"_doctorType"];
    
    _hospitalId = [ud valueForKey:@"_hospitalId"];
    _offlineUserId = [ud valueForKey:@"_offlineUserId"];
    _cardNo = [ud valueForKey:@"_cardNo"];
    _cardSsno = [ud valueForKey:@"_cardSsno"];
    _cardDeadline = [ud valueForKey:@"_cardDeadline"];
    _cardType = [ud valueForKey:@"_cardType"];
    _payType = [ud valueForKey:@"_payType"];
    
    //其它传给调度的参数json字符串
    _others = [ud valueForKey:@"_others"];
    
    _userName = [ud valueForKey:@"userName"];
    _userAvatar = [ud valueForKey:@"userAvatar"];
    
    _longitude = [ud valueForKey:@"longitude"];
    _latitude = [ud valueForKey:@"latitude"];
    
    _apptId = (long)[ud valueForKey:@"_apptId"];
}

-(void)save{
    NSUserDefaults *ud =[NSUserDefaults standardUserDefaults];
    [ud setValue:_account forKey:@"_account"];
    [ud setValue:_deviceId forKey:@"_deviceId"];
    [ud setValue:_deviceType forKey:@"_deviceType"];
    [ud setValue:_osVersion forKey:@"_osVersion"];
    [ud setValue:_appId forKey:@"_appId"];
    [ud setValue:_version forKey:@"_version"];
    [ud setValue:_tokenId forKey:@"_tokenId"];
    
    [ud setInteger:_originType forKey:@"_originType"];
    [ud setInteger:_originId forKey:@"_originId"];
    
    [ud setValue:_druggistId forKey:@"_druggistId"];
    [ud setInteger:_doctorType forKey:@"_doctorType"];
    
    [ud setValue:_hospitalId forKey:@"_hospitalId"];
    [ud setValue:_offlineUserId forKey:@"_offlineUserId"];
    [ud setValue:_cardNo forKey:@"_cardNo"];
    [ud setValue:_cardSsno forKey:@"_cardSsno"];
    [ud setValue:_cardDeadline forKey:@"_cardDeadline"];
    [ud setValue:_cardType forKey:@"_cardType"];
    [ud setValue:_payType forKey:@"_payType"];
    
    [ud setInteger:_orderId forKey:@"_orderId"];//添加预支付订单id
    //其它传给调度的参数json字符串
    [ud setValue:_others forKey:@"_others"];
    
    [ud setValue:_userName forKey:@"userName"];
    [ud setValue:_userAvatar forKey:@"userAvatar"];

    [ud setValue:_longitude forKey:@"longitude"];
    [ud setValue:_latitude forKey:@"latitude"];
    
    [ud setValue:[NSNumber numberWithLong:_apptId] forKey:@"_apptId"];
        
    [ud synchronize];
}

@end
