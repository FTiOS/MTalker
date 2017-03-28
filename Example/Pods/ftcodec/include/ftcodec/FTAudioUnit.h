//
//  FTAudioUnit.h
//  Talkback
//
//  Created by xiachao on 15/1/23.
//
//

#import <Foundation/Foundation.h>


@interface FTAudioUnit : NSObject

@property (nonatomic) int sampleRate;
@property (nonatomic) int channels;
@property (nonatomic) int frameSize;

-(BOOL) isStarted;
-(BOOL) start:(BOOL)speaker;
-(void) stop;
-(BOOL) openSpeaker;
-(BOOL) closeSpeaker;
-(BOOL) read:(NSMutableData*)data size:(int)size;
-(BOOL) write:(const uint8_t*)data size:(int)size;

@end
