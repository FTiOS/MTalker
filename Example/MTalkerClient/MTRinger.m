//
//  MTRinger.m
//  MTalker
//
//  Created by 何霞雨 on 2017/3/23.
//  Copyright © 2017年 rrun. All rights reserved.
//

#import "MTRinger.h"
#import <AudioToolbox/AudioServices.h>

@implementation MTRinger

//开始铃声
-(void)playRing{
    
    [self.basePlayer prepareToPlay];
    
    [self.basePlayer setVolume:1]; //设置音量大小
    self.basePlayer.numberOfLoops = -1;//设置音乐播放次数 -1为一直循环
    
    [self.basePlayer play]; //播放
}

//停止铃声
-(void)stopRing{

    [self.basePlayer stop];

}

//震动
-(void)vibrate{
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
}

#pragma mark - Getter
-(NSString *)ringPath{
    if (!_ringPath) {
        _ringPath = [[NSBundle mainBundle] pathForResource:@"3583" ofType:@"mp3"]; //创建音乐文件路径
    }
    return _ringPath;
}

-(AVAudioPlayer *)basePlayer{
    if (!_basePlayer) {
        NSURL *musicURL = [[NSURL alloc] initFileURLWithPath:self.ringPath];
        _basePlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:musicURL error:nil]; //创建音乐播放器
    }
    return _basePlayer;
}

@end
