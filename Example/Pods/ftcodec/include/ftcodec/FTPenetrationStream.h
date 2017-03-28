//
//  FTPenetrationStream.h
//  Talkback
//
//  Created by xiachao on 15/1/16.
//
//

#import <Foundation/Foundation.h>
#import "FTMediaStream.h"



@protocol FTPenetrationFailDelegate <NSObject>
-(void) penetrationFail:(int)code;
@end

@interface FTPenetrationStream : NSObject<FTMediaStream>
@property (nonatomic,weak) id<FTMediaStreamDelegate> streamDelegate;
@property (nonatomic,strong) NSString* ip;
@property (nonatomic) int32_t port;
@property (nonatomic,strong) NSString* targetId;
@property (nonatomic,weak) id<FTPenetrationFailDelegate> penetrationFailDelegate;

-(instancetype) init;
-(BOOL) start;
-(BOOL) isStarted;
-(void) stop;
-(int32_t) send:(const uint8_t*)data
           size:(int)size
      mediaType:(int)mediaType;
@end
