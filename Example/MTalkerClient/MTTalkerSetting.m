//
//  MTTalkerSetting.m
//  MTalker
//
//  Created by 何霞雨 on 2017/3/22.
//  Copyright © 2017年 rrun. All rights reserved.
//

#import "MTTalkerSetting.h"

@implementation MTTalkerSetting

-(int)frameRate{
    if (_frameRate == 0) {
        _frameRate = 15;
    }
    return _frameRate;
}

-(int)sampleRate{
    if (_sampleRate == 0) {
        _sampleRate = 16000;
    }
    return _sampleRate;
}

-(int)channels{
    if (_channels == 0) {
        _channels = 1;
    }
    return _channels;
}

-(int)videoBitRate{
    if (_videoBitRate == 0) {
        _videoBitRate = 128*1024;
    }
    return _videoBitRate;
}
-(int)audioBitRate{
    if (_audioBitRate == 0) {
        _audioBitRate = 12*1024;
    }
    return _audioBitRate;
}

#pragma mark - 服务器地址
-(NSString *)api{
    if (!_api) {
        _api = @"https://171.cdfortis.com:9443/appService/appTwo!getServerAddress2.action";
    }
    return _api;
}

@end
