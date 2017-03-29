//
//  MTRinger.h
//  MTalker
//
//  Created by 何霞雨 on 2017/3/23.
//  Copyright © 2017年 rrun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVAudioPlayer.h>

@interface MTRinger : NSObject

@property (nonatomic,strong)NSString *ringPath;
@property (nonatomic,strong)AVAudioPlayer *basePlayer;

//开始铃声
-(void)playRing;
//停止铃声
-(void)stopRing;

//震动
-(void)vibrate;

@end
