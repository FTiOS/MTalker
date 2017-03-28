//
//  FTMediaStream.h
//  Talkback
//
//  Created by xiachao on 15/1/15.
//
//

#import <Foundation/Foundation.h>
#import "FTMediaFormat.h"

@protocol FTMediaStreamDelegate <NSObject>

-(void) outputStream:(const uint8_t*)data
                size:(int)size
           mediaType:(int)mediaType;
@end


@protocol FTMediaStream <NSObject>

@property (nonatomic,weak) id<FTMediaStreamDelegate> streamDelegate;
@property (nonatomic,strong) NSString* ip;
@property (nonatomic) int32_t port;

-(BOOL) start;
-(BOOL) isStarted;
-(void) stop;
-(int32_t) send:(const uint8_t*)data
           size:(int)size
      mediaType:(int)mediaType;

@end
