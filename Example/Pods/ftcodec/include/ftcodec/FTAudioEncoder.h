//
//  FTAudioEncoder2.h
//  Talkback
//
//  Created by xiachao on 15/1/20.
//
//
#import "FTMediaDelegate.h"
#import <Foundation/Foundation.h>
#import "FTAudioUnit.h"

@interface FTAudioEncoder : NSObject
@property (nonatomic) int bitrate;
@property (nonatomic,weak) id<FTMediaDelegate> mediaDelegate;
@property (nonatomic,weak) FTAudioUnit* audioUnit;

-(BOOL) isStarted;
-(BOOL) start;
-(void) stop;
@end
