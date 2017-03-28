//
//  MediaFormat.h
//  AVTest
//
//  Created by xiachao on 14-9-14.
//  Copyright (c) 2014年 xiachao. All rights reserved.
//

#ifndef AVTest_MediaFormat_h
#define AVTest_MediaFormat_h

/**
 *  媒体类型
 */
#define FT_MEDIA_TYPE_VIDEO 1
#define FT_MEDIA_TYPE_AUDIO 2
#define FT_MEDIA_TYPE_PICTURE 3

/**
 *  编码格式定义
 */
#define FT_CODEC_TYPE_NONE		0x00
#define FT_CODEC_TYPE_H264		0x01
#define FT_CODEC_TYPE_VP8		0x02//音视频通信使用的编码

#define FT_CODEC_TYPE_PCM		0x10//内部使用
#define FT_CODEC_TYPE_AAC		0x11//暂未使用
#define FT_CODEC_TYPE_MP3		0x12//录音使用的编码方式
#define FT_CODEC_TYPE_OPUS		0x13//音频通信使用的编码

#endif
