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
-(void)patchAddressWithFinshiBlock:(void (^)(NSArray<MTServerAddress *> *addresses,NSError *error))block{
    
    if (_addresses) {
        block(_addresses,nil);
    }
    
    [[BaseRequestClient defaultClient] jsonPostGlobal:self.api forParams:self.parmas successCall:^(NSDictionary *responseObject) {
        NSArray *temp = [MTServerAddress mj_objectArrayWithKeyValuesArray:[responseObject objectForKey:VauleKey]];
        if (!_addresses && [temp count]>0) {
            block(temp,nil);
        }
        _addresses = temp;
        
    } failedCall:^(NSError *error) {
        if (!_addresses) {
            block(nil,error);
        }
    }];
    
}

//获取对应的网络地址
-(MTServerAddress *)getServerAddress:(ServerAddressType)type{
    __block MTServerAddress *address = nil;
   [_addresses enumerateObjectsUsingBlock:^(MTServerAddress * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
       if (type == obj.type) {
           address = obj;
           *stop = YES;
       }
   }];
    
    return address;
}
@end
