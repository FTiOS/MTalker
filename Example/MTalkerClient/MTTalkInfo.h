//
//  MTTalkInfo.h
//  MTalker
//
//  Created by 何霞雨 on 2017/3/22.
//  Copyright © 2017年 rrun. All rights reserved.
//

#import "MTModel.h"

//--------------调试统计信息--------------
@interface MTTalkInfo : MTModel

//音频统计
@property (assign,nonatomic)  int audioSendPackCount;
@property (assign,nonatomic)  int audioSendDataSize;
@property (assign,nonatomic)  int audioRecvPackCount;
@property (assign,nonatomic)  int audioRecvDataSize;

//视频统计
@property (assign,nonatomic)  int videoSendPackCount;
@property (assign,nonatomic)  int videoSendDataSize;
@property (assign,nonatomic)  int videoRecvPackCount;
@property (assign,nonatomic)  int videoRecvDataSize;

@end
