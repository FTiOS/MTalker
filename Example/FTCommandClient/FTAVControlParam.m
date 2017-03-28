//
//  FTAVControlParam.m
//  Talkback
//
//  Created by xiachao on 15/9/19.
//
//
#define FT_CODEC_TYPE_NONE		0x00
#define FT_CODEC_TYPE_H264		0x01
#define FT_CODEC_TYPE_VP8		0x02//音视频通信使用的编码

#define FT_CODEC_TYPE_PCM		0x10//内部使用
#define FT_CODEC_TYPE_AAC		0x11//暂未使用
#define FT_CODEC_TYPE_MP3		0x12//录音使用的编码方式
#define FT_CODEC_TYPE_OPUS		0x13//音频通信使用的编码
#import "FTAVControlParam.h"

@implementation FTAVControlParam{
    
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _audio = YES;
        _audioCodec = FT_CODEC_TYPE_OPUS;
        _videoCodec =FT_CODEC_TYPE_VP8;
        
    }
    return self;
}


-(void)serialize:(NSMutableDictionary *)jsonObject{
    [jsonObject setObject:[NSNumber numberWithBool:_video] forKey:@"video"];
    [jsonObject setObject:[NSNumber numberWithBool:_audio] forKey:@"audio"];
    [jsonObject setObject:[NSNumber numberWithInt:_videoOrientation] forKey:@"videoOrientation"];
    [jsonObject setObject:[NSNumber numberWithInt:_screenWidth] forKey:@"screenWidth"];
    [jsonObject setObject:[NSNumber numberWithInt:_screenHeight] forKey:@"screenHeight"];
    [jsonObject setObject:[NSNumber numberWithInt:_audioCodec] forKey:@"audioCodec"];
    [jsonObject setObject:[NSNumber numberWithInt:_videoCodec] forKey:@"videoCodec"];
}

-(void)deserialize:(NSDictionary *)jsonObject{
    _video = [[jsonObject objectForKey:@"video"] boolValue];
    _audio = [[jsonObject objectForKey:@"audio"] boolValue];
    _videoOrientation = [[jsonObject objectForKey:@"videoOrientation"] intValue];
    _screenWidth = [[jsonObject objectForKey:@"screenWidth"] intValue];
    _screenHeight = [[jsonObject objectForKey:@"screenHeight"] intValue];
    _audioCodec = [[jsonObject objectForKey:@"audioCodec"] intValue];
    _videoCodec = [[jsonObject objectForKey:@"videoCodec"] intValue];
}

@end
