//
//  MTAddressMonitor.m
//  MTalker
//
//  Created by 何霞雨 on 2017/3/27.
//  Copyright © 2017年 rrun. All rights reserved.
//

#import "MTAddressMonitor.h"

#import "XY_NetWorkClient/BaseRequestClient.h"

@implementation MTAddressMonitor

+(instancetype)instance{
    static MTAddressMonitor *_instance=nil;
    @synchronized(self){
        if(_instance==nil)
            _instance =[[MTAddressMonitor alloc] init];
    }
    return _instance;
}

//获取网络配置
-(void)patchAddressWithFinshiBlock:(void (^)(MTServerAddress *address,NSError *error))block{
    
    if (_addresses) {
        block(_addresses,nil);
    }
    [BaseRequestClient defaultClient].rightCode = 0;
    [BaseRequestClient defaultClient].statusKey = @"resultCode";
    [BaseRequestClient defaultClient].resultKey = @"result";
    
    [[BaseRequestClient defaultClient] jsonPostGlobal:self.api forParams:self.parmas successCall:^(NSDictionary *responseObject) {
        MTServerAddress *temp = [MTServerAddress mj_objectWithKeyValues:[responseObject objectForKey:@"result"]];
        
        if (!_addresses && temp ) {
            _addresses = temp;
            block(temp,nil);
        }
    } failedCall:^(NSError *error) {
        if (!_addresses) {
            block(nil,error);
        }
    }];
    
}

@end
